import 'package:e_commeric/features/onboarding/data/models/onboarding_page_model.dart';
import 'package:e_commeric/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.page,
    required this.pageIndex,
    required this.pagesCount,
  });

  final OnboardingPageModel page;
  final int pageIndex;
  final int pagesCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final topSpacing = (availableHeight * 0.18).clamp(72.0, 121.0);
        final imageHeight = (availableHeight * 0.38).clamp(210.0, 256.0);
        final scaledImageWidth = page.imageWidth * (imageHeight / 256);

        return Column(
          children: [
            SizedBox(height: topSpacing),
            SizedBox(
              width: scaledImageWidth,
              height: imageHeight,
              child: Image.asset(page.imagePath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 40),
            OnboardingPageIndicator(
              currentPage: pageIndex,
              pagesCount: pagesCount,
            ),
            const SizedBox(height: 24),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
