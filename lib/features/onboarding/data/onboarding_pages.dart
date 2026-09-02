import 'package:e_commeric/core/constants/app_image.dart';
import 'package:e_commeric/features/onboarding/data/models/onboarding_page_model.dart';

const onboardingPages = <OnboardingPageModel>[
  OnboardingPageModel(
    imagePath: AppImage.welcomeToMarketi,
    title: 'Welcome to Marketi',
    description:
        'Discover a world of endless\n'
        'possibilities and shop from\n'
        'the comfort of your fingertips\n'
        'Browse through a wide range\n'
        'of products, from fashion\n'
        'and electronics to home.',
    imageWidth: 304,
  ),
  OnboardingPageModel(
    imagePath: AppImage.easyToBuy,
    title: 'Easy to Buy',
    description:
        'Find the perfect item that suits your style and\n'
        'needs With secure payment options and fast\n'
        'delivery, shopping has never been easier.',
    imageWidth: 256,
  ),
  OnboardingPageModel(
    imagePath: AppImage.wonderfulUserExperience,
    title: 'Wonderful User Experience',
    description:
        'Start exploring now and experience the\n'
        'convenience of online shopping at its best.',
    imageWidth: 260,
  ),
];
