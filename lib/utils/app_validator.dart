class AppValidator {
  // Validate Full Name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    // Accepts letters (English/Arabic) and spaces, minimum 3 characters
    final nameRegExp = RegExp(r"^[\p{L} ,.'-]{3,}$", unicode: true);
    if (!nameRegExp.hasMatch(value)) {
      return 'Please enter a valid name (at least 3 characters)';
    }
    return null;
  }

  // Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address (e.g., name@example.com)';
    }
    return null;
  }

  // Validate Phone Number (Egypt Format: 010, 011, 012, 015 + 8 digits)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid 11-digit Egyptian phone number';
    }
    return null;
  }

  // Validate Password Strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // Requirements: 1 Uppercase, 1 Lowercase, 1 Number, Min 8 characters
    final passRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (!passRegExp.hasMatch(value)) {
      return 'Must contain uppercase, lowercase, number, and min 8 chars';
    }
    return null;
  }

  // Validate Confirm Password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}