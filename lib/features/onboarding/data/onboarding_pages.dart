import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/constants/app_image.dart';
import 'package:e_commeric/features/onboarding/data/models/onboarding_page_model.dart';

const onboardingPages = <OnboardingPageModel>[
  OnboardingPageModel(
    imagePath: AppImage.welcomeToMarketi,
    title: AppStrings.welcomeToMarketi,
    description:
        AppStrings.discoverAWorldOfEndlessPossibilitiesAndShopFromTheComfortOfYourFingertipsBrowseThroughAWideRangeOfProductsFromFashionAndElectronicsToHome,
    imageWidth: 304,
  ),
  OnboardingPageModel(
    imagePath: AppImage.easyToBuy,
    title: AppStrings.easyToBuy,
    description:
        AppStrings.findThePerfectItemThatSuitsYourStyleAndNeedsWithSecurePaymentOptionsAndFastDeliveryShoppingHasNeverBeenEasier,
    imageWidth: 256,
  ),
  OnboardingPageModel(
    imagePath: AppImage.wonderfulUserExperience,
    title: AppStrings.wonderfulUserExperience,
    description:
        AppStrings.startExploringNowAndExperienceTheConvenienceOfOnlineShoppingAtItsBest,
    imageWidth: 260,
  ),
];
