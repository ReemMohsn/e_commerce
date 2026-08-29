import 'package:e_commeric/core/common/utils/app_validator.dart';
import 'package:e_commeric/core/constants/app_image.dart';
import 'package:e_commeric/core/extensions/context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_state.dart';
import 'package:e_commeric/features/auth/presentation/models/password_reset_arguments.dart';
import 'package:e_commeric/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:e_commeric/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({super.key, required this.arguments});

  final VerificationCodeArguments arguments;

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  String _code = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PasswordResetCubit>().startTimer();
    });
  }

  void _verifyCode() {
    final validationError = AppValidator.otp(_code);
    if (validationError != null) {
      context.showErrorSnackBar(validationError);
      return;
    }

    context.read<PasswordResetCubit>().verifyCode(
      email: widget.arguments.email,
      code: _code,
    );
  }

  String _formattedTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is VerifyCodeLoading || state is SendCodeLoading) {
          context.showLoadingDialog();
        } else if (state is VerifyCodeSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.of(context).pushNamed(
            AppRoute.createNewPassword,
            arguments: CreateNewPasswordArguments(
              email: widget.arguments.email,
            ),
          );
        } else if (state is VerifyCodeFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is SendCodeSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthPageHeader(title: 'Verification Code'),
                  const SizedBox(height: 42),
                  Center(
                    child: SizedBox(
                      height: 256,
                      width: 249,
                      child: Image.asset(
                        AppImage.verificationCodeWithEmail,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text.rich(
                    TextSpan(
                      text: 'Please enter the 4 digit code\nsent to: ',
                      children: [
                        TextSpan(
                          text: widget.arguments.email,
                          style: const TextStyle(color: AppColor.primary),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 22),
                  OtpCodeField(onChanged: (value) => _code = value),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verifyCode,
                    child: const Text('Verify Code'),
                  ),
                  const SizedBox(height: 19),
                  BlocBuilder<PasswordResetCubit, PasswordResetState>(
                    buildWhen: (_, current) => current is ResetCodeTimerUpdated,
                    builder: (context, state) {
                      final seconds = state is ResetCodeTimerUpdated
                          ? state.secondsRemaining
                          : 46;
                      final canResend = seconds == 0;

                      return Column(
                        children: [
                          Text(
                            _formattedTimer(seconds),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: canResend
                                ? () => context
                                      .read<PasswordResetCubit>()
                                      .resendCode(email: widget.arguments.email)
                                : null,
                            child: Text(
                              'Resend Code',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: canResend
                                    ? AppColor.primary
                                    : AppColor.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
