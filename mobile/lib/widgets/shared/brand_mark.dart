import 'package:flutter/material.dart';

/// The Family Veda mark — heart (family) over shield with cross (the safety
/// gate).
///
/// Decorative wherever a "Family Veda" wordmark sits beside it, so it carries
/// no semantic label by default; pass [semanticLabel] when it stands alone.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 56, this.semanticLabel});

  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/brand/mark.png',
      width: size,
      height: size,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      filterQuality: FilterQuality.high,
    );
  }
}
