import 'package:e_commeric/core/common/utils/app_validator.dart';
import 'package:e_commeric/core/extensions/context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_commeric/features/auth/presentation/cubit/auth_state.dart';
import 'package:e_commeric/features/auth/presentation/widgets/auth_logo.dart';
import 'package:e_commeric/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:e_commeric/features/auth/presentation/widgets/social_auth_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          context.showLoadingDialog();
        } else if (state is LoginSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pushReplacementNamed(context, AppRoute.mainHome);
        } else if (state is LoginFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AuthLogo(),
                      const SizedBox(height: 68),
                      AuthTextField(
                        controller: _emailController,
                        hintText: 'Username or Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: AppValidator.email,
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      ),
                      const SizedBox(height: 12),
                      PasswordTextField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        validator: AppValidator.password,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoute.forgotPassword),
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Log In'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Are you new in Marketi ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoute.signUp),
                            child: const Text(
                              'register?',
                              style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
