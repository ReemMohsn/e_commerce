abstract class PasswordResetState {}

class PasswordResetInitial extends PasswordResetState {}

class SendCodeLoading extends PasswordResetState {}

class SendCodeSuccess extends PasswordResetState {
  SendCodeSuccess({required this.message});

  final String message;
}

class SendCodeFailure extends PasswordResetState {
  SendCodeFailure({required this.errorMessage});

  final String errorMessage;
}

class VerifyCodeLoading extends PasswordResetState {}

class VerifyCodeSuccess extends PasswordResetState {
  VerifyCodeSuccess({required this.message});

  final String message;
}

class VerifyCodeFailure extends PasswordResetState {
  VerifyCodeFailure({required this.errorMessage});

  final String errorMessage;
}

class ResetPasswordLoading extends PasswordResetState {}

class ResetPasswordSuccess extends PasswordResetState {
  ResetPasswordSuccess({required this.message});

  final String message;
}

class ResetPasswordFailure extends PasswordResetState {
  ResetPasswordFailure({required this.errorMessage});

  final String errorMessage;
}

class ResetCodeTimerUpdated extends PasswordResetState {
  ResetCodeTimerUpdated({required this.secondsRemaining});

  final int secondsRemaining;

  bool get canResend => secondsRemaining == 0;
}
