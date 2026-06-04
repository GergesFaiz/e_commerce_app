import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../config/constants.dart';

@singleton
class ApiManager {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
    ),
  );

  Future<Response> getData({required String endpoint}) async {
    // try {
    final response = await dio.get(endpoint);
    return response;
    // } on DioException catch (err) {
    //   print("Error: ${err.message}");
    //   throw Exception(err.message);
    // }
  }
}
