import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    required this.pagesCount,
  });

  final int currentPage;
  final int pagesCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        pagesCount,
        (index) => Padding(
          padding: EdgeInsetsDirectional.only(
            end: index == pagesCount - 1 ? 0 : 6,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentPage
                  ? AppColor.textPrimary
                  : AppColor.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
