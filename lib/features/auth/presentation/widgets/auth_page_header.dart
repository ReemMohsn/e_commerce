import 'package:e_commeric/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:flutter/material.dart';

class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AuthBackButton(),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}
