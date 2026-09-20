import 'package:flutter/material.dart';

extension ScreenContextExtension on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double responsiveWidth(double designWidth) =>
      designWidth * (screenSize.shortestSide / 375).clamp(0.0, 1.2);
  ThemeData get theme => Theme.of(this);
}
