import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/products/domain/entities/product_entity.dart';
import 'package:e_commerce/features/products/domain/repos/i_products_repo.dart';
import 'package:e_commerce/features/products/domain/usecases/get_product_details_usecase.dart';
import 'package:e_commerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:e_commerce/features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/features/products/presentation/cubit/products_state.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductsRepo implements IProductsRepo {
  FakeProductsRepo(this.items);
  final List<ProductEntity> items;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({String? categoryId}) async {
    return Right(items);
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    return Right(items.firstWhere((e) => e.id == id));
  }
}

ProductEntity product(String id, String title, double price) {
  return ProductEntity(
    id: id,
    title: title,
    description: 'desc $title',
    imageCover: 'https://example.com/$id.png',
    price: price,
    ratingsAverage: 4.5,
    ratingsQuantity: 10,
    sold: 5,
    quantity: 100,
    images: const [],
    categoryName: 'Cat',
  );
}

void main() {
  ProductsCubit buildCubit(List<ProductEntity> items) {
    final repo = FakeProductsRepo(items);
    return ProductsCubit(GetProductsUseCase(repo), GetProductDetailsUseCase(repo));
  }

  test('first page shows 10 items and loadMore shows the rest', () async {
    final items = List.generate(12, (i) => product('p$i', 'Product $i', 100.0 + i));
    final cubit = buildCubit(items);

    await cubit.getProducts();
    var state = cubit.state as ProductsLoaded;
    expect(state.products.length, 10);
    expect(state.totalCount, 12);
    expect(state.hasMore, isTrue);

    cubit.loadMore();
    state = cubit.state as ProductsLoaded;
    expect(state.products.length, 12);
    expect(state.hasMore, isFalse);
  });

  test('search filters by title', () async {
    final cubit = buildCubit([
      product('1', 'Nike Shoes', 500),
      product('2', 'Adidas Shirt', 300),
      product('3', 'Nike Hat', 200),
    ]);

    await cubit.getProducts();
    cubit.setSearchQuery('nike');

    final state = cubit.state as ProductsLoaded;
    expect(state.products.length, 2);
    expect(state.query, 'nike');
  });

  test('sort toggles asc then desc', () async {
    final cubit = buildCubit([
      product('1', 'A', 300),
      product('2', 'B', 100),
      product('3', 'C', 200),
    ]);

    await cubit.getProducts();
    cubit.toggleSortByPrice();
    var state = cubit.state as ProductsLoaded;
    expect(state.products.map((e) => e.price).toList(), [100, 200, 300]);

    cubit.toggleSortByPrice();
    state = cubit.state as ProductsLoaded;
    expect(state.products.map((e) => e.price).toList(), [300, 200, 100]);
  });
}
