import 'package:flutter/foundation.dart';

@immutable
class OnboardingPageModel {
  const OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.imageWidth,
  });

  final String imagePath;
  final String title;
  final String description;
  final double imageWidth;
}
