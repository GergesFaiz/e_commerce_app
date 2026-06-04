import 'package:injectable/injectable.dart';

@injectable
class GetProductsUseCase {
  GetProductsUseCase();
  void call() => print("hello");
}
