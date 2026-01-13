extension InputValidator on String {
  /// Returns true if string is null or empty (after trimming)
  bool get isNullOrEmpty => trim().isEmpty;

  /// ---------------------------
  /// ✅ Email validation
  /// ---------------------------
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(trim());
  }

  bool get isInvalidEmail => !isValidEmail || isNullOrEmpty;

  /// ---------------------------
  /// ✅ Password validation (6–16 chars)
  /// ---------------------------
  bool get isValidPassword {
    final passRegex = RegExp(r'^.{6,16}$');
    return passRegex.hasMatch(trim());
  }

  bool get isInvalidPassword => !isValidPassword || isNullOrEmpty;

  /// ---------------------------
  /// ✅ Name validation (2–50 letters only)
  /// ---------------------------
  bool get isValidName {
    final nameRegex = RegExp(r'^[a-zA-Z\\s]{2,50}$');
    return nameRegex.hasMatch(trim());
  }

  bool get isInvalidName => !isValidName || isNullOrEmpty;

  /// ---------------------------
  /// ✅ Phone number validation
  /// ---------------------------
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(
      r'^\+?[1-9]\d{1,14}$', // International phone number format
    );
    return phoneRegex.hasMatch(trim());
  }

  bool get isInvalidPhoneNumber => !isValidPhoneNumber || isNullOrEmpty;
}
