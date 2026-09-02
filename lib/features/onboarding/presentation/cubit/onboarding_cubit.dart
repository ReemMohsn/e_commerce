import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitial());

  static const int pagesCount = 3;

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
