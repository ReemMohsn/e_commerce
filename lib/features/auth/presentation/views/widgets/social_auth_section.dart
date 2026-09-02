import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class SocialAuthSection extends StatelessWidget {
  const SocialAuthSection({super.key, required this.onProviderPressed});

  final ValueChanged<String> onProviderPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Or Continue With', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              semanticLabel: 'Continue with Google',
              onPressed: () => onProviderPressed('Google'),
              child: const Text(
                'G',
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            _SocialButton(
              semanticLabel: 'Continue with Apple',
              onPressed: () => onProviderPressed('Apple'),
              child: const Icon(
                Icons.apple,
                color: AppColor.textPrimary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            _SocialButton(
              semanticLabel: 'Continue with Facebook',
              onPressed: () => onProviderPressed('Facebook'),
              child: const Text(
                'f',
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 29,
                  height: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.semanticLabel,
    required this.onPressed,
    required this.child,
  });

  final String semanticLabel;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 43,
          height: 43,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.inputBorder),
          ),
          child: child,
        ),
      ),
    );
  }
}
