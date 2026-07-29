"""
Input validation utilities
"""
class Validators {
  static String? email(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v)) return 'Invalid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Min 8 characters';
    return null;
  }

  static String? required(String? v, [String field = 'This field']) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? number(String? v, [String field = 'Value']) {
    if (v == null || v.isEmpty) return '$field is required';
    if (double.tryParse(v) == null) return '$field must be a number';
    return null;
  }

  static String? positiveInt(String? v, [String field = 'Value']) {
    if (v == null || v.isEmpty) return '$field is required';
    final n = int.tryParse(v);
    if (n == null || n < 0) return '$field must be a positive integer';
    return null;
  }
}
