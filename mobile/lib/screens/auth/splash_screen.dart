// [S1] Identity, Family & Consent.
import 'package:family_veda/widgets/shared/brand_mark.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Colors.transparent,
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandMark(size: 88),
            SizedBox(height: 24),
            CircularProgressIndicator(),
            SizedBox(height: 14),
            Text('Opening Family Veda securely…'),
          ],
        ),
      ),
    ),
  );
}
