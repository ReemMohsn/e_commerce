abstract final class AppValidator {
  static String? requiredField(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, field: 'Email');
    if (requiredError != null) return requiredError;

    final emailPattern = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$",
    );
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? username(String? value) {
    final requiredError = requiredField(value, field: 'Username');
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? phone(String? value) {
    final requiredError = requiredField(value, field: 'Phone number');
    if (requiredError != null) return requiredError;

    final normalized = value!.replaceAll(RegExp(r'[\s()-]'), '');
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(normalized)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, field: 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final requiredError = requiredField(value, field: 'Confirm password');
    if (requiredError != null) return requiredError;
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? otp(String value) {
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'Enter the 4 digit verification code';
    }
    return null;
  }
}
