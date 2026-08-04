import 'dart:async';

import 'package:family_veda/providers/auth_provider.dart';
import 'package:family_veda/providers/active_member_provider.dart';
import 'package:family_veda/providers/core_providers.dart';
import 'package:family_veda/services/api/auth_api.dart';
import 'package:family_veda/services/storage/member_preference_store.dart';
import 'package:family_veda/services/storage/secure_token_store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTokenStore implements TokenStore {
  final expirations = StreamController<void>.broadcast();
  String? accessToken;
  String? refreshToken;
  Object? readRefreshTokenError;
  Object? clearError;
  bool clearAttempted = false;

  @override
  Future<void> clear() async {
    clearAttempted = true;
    if (clearError case final error?) throw error;
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> expireSession() async {
    await clear();
    expirations.add(null);
  }

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async {
    if (readRefreshTokenError case final error?) throw error;
    return refreshToken;
  }

  @override
  Stream<void> get sessionExpirations => expirations.stream;

  @override
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

class _FakeAuthApi implements AuthApi {
  @override
  Future<void> logout() async {}

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async => const AuthTokens(accessToken: 'access', refreshToken: 'refresh');

  @override
  Future<AuthTokens> refresh(String refreshToken) async =>
      const AuthTokens(accessToken: 'new-access', refreshToken: 'new-refresh');
}

class _FakeMemberPreferenceStore implements MemberPreferenceStore {
  String? memberId;

  @override
  Future<void> clearActiveMemberId() async => memberId = null;

  @override
  Future<String?> readActiveMemberId() async => memberId;

  @override
  Future<void> writeActiveMemberId(String memberId) async {
    this.memberId = memberId;
  }
}

void main() {
  test(
    'secure storage failure fails closed instead of hanging startup',
    () async {
      final store = _FakeTokenStore()
        ..readRefreshTokenError = PlatformException(
          code: '-34018',
          message: 'A required entitlement isn\'t present.',
        )
        ..clearError = Exception('synthetic secure storage cleanup failure');
      final controller = AuthController(
        authApi: _FakeAuthApi(),
        tokenStore: store,
      );
      addTearDown(() {
        controller.dispose();
        store.expirations.close();
      });

      await pumpEventQueue();

      expect(store.clearAttempted, isTrue);
      expect(controller.state.status, AuthStatus.unauthenticated);
      expect(controller.state.errorMessage, isNull);
    },
  );

  test('session expiration immediately deauthenticates route state', () async {
    final store = _FakeTokenStore();
    final controller = AuthController(
      authApi: _FakeAuthApi(),
      tokenStore: store,
    );
    addTearDown(() {
      controller.dispose();
      store.expirations.close();
    });
    await controller.login(
      email: 'synthetic@example.test',
      password: 'password',
    );
    expect(controller.state.status, AuthStatus.authenticated);

    await store.expireSession();
    await pumpEventQueue();

    expect(controller.state.status, AuthStatus.unauthenticated);
    expect(controller.state.errorMessage, contains('expired'));
  });

  test('session expiration clears previous account member scope', () async {
    final tokenStore = _FakeTokenStore();
    final memberStore = _FakeMemberPreferenceStore();
    final container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(tokenStore),
        authApiProvider.overrideWithValue(_FakeAuthApi()),
        memberPreferenceStoreProvider.overrideWithValue(memberStore),
      ],
    );
    addTearDown(() {
      container.dispose();
      tokenStore.expirations.close();
    });
    container.read(authLifecycleProvider);
    await container
        .read(authProvider.notifier)
        .login(email: 'synthetic@example.test', password: 'password');
    container.read(activeMemberProvider.notifier).state = 'member-user-a';
    await memberStore.writeActiveMemberId('member-user-a');

    await tokenStore.expireSession();
    await pumpEventQueue();

    expect(container.read(activeMemberProvider), isNull);
    expect(await memberStore.readActiveMemberId(), isNull);
  });
}
