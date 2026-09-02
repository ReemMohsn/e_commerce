import 'package:flutter/foundation.dart';

@immutable
abstract class OnboardingState {
  const OnboardingState({required this.currentIndex});

  final int currentIndex;
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(currentIndex: 0);
}

class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged({required super.currentIndex});
}
