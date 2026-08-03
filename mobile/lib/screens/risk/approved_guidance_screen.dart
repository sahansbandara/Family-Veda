// [S4] Only final doctor-approved advisory is rendered on patient surface.
import 'package:family_veda/providers/guidance_provider.dart';
import 'package:family_veda/widgets/shared/async_state_views.dart';
import 'package:family_veda/widgets/shared/clinical_disclaimer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApprovedGuidanceScreen extends ConsumerWidget {
  const ApprovedGuidanceScreen({super.key, required this.caseId});

  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidance = ref.watch(approvedGuidanceProvider(caseId));
    final familialRisk = ref.watch(approvedFamilialRiskProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Approved guidance')),
      body: SafeArea(
        child: guidance.when(
          loading: () => const LoadingStateView(label: 'Loading guidance'),
          error: (_, _) => ErrorRetryView(
            onRetry: () => ref.invalidate(approvedGuidanceProvider(caseId)),
          ),
          data: (value) {
            if (value == null) {
              return const EmptyStateView(
                title: 'Guidance is not ready',
                message:
                    'Guidance is not available until a doctor approves it.',
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text('Reviewed and approved by a doctor'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(value.finalAdvisory),
                        const SizedBox(height: 16),
                        Text('${value.doctorName} · ${value.approvedAtLabel}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                familialRisk.when(
                  loading: () => const LoadingStateView(label: 'Loading approved screening guidance'),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (risk) => risk == null || risk.caseId != caseId ? const SizedBox.shrink() : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Familial screening'),
                        const SizedBox(height: 8),
                        Text(risk.screeningGuidance),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const ClinicalDisclaimer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
