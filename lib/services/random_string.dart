import 'package:random_string/random_string.dart';

/// Generates a random alphanumeric password of the specified length.
///
/// The length must be greater than 0. If length <= 0, an empty string is returned.
///
/// [length] The length of the random password to generate.
String generateRandomPassword(int length) {
  if (length <= 0) {
    return ''; // Handle invalid length
  }

  return randomAlphaNumeric(length);
}
