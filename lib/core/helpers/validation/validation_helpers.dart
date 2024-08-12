class ValidationHelper {
  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool isValidUrl(String url) {
    var urlPattern =
        r"^(?:http(s)?:\/\/)? [\w.-]+(?:\. [w).-]+)+[\w\-\-_~:/?#[\J@!\$&'\(\)\*\+,;=.]+$";
    return RegExp(urlPattern, caseSensitive: false).hasMatch(url);
  }

  static bool isValidUsername(String username) {
    return RegExp(r'^(?!\s*$) [a-zA-Z0-9_-]{3,20}$').hasMatch(username);
  }

  static bool isValidPassword(String password) {
    return password.length > 7;
  }

  static String? formValidatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email Required';
    }
    if (!isValidEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}


