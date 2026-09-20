import 'package:e_commeric/features/auth/presentation/views/widgets/auth_illustration.dart';
import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/common/utils/app_validator.dart';
import 'package:e_commeric/core/constants/app_image.dart';
import 'package:e_commeric/core/extensions/snack_bar_context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/auth/data/models/reset_password_request_model.dart';
import 'package:e_commeric/features/auth/presentation/view_model/password_reset_cubit.dart';
import 'package:e_commeric/features/auth/presentation/view_model/password_reset_state.dart';
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
      ResetPasswordRequestModel(
        email: widget.email,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
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
                    const AuthPageHeader(title: AppStrings.createNewPassword),
                    const SizedBox(height: 42),
                    AuthIllustration(
                      asset: AppImage.createNewPassword,
                      designWidth: 345,
                    ),
                    const SizedBox(height: 26),
                    Text(
                      AppStrings.newPasswordMustBeDifferentFromLastPassword,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 26),
                    PasswordTextField(
                      controller: _passwordController,
                      labelText: AppStrings.password,
                      hintText: AppStrings.password,
                      textInputAction: TextInputAction.next,
                      validator: AppValidator.password,
                    ),
                    const SizedBox(height: 8),
                    PasswordTextField(
                      controller: _confirmPasswordController,
                      labelText: AppStrings.confirmPassword2,
                      hintText: AppStrings.confirmPassword2,
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
                      child: const Text(AppStrings.savePassword),
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
