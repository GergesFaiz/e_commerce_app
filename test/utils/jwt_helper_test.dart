import 'dart:convert';

import 'package:e_commerce/core/utils/jwt_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String tokenWith(Map<String, Object?> payload) {
    String enc(Object o) =>
        base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
    return '${enc({'alg': 'HS256'})}.${enc(payload)}.sig';
  }

  test('extracts id from a valid JWT payload', () {
    expect(JwtHelper.userId(tokenWith({'id': 'u9'})), 'u9');
  });

  test('returns empty string for malformed tokens', () {
    expect(JwtHelper.userId('not-a-token'), isEmpty);
    expect(JwtHelper.userId(''), isEmpty);
  });
}
