import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/services/app_services.dart';
import 'package:e_commeric/e_commerce_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final initialRoute = await _determineInitialRoute();

  runApp(
    ECommerceApp(
      appRouter: AppRouter(),
      initialRoute: initialRoute,
    ),
  );
  FlutterNativeSplash.remove();
}

Future<String> _determineInitialRoute() async {
  final prefs = AppServices.preferences;

  final onboardingCompleted = await prefs.isOnboardingCompleted;
  if (!onboardingCompleted) {
    return AppRoute.onboarding;
  }

  final loggedIn = await prefs.isLoggedIn;
  if (!loggedIn) {
    return AppRoute.login;
  }

  return AppRoute.mainHome;
}
