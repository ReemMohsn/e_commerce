import 'package:e_commeric/features/onboarding/data/onboarding_pages.dart';
import 'package:e_commeric/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitial());

  int pagesCount = onboardingPages.length;

  void nextPage() {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex < pagesCount) {
      emit(OnboardingPageChanged(currentIndex: nextIndex));
    }
  }

  void changePage(int index) {
    if (index == state.currentIndex) return;
    emit(OnboardingPageChanged(currentIndex: index));
  }
}
