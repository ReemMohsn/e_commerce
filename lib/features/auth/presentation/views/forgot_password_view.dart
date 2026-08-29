import 'package:e_commeric/core/common/utils/app_validator.dart';
import 'package:e_commeric/core/constants/app_image.dart';
import 'package:e_commeric/core/extensions/context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_state.dart';
import 'package:e_commeric/features/auth/presentation/models/password_reset_arguments.dart';
import 'package:e_commeric/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:e_commeric/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PasswordResetCubit>().requestCode(
      email: _emailController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is SendCodeLoading) {
          context.showLoadingDialog();
        } else if (state is SendCodeSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.of(context).pushNamed(
            AppRoute.verificationCode,
            arguments: VerificationCodeArguments(
              email: _emailController.text.trim(),
            ),
          );
        } else if (state is SendCodeFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthPageHeader(title: 'Forgot Password'),
                    const SizedBox(height: 42),
                    Center(
                      child: SizedBox(
                        height: 256,
                        width: 229,
                        child: Image.asset(
                          AppImage.forgotPasswordWithEmail,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Please enter your email address to\n'
                      'receive a verification code',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 26),
                    AuthTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'You@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: AppValidator.email,
                      onFieldSubmitted: (_) => _sendCode(),
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _sendCode,
                      child: const Text('Send Code'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
