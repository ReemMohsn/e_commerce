abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  LoginSuccess({required this.message});

  final String message;
}

class LoginFailure extends AuthState {
  LoginFailure({required this.errorMessage});

  final String errorMessage;
}

class SignUpLoading extends AuthState {}

class SignUpSuccess extends AuthState {
  SignUpSuccess({required this.message});

  final String message;
}

class SignUpFailure extends AuthState {
  SignUpFailure({required this.errorMessage});

  final String errorMessage;
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {
  SignOutSuccess({required this.message});

  final String message;
}

class SignOutFailure extends AuthState {
  SignOutFailure({required this.errorMessage});

  final String errorMessage;
}
