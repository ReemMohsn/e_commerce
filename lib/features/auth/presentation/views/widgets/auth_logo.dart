import 'package:e_commeric/core/constants/app_image.dart';
import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.widthFactor = 0.45, this.maxWidth = 180})
    : assert(widthFactor > 0 && widthFactor <= 1),
      assert(maxWidth > 0);

  static const double _aspectRatio = 1204 / 1024;

  final double widthFactor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final logoWidth = (availableWidth * widthFactor)
            .clamp(0.0, maxWidth)
            .toDouble();

        return Center(
          child: SizedBox(
            width: logoWidth,
            child: AspectRatio(
              aspectRatio: _aspectRatio,
              child: Image.asset(AppImage.marketiLogo, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }
}
