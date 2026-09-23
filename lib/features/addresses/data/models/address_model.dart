class Address {
  final String id;
  final String name;
  final String details;
  final String phone;
  final String city;

  const Address({
    required this.id,
    required this.name,
    required this.details,
    required this.phone,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        details: (json['details'] ?? '').toString(),
        phone: (json['phone'] ?? '').toString(),
        city: (json['city'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'details': details,
        'phone': phone,
        'city': city,
      };

  /// Handles {data:{docs|addresses|[...]}} and bare-list shapes.
  static List<Address> listOf(dynamic data) {
    List list = const [];
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map) {
        list = (inner['docs'] ?? inner['addresses'] ?? inner['address'] ?? []) as List? ?? [];
      } else if (inner is List) {
        list = inner;
      }
    } else if (data is List) {
      list = data;
    }
    return list
        .whereType<Map>()
        .map((e) => Address.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
