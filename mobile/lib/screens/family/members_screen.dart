// [S1] Identity, Family & Consent.
import 'package:family_veda/providers/active_member_provider.dart';
import 'package:family_veda/providers/core_providers.dart';
import 'package:family_veda/providers/members_provider.dart';
import 'package:family_veda/widgets/shared/async_state_views.dart';
import 'package:family_veda/widgets/shared/member_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final activeId = ref.watch(activeMemberProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Family members')),
      body: SafeArea(
        child: members.when(
          loading: () => const LoadingStateView(label: 'Loading members'),
          error: (_, _) =>
              ErrorRetryView(onRetry: () => ref.invalidate(membersProvider)),
          data: (items) {
            if (items.isEmpty) {
              return const EmptyStateView(
                title: 'No family members yet',
                message: 'Add a member from family setup to begin.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final member = items[index];
                return MemberCard(
                  member: member,
                  isActive: member.id == activeId,
                  onSelected: () async {
                    ref.read(activeMemberProvider.notifier).state = member.id;
                    await ref
                        .read(memberPreferenceStoreProvider)
                        .writeActiveMemberId(member.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
