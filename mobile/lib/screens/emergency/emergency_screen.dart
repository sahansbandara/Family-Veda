// [S4] Static referral path. No AI-generated guidance appears here.
import 'package:family_veda/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _callEmergency(BuildContext context) async {
    final launched = await launchUrl(Uri(scheme: 'tel', path: '1990'));
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Call Suwa Seriya directly on 1990.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Emergency referral'),
      backgroundColor: AppColors.emergency,
      foregroundColor: Colors.white,
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(
            header: true,
            child: const Text(
              'Seek immediate in-person medical care.',
              style: TextStyle(
                color: AppColors.emergency,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Do not wait for an online response. Contact emergency services or go to the nearest hospital.',
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            key: const Key('call_1990_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergency,
            ),
            onPressed: () => _callEmergency(context),
            icon: const Icon(Icons.call),
            label: const Text('Call Suwa Seriya 1990'),
          ),
          const SizedBox(height: 20),
          Text(
            'Nearest hospitals',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.local_hospital_outlined),
              title: Text('Use your phone maps to find the nearest hospital'),
              subtitle: Text(
                'Location results depend on your current position.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This referral screen does not confirm that a message was '
                'sent. Call emergency services now and contact the Family '
                'Head directly when it is safe to do so.',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
