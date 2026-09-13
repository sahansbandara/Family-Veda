// [S1] Active member persistence contains identifiers only, never clinical data.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class MemberPreferenceStore {
  Future<String?> readActiveMemberId({required String userId});
  Future<void> writeActiveMemberId({
    required String userId,
    required String memberId,
  });
  Future<void> clearActiveMemberId({required String userId});
}

class SecureMemberPreferenceStore implements MemberPreferenceStore {
  SecureMemberPreferenceStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _keyPrefix = 'family_veda_active_member_id';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> readActiveMemberId({required String userId}) =>
      _storage.read(key: _keyFor(userId));

  @override
  Future<void> writeActiveMemberId({
    required String userId,
    required String memberId,
  }) => _storage.write(key: _keyFor(userId), value: memberId);

  @override
  Future<void> clearActiveMemberId({required String userId}) =>
      _storage.delete(key: _keyFor(userId));

  static String _keyFor(String userId) => '${_keyPrefix}_$userId';
}
