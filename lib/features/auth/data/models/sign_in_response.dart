import 'package:e_commeric/features/profile/data/models/user_model.dart';

class SignInResponse {
  const SignInResponse({required this.token, required this.user});

  final String token;
  final UserModel user;

  factory SignInResponse.fromJson(Object? source) {
    final json = source as Map<String, dynamic>;

    return SignInResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
