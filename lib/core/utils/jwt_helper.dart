import 'dart:convert';

/// Reads the user id embedded in the Route JWT (payload: {"id": ...}).
class JwtHelper {
  static String userId(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return '';
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is Map) {
        final id = payload['id'] ?? payload['_id'] ?? payload['userId'];
        if (id != null) return id.toString();
      }
    } catch (_) {
      // Invalid token format.
    }
    return '';
  }
}
