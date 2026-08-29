import 'package:e_commeric/core/constants/app_image.dart';
import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.width = 150, this.height = 128});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(AppImage.marketiLogo, fit: BoxFit.contain),
    );
  }
}
