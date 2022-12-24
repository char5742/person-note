class Validator {
  static String? isNonNullString(String? value) {
    return value == null || value == '' ? 'Field is required' : null;
  }

  static String? isNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final n = num.tryParse(value);
    return n == null ? '「$value」is not Number' : null;
  }
}
