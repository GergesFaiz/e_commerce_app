import 'package:e_commerce/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userJson = {
    'message': 'success',
    'token': 'jwt-token-123',
    'user': {
      'name': 'Gerges Faiz',
      'email': 'gerges@example.com',
      'id': 'u1',
      'phone': '01001234567',
    },
  };

  group('UserModel', () {
    test('parses all fields from JSON', () {
      final model = UserModel.fromJson(userJson);

      expect(model.message, 'success');
      expect(model.token, 'jwt-token-123');
      expect(model.user.name, 'Gerges Faiz');
      expect(model.user.email, 'gerges@example.com');
      expect(model.user.id, 'u1');
      expect(model.user.phone, '01001234567');
    });

    test('toJson round-trips', () {
      final model = UserModel.fromJson(userJson);
      final reparsed = UserModel.fromJson(model.toJson());

      expect(reparsed.token, model.token);
      expect(reparsed.user.name, model.user.name);
      expect(reparsed.user.email, model.user.email);
    });

    test('maps to entity keeping name, email and token', () {
      final entity = UserModel.fromJson(userJson).toEntity();

      expect(entity.name, 'Gerges Faiz');
      expect(entity.email, 'gerges@example.com');
      expect(entity.token, 'jwt-token-123');
    });
  });
}