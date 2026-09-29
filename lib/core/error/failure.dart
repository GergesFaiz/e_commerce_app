import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  /// The server answered with a payload we could not read.
  const ServerFailure.unexpected() : super('Unexpected response from the server');

  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure('Connection timeout');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Receive timeout');
      case DioExceptionType.connectionError:
        return const ServerFailure('Could not reach the server');
      case DioExceptionType.badResponse:
        return ServerFailure(
            messageFrom(e.response?.data) ?? 'Server error (${e.response?.statusCode})');
      default:
        return const ServerFailure('Unexpected error');
    }
  }

  /// Reads the API error message. Validation errors come back as
  /// `{message: 'fail', errors: {msg: '...'}}`, others as `{message: '...'}`.
  static String? messageFrom(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is Map && errors['msg'] is String) return errors['msg'] as String;
    final message = data['message'];
    return message is String && message.isNotEmpty ? message : null;
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
