class SignUpRequestModel {
  const SignUpRequestModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String name;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
    'name': name.trim(),
    'phone': phone.trim(),
    'email': email.trim(),
    'password': password,
    'confirmPassword': confirmPassword,
  };
}
