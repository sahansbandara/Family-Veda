// [S1] Identity, Family & Consent.
import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class TokenStore {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> clear();
  Future<void> expireSession();
  Stream<void> get sessionExpirations;
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _refreshTokenKey = 'family_veda_refresh_token';
  final FlutterSecureStorage _storage;
  final StreamController<void> _sessionExpirations =
      StreamController<void>.broadcast();
  String? _accessToken;

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
    await _storage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> expireSession() async {
    await clear();
    _sessionExpirations.add(null);
  }

  @override
  Stream<void> get sessionExpirations => _sessionExpirations.stream;
}
