// [S1] Active member persistence contains identifiers only, never clinical data.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class MemberPreferenceStore {
  Future<String?> readActiveMemberId();
  Future<void> writeActiveMemberId(String memberId);
  Future<void> clearActiveMemberId();
}

class SecureMemberPreferenceStore implements MemberPreferenceStore {
  SecureMemberPreferenceStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'family_veda_active_member_id';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> readActiveMemberId() => _storage.read(key: _key);

  @override
  Future<void> writeActiveMemberId(String memberId) =>
      _storage.write(key: _key, value: memberId);

  @override
  Future<void> clearActiveMemberId() => _storage.delete(key: _key);
}
