class User {
  static const String collectionName = 'Users';
  String id;
  String avatar;
  final String name;
  final String email;
  final String phoneNum;

  User({
    this.id = '',
    required this.avatar,
    required this.name,
    required this.email,
    required this.phoneNum,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
      'email': email,
      'phoneNumber': phoneNum,
    };
  }

  User.fromFirestore(Map<String, dynamic> data)
    : this(
        avatar: data['avatar'],
        name: data['name'],
        email: data['email'],
        phoneNum: data['phoneNumber'],
        id: data['id'],
      );
}
