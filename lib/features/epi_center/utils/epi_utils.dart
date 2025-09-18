import 'dart:convert';

/// Recursively decode any stringified JSON until fully converted.
/// This function handles nested JSON strings within epi center details json response
/// but can be used for any similar structure.
dynamic decodeEpiCenterDetailsNestedJson(dynamic input) {
  if (input is Map) {
    // Ensure keys are Strings
    return input.map<String, dynamic>(
      (key, value) =>
          MapEntry(key.toString(), decodeEpiCenterDetailsNestedJson(value)),
    );
  } else if (input is List) {
    return input.map(decodeEpiCenterDetailsNestedJson).toList();
  } else if (input is String) {
    dynamic decoded = input;
    bool didDecode = true;

    while (didDecode) {
      didDecode = false;
      try {
        final temp = jsonDecode(decoded);
        if (temp is Map || temp is List) {
          decoded = decodeEpiCenterDetailsNestedJson(temp);
          didDecode = true;
        } else {
          decoded = temp;
        }
      } catch (_) {
        break; // not a JSON string
      }
    }

    return decoded;
  } else {
    return input;
  }
}
