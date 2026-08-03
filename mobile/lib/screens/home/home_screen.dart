// [S3] Triage & Agent Orchestration.
import 'package:family_veda/providers/active_member_provider.dart';
import 'package:family_veda/providers/auth_provider.dart';
import 'package:family_veda/providers/members_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeMemberProvider);
    final members = ref.watch(membersProvider).valueOrNull ?? const [];
    final activeName = members
        .where((member) => member.id == activeId)
        .map((member) => member.displayName)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Veda'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => logoutAndClearMember(ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              activeName ?? 'Choose a family member',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              activeName == null
                  ? 'Select whose records and cases you want to view.'
                  : 'Viewing health activity for this member.',
            ),
            const SizedBox(height: 16),
            _HomeAction(
              icon: Icons.people_outline,
              title: 'Switch family member',
              onTap: () => context.push('/members'),
            ),
            _HomeAction(
              icon: Icons.folder_outlined,
              title: 'Health records',
              enabled: activeId != null,
              onTap: () => context.push('/records'),
            ),
            _HomeAction(icon: Icons.note_add_outlined, title: 'Add health record', enabled: activeId != null, onTap: () => context.push('/records/new')),
            _HomeAction(icon: Icons.monitor_heart_outlined, title: 'Record vital', enabled: activeId != null, onTap: () => context.push('/vitals/new')),
            _HomeAction(
              icon: Icons.add_comment_outlined,
              title: 'Submit a complaint',
              enabled: activeId != null,
              onTap: () => context.push('/complaints/new'),
            ),
            _HomeAction(
              icon: Icons.track_changes_outlined,
              title: 'Case status',
              enabled: activeId != null,
              onTap: () => context.push('/cases'),
            ),
            _HomeAction(
              icon: Icons.emergency_outlined,
              title: 'Emergency referral',
              onTap: () => context.push('/emergency'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      minVerticalPadding: 12,
      enabled: enabled,
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: enabled ? onTap : null,
    ),
  );
}
