import 'dart:math' as math;

import 'package:e_commeric/core/extensions/screen_context_extension.dart';
import 'package:flutter/material.dart';

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({
    super.key,
    required this.asset,
    required this.designWidth,
  });

  final String asset;
  final double designWidth;

  @override
  Widget build(BuildContext context) {
    final width = context.responsiveWidth(designWidth);
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: SizedBox(
          width: math.min(width, constraints.maxWidth),
          child: AspectRatio(
            aspectRatio: designWidth / 256,
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
