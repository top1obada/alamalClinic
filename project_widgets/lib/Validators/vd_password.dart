class PasswordValidator {
  PasswordValidator._();

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter password';
    }
    if (val.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(val)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(val)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(val)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#\$&*~^%?.,<>]').hasMatch(val)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }
}
