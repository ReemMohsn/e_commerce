import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/common/utils/app_validator.dart';
import 'package:e_commeric/core/extensions/snack_bar_context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/auth/data/models/sign_up_request_model.dart';
import 'package:e_commeric/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:e_commeric/features/auth/presentation/view_model/auth_state.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_logo.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_text_field.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/password_text_field.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/phone_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().signUp(
      SignUpRequestModel(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          context.showLoadingDialog();
        } else if (state is SignUpSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoute.login, (route) => false);
        } else if (state is SignUpFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthLogo(widthFactor: 0.35),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _nameController,
                      labelText: AppStrings.yourName,
                      hintText: AppStrings.fullName,
                      textInputAction: TextInputAction.next,
                      validator: (value) => AppValidator.requiredField(
                        value,
                        field: AppStrings.name,
                      ),
                      prefixIcon: const Icon(Icons.edit_outlined, size: 20),
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _usernameController,
                      labelText: AppStrings.username,
                      hintText: AppStrings.username,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PhoneTextField(
                      controller: _phoneController,
                      validator: AppValidator.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _emailController,
                      labelText: AppStrings.email,
                      hintText: AppStrings.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: AppValidator.email,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    ),
                    const SizedBox(height: 8),
                    PasswordTextField(
                      controller: _passwordController,
                      labelText: AppStrings.password,
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
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text(AppStrings.signUp),
                    ),
                    const SizedBox(height: 12),
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
