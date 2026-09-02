import 'package:e_commeric/core/constants/app_image.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_back_button.dart';
import 'package:flutter/material.dart';

class CongratulationsView extends StatelessWidget {
  const CongratulationsView({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoute.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    AuthBackButton(onPressed: () => _goToLogin(context)),
                  ],
                ),
                const SizedBox(height: 42),
                Center(
                  child: SizedBox(
                    width: 344,
                    height: 256,
                    child: Image.asset(
                      AppImage.congratulations,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Congratulations',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Text(
                  'You have updated the password. please\n'
                  'login again with your latest password',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _goToLogin(context),
                  child: const Text('Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
