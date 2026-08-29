class AuthSession {
  const AuthSession({this.token, this.user});

  final String? token;
  final Map<String, dynamic>? user;

  factory AuthSession.fromJson(Object? source) {
    final root = _asMap(source);
    final nestedData = _asMap(root['data']);
    final data = nestedData.isEmpty ? root : nestedData;
    final user = _asMap(data['user']).isNotEmpty
        ? _asMap(data['user'])
        : _asMap(root['user']).isNotEmpty
        ? _asMap(root['user'])
        : null;

    return AuthSession(
      token: _firstString([
        data['token'],
        data['accessToken'],
        data['access_token'],
        data['jwt'],
        root['token'],
        root['accessToken'],
        root['access_token'],
      ]),
      user: user,
    );
  }

  Map<String, dynamic> toJson() => {
    if (token != null) 'token': token,
    if (user != null) 'user': user,
  };

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static String? _firstString(List<Object?> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value;
    }
    return null;
  }
}
