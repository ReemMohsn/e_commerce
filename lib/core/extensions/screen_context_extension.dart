import 'package:flutter/material.dart';

extension ScreenContextExtension on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  ThemeData get theme => Theme.of(this);
}
