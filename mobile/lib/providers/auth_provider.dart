// [S1] Identity, Family & Consent.
import 'dart:async';

import 'package:family_veda/providers/active_member_provider.dart';
import 'package:family_veda/providers/core_providers.dart';
import 'package:family_veda/services/api/auth_api.dart';
import 'package:family_veda/services/storage/secure_token_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({required this.status, this.errorMessage});

  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.authenticated() : this(status: AuthStatus.authenticated);
  const AuthState.unauthenticated({String? errorMessage})
    : this(status: AuthStatus.unauthenticated, errorMessage: errorMessage);

  final AuthStatus status;
  final String? errorMessage;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController({required AuthApi authApi, required TokenStore tokenStore})
    : _authApi = authApi,
      _tokenStore = tokenStore,
      super(const AuthState.loading()) {
    _expirationSubscription = _tokenStore.sessionExpirations.listen((_) {
      state = const AuthState.unauthenticated(
        errorMessage: 'Your session expired. Sign in again.',
      );
    });
    _restoreSession();
  }

  final AuthApi _authApi;
  final TokenStore _tokenStore;
  late final StreamSubscription<void> _expirationSubscription;

  Future<void> _restoreSession() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      state = const AuthState.unauthenticated();
      return;
    }
    try {
      final tokens = await _authApi.refresh(refreshToken);
      await _tokenStore.writeTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      state = const AuthState.authenticated();
    } on Object {
      await _tokenStore.clear();
      state = const AuthState.unauthenticated();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      final tokens = await _authApi.login(email: email, password: password);
      await _tokenStore.writeTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      state = const AuthState.authenticated();
      return true;
    } on Object catch (error) {
      state = AuthState.unauthenticated(
        errorMessage: userFacingApiError(error),
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } on Object {
      // Local credentials must still be removed when server revocation is unavailable.
    } finally {
      await _tokenStore.clear();
      state = const AuthState.unauthenticated();
    }
  }

  @override
  void dispose() {
    _expirationSubscription.cancel();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    authApi: ref.watch(authApiProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  );
});

final authLifecycleProvider = Provider<void>((ref) {
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (next.status != AuthStatus.unauthenticated) return;
    ref.read(activeMemberProvider.notifier).state = null;
    unawaited(ref.read(memberPreferenceStoreProvider).clearActiveMemberId());
  }, fireImmediately: true);
});

Future<void> logoutAndClearMember(WidgetRef ref) async {
  await ref.read(authProvider.notifier).logout();
}
