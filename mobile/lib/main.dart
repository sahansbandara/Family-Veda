// ⚠ SHARED — Family Veda Flutter application entry point.
import 'package:family_veda/providers/active_member_provider.dart';
import 'package:family_veda/providers/auth_provider.dart';
import 'package:family_veda/providers/core_providers.dart';
import 'package:family_veda/router/app_router.dart';
import 'package:family_veda/providers/push_registration_provider.dart';
import 'package:family_veda/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FamilyVedaApp()));
}

class FamilyVedaApp extends ConsumerStatefulWidget {
  const FamilyVedaApp({super.key});

  @override
  ConsumerState<FamilyVedaApp> createState() => _FamilyVedaAppState();
}

class _FamilyVedaAppState extends ConsumerState<FamilyVedaApp> {
  bool _memberRestored = false;

  Future<void> _restoreActiveMember() async {
    if (_memberRestored) return;
    _memberRestored = true;
    final memberId = await ref
        .read(memberPreferenceStoreProvider)
        .readActiveMemberId();
    if (mounted && memberId != null) {
      ref.read(activeMemberProvider.notifier).state = memberId;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authLifecycleProvider);
    ref.watch(pushRegistrationProvider);
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next.status == AuthStatus.authenticated) _restoreActiveMember();
      if (next.status == AuthStatus.unauthenticated) _memberRestored = false;
    });
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Family Veda',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
