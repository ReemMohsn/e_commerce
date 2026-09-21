class VerifyCodeRequestModel {
  const VerifyCodeRequestModel({required this.email, required this.code});

  final String email;
  final String code;

  Map<String, dynamic> toJson() => {
    'email': email.trim(),
    'code': code,
  };
}
