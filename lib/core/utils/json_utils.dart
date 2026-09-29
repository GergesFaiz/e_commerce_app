/// Lenient readers for Route API payloads.
///
/// The API is not uniform: documents expose `_id` (and sometimes `id`),
/// references are either populated objects or bare id strings, and numbers
/// may arrive as ints, doubles or strings.
class JsonUtils {
  static String id(dynamic json) {
    if (json is Map) return (json['_id'] ?? json['id'] ?? '').toString();
    return json?.toString() ?? '';
  }

  static String string(dynamic v, [String fallback = '']) =>
      v == null ? fallback : v.toString();

  static double toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  static int toInt(dynamic v) {
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  static Map<String, dynamic>? map(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : null;

  static List<dynamic> list(dynamic v) => v is List ? v : const [];
}
