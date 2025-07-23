class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final password = value.trim();
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigit = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialChar = password.contains(RegExp(r'[!@#\\$&*~]'));
    final bool hasMinLength = password.length >= 8;

    if (!hasMinLength) return 'Password must be at least 8 characters long';
    if (!hasLowercase) return 'Include at least one lowercase letter';
    if (!hasUppercase) return 'Include at least one uppercase letter';
    if (!hasDigit) return 'Include at least one number';
    if (!hasSpecialChar) return 'Include at least one special character';

    return null;
  }
}
