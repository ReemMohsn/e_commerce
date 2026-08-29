import 'package:e_commeric/core/services/app_services.dart';
import 'package:e_commeric/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:e_commeric/features/auth/presentation/models/password_reset_arguments.dart';
import 'package:e_commeric/features/auth/presentation/views/congratulations_view.dart';
import 'package:e_commeric/features/auth/presentation/views/create_new_password_view.dart';
import 'package:e_commeric/features/auth/presentation/views/forgot_password_view.dart';
import 'package:e_commeric/features/auth/presentation/views/login_view.dart';
import 'package:e_commeric/features/auth/presentation/views/sign_up_view.dart';
import 'package:e_commeric/features/auth/presentation/views/verification_code_view.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/main_home_cubit.dart';
import 'package:e_commeric/features/home/presentation/views/main_home_view.dart';
import 'package:e_commeric/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:e_commeric/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:e_commeric/features/search/presentation/view_model/search_cubit.dart';
import 'package:e_commeric/features/search/presentation/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.onboarding:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => OnboardingCubit(),
            child: const OnboardingView(),
          ),
        );

      case AppRoute.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(AppServices.authRepository),
            child: const LoginView(),
          ),
        );

      case AppRoute.signUp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(AppServices.authRepository),
            child: const SignUpView(),
          ),
        );

      case AppRoute.forgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => PasswordResetCubit(AppServices.authRepository),
            child: const ForgotPasswordView(),
          ),
        );

      case AppRoute.verificationCode:
        final arguments = settings.arguments as VerificationCodeArguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => PasswordResetCubit(AppServices.authRepository),
            child: VerificationCodeView(arguments: arguments),
          ),
        );

      case AppRoute.createNewPassword:
        final arguments = settings.arguments as CreateNewPasswordArguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => PasswordResetCubit(AppServices.authRepository),
            child: CreateNewPasswordView(arguments: arguments),
          ),
        );

      case AppRoute.congratulations:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CongratulationsView(),
        );

      case AppRoute.mainHome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => MainHomeCubit()),
              BlocProvider(
                create: (_) =>
                    HomeCubit(AppServices.homeRepository)..fetchHomeData(),
              ),
            ],
            child: const MainHomeView(),
          ),
        );

      case AppRoute.search:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => SearchCubit(AppServices.searchRepository),
            child: const SearchView(),
          ),
        );

      default:
        return null;
    }
  }
}

class AppRoute {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String congratulations = '/congratulations';
  static const String mainHome = '/main-home';
  static const String search = '/search';
}
