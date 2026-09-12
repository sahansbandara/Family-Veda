// [S3] Triage & Agent Orchestration.
import 'package:family_veda/providers/active_member_provider.dart';
import 'package:family_veda/providers/auth_provider.dart';
import 'package:family_veda/providers/members_provider.dart';
import 'package:family_veda/theme/app_theme.dart';
import 'package:family_veda/theme/glass.dart';
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
    final theme = Theme.of(context);
    final hasMember = activeId != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // The only live blur on this screen. Budget: 1 of FvGlass.blurBudget.
      appBar: GlassAppBar(
        title: const Text('Family Veda'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              final signedOut = await logoutAndClearMember(ref);
              if (!signedOut && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Sign out could not be completed. Check your connection and try again.',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Text(
              hasMember ? 'Viewing' : 'Get started',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              activeName ?? 'Choose a family member',
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 30),
            ),
            const SizedBox(height: 8),
            Text(
              hasMember
                  ? 'Health activity, records and cases for this member.'
                  : 'Select whose records and cases you want to view.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.glass.faint,
              ),
            ),
            const SizedBox(height: 20),

            // Primary task. Gradient rather than glass — this is the action
            // the screen exists for.
            _PrimaryAction(
              title: 'Describe a symptom',
              caption:
                  'A verified doctor reviews every response before it reaches you.',
              enabled: hasMember,
              onTap: () => context.push('/complaints/new'),
            ),
            const SizedBox(height: 20),

            _SectionLabel('Family'),
            _ActionRow(
              icon: Icons.people_outline,
              title: 'Switch family member',
              onTap: () => context.push('/members'),
            ),

            const SizedBox(height: 18),
            _SectionLabel('Records'),
            _ActionRow(
              icon: Icons.folder_outlined,
              title: 'Health records',
              enabled: hasMember,
              onTap: () => context.push('/records'),
            ),
            _ActionRow(
              icon: Icons.note_add_outlined,
              title: 'Add health record',
              enabled: hasMember,
              onTap: () => context.push('/records/new'),
            ),
            _ActionRow(
              icon: Icons.monitor_heart_outlined,
              title: 'Record vital',
              enabled: hasMember,
              onTap: () => context.push('/vitals/new'),
            ),

            const SizedBox(height: 18),
            _SectionLabel('Triage'),
            _ActionRow(
              icon: Icons.track_changes_outlined,
              title: 'Case status',
              enabled: hasMember,
              onTap: () => context.push('/cases'),
            ),

            const SizedBox(height: 24),
            // Rule 10: the emergency path is solid, never glass, and never
            // competes visually with anything above it.
            _EmergencyAction(onTap: () => context.push('/emergency')),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: context.glass.faint,
      ),
    ),
  );
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.title,
    required this.caption,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String caption;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final start = isDark ? AppColors.primaryLumDark : AppColors.primaryLum;
    final end = isDark ? AppColors.primaryDark : AppColors.primary;
    final onFill = isDark ? const Color(0xFF06100E) : Colors.white;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: '$title. $caption',
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [start, end],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: end.withValues(alpha: 0.38),
                blurRadius: 26,
                offset: const Offset(0, 12),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              color: onFill,
                            ),
                          ),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: onFill,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 19,
                            color: end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      caption,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: onFill.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
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
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: GlassCard(
          onTap: enabled ? onTap : null,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.14),
                  borderRadius: const BorderRadius.all(Radius.circular(13)),
                ),
                child: Icon(icon, size: 20, color: primary),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: context.glass.faint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyAction extends StatelessWidget {
  const _EmergencyAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final emergency = context.glass.emergency;
    return SolidSurface(
      color: emergency,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.emergency_outlined, color: Colors.white),
                SizedBox(width: 13),
                Expanded(
                  child: Text(
                    'Emergency referral',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
