import 'package:family_veda/services/storage/member_preference_store.dart';
import 'package:family_veda/services/storage/secure_token_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test(
    'access token stays in memory while refresh token persists securely',
    () async {
      final first = SecureTokenStore();
      await first.writeTokens(
        accessToken: 'memory-access',
        refreshToken: 'secure-refresh',
      );
      final second = SecureTokenStore();

      expect(await first.readAccessToken(), 'memory-access');
      expect(await second.readAccessToken(), isNull);
      expect(await second.readRefreshToken(), 'secure-refresh');
    },
  );

  test('active member preference can be written and cleared', () async {
    final store = SecureMemberPreferenceStore();
    await store.writeActiveMemberId('member-1');
    expect(await store.readActiveMemberId(), 'member-1');

    await store.clearActiveMemberId();
    expect(await store.readActiveMemberId(), isNull);
  });

  test('expiring a session clears tokens and emits event', () async {
    final store = SecureTokenStore();
    await store.writeTokens(
      accessToken: 'memory-access',
      refreshToken: 'secure-refresh',
    );
    final expiration = expectLater(store.sessionExpirations, emits(null));

    await store.expireSession();

    await expiration;
    expect(await store.readAccessToken(), isNull);
    expect(await store.readRefreshToken(), isNull);
  });
}
