class Validation {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email_is_invalid';
    }
    if (!value.contains('@')) {
      return 'Email_must_contain_@';
    }
    if (!value.contains('.')) {
      return 'Email_must_contain_.';
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Email_is_invalid';
    }
    return null;
  }

  static String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile_number_is_invalid';
    }
    if (!value.startsWith('5')) {
      return 'Mobile_number_must_start_with_5';
    }
    if (value.length != 9) {
      return 'Mobile_number_must_be_9_digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile_number_must_be_digits_only';
    }
    return null;
  }
}
