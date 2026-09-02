import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 48,
      child: OutlinedButton(
        onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: AppColor.textPrimary,
          side: const BorderSide(color: AppColor.inputBorder),
          shape: const CircleBorder(),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 23),
      ),
    );
  }
}
