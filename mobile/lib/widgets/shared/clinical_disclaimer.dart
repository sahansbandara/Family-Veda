import 'package:flutter/material.dart';

class ClinicalDisclaimer extends StatelessWidget {
  const ClinicalDisclaimer({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Clinical safety disclaimer',
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.verified_user_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'This is a clinical decision-support tool. It does not '
                'provide medical diagnosis. All guidance is reviewed and '
                'approved by a licensed doctor before you receive it. In an '
                'emergency, seek immediate in-person medical care.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
