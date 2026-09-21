class ResetPasswordRequestModel {
  const ResetPasswordRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String email;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
    'email': email.trim(),
    'password': password,
    'confirmPassword': confirmPassword,
  };
}
