// [S3] Triage & Agent Orchestration.
import 'package:family_veda/models/app_notification.dart';
import 'package:family_veda/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>(
  (ref) => ref.watch(patientApiProvider).getNotifications(),
);
