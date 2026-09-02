class SignInResponse {
  const SignInResponse({required this.token, required this.user});

  final String token;
  final Map<String, dynamic> user;

  factory SignInResponse.fromJson(Object? source) {
    final json = source as Map<String, dynamic>;

    return SignInResponse(
      token: json['token'] as String,
      user: json['user'] as Map<String, dynamic>,
    );
  }
}
