import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColor.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
