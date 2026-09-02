import 'package:e_commeric/core/common/utils/app_validator.dart';
import 'package:e_commeric/core/constants/app_image.dart';
import 'package:e_commeric/core/extensions/snack_bar_context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_state.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_page_header.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key, required this.email});

  final String email;

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PasswordResetCubit>().resetPassword(
      email: widget.email,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          context.showLoadingDialog();
        } else if (state is ResetPasswordSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.of(context).pushReplacementNamed(AppRoute.congratulations);
        } else if (state is ResetPasswordFailure) {
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
                    const AuthPageHeader(title: 'Create New Password'),
                    const SizedBox(height: 42),
                    Center(
                      child: SizedBox(
                        width: 345,
                        height: 256,
                        child: Image.asset(
                          AppImage.createNewPassword,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'New password must be\ndifferent from last password',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 26),
                    PasswordTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Password',
                      textInputAction: TextInputAction.next,
                      validator: AppValidator.password,
                    ),
                    const SizedBox(height: 8),
                    PasswordTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Confirm Password',
                      textInputAction: TextInputAction.done,
                      validator: (value) => AppValidator.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      onFieldSubmitted: (_) => _savePassword(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _savePassword,
                      child: const Text('Save Password'),
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
