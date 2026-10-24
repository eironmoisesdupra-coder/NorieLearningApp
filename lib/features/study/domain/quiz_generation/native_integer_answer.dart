/// Exact integer-value aliases for bounded native identification exercises.
/// No floating-point rounding, expression evaluation or source-AI regrading.
bool nativeIntegerAnswerMatches(String response, String expected) {
  final value = response.trim().replaceAll('−', '-');
  if (value.length > 128 ||
      expected.length > 128 ||
      !RegExp(r'^[+-]?\d+(?:\.0+)?$').hasMatch(value) ||
      !RegExp(r'^-?\d+$').hasMatch(expected)) {
    return false;
  }
  return BigInt.tryParse(value.split('.').first) == BigInt.tryParse(expected);
}
