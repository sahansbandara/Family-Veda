// [S1] Identity, Family & Consent.
import 'package:family_veda/models/member.dart';
import 'package:family_veda/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final membersProvider = FutureProvider.autoDispose<List<Member>>(
  (ref) => ref.watch(patientApiProvider).getMembers(),
);
