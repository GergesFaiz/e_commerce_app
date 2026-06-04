
import '../../models/category_model.dart';

abstract class DataSourceContract {
  Future<List<CategoryModel>> getCategories();
}
