// [S1] Single source of truth for member-scoped patient data.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeMemberProvider = StateProvider<String?>((ref) => null);
