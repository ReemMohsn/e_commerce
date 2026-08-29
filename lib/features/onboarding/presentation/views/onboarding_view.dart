import 'package:e_commeric/features/onboarding/data/onboarding_pages.dart';
import 'package:e_commeric/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:e_commeric/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:e_commeric/features/onboarding/presentation/widgets/onboarding_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingPages.length,
                  onPageChanged: context.read<OnboardingCubit>().changePage,
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(
                      page: onboardingPages[index],
                      pageIndex: index,
                      pagesCount: onboardingPages.length,
                    );
                  },
                ),
              ),
              BlocConsumer<OnboardingCubit, OnboardingState>(
                listener: (context, state) {
                  if (!_pageController.hasClients) return;

                  final visiblePage = _pageController.page?.round();

                  if (visiblePage != state.currentIndex) {
                    _pageController.animateToPage(
                      state.currentIndex,
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                builder: (context, state) {
                  final isLastPage =
                      state.currentIndex == onboardingPages.length - 1;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: context.read<OnboardingCubit>().nextPage,
                      child: Text(isLastPage ? 'Get Start' : 'Next'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
