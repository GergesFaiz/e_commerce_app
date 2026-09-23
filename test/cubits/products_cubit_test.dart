import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/products/domain/entities/product_entity.dart';
import 'package:e_commerce/features/products/domain/repos/i_products_repo.dart';
import 'package:e_commerce/features/products/domain/usecases/get_product_details_usecase.dart';
import 'package:e_commerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:e_commerce/features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/features/products/presentation/cubit/products_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake that mimics the server: keyword filter, price sort
/// and page-based pagination.
class FakeProductsRepo implements IProductsRepo {
  FakeProductsRepo(this.items);
  final List<ProductEntity> items;

  ProductQuery? lastQuery;

  @override
  Future<Either<Failure, ProductPage>> getProducts(ProductQuery query) async {
    lastQuery = query;
    var list = List<ProductEntity>.of(items);
    if (query.categoryId != null) {
      list = list.where((p) => p.categoryName.isNotEmpty).toList();
    }
    if (query.keyword != null && query.keyword!.isNotEmpty) {
      final q = query.keyword!.toLowerCase();
      list = list.where((p) => p.title.toLowerCase().contains(q)).toList();
    }
    if (query.sort == 'price') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (query.sort == '-price') {
      list.sort((a, b) => b.price.compareTo(a.price));
    }
    const limit = 10;
    final totalPages = (list.length / limit).ceil().clamp(1, 1 << 30);
    final start = (query.page - 1) * limit;
    final pageItems = list.skip(start).take(limit).toList();
    return Right(ProductPage(
        items: pageItems, currentPage: query.page, totalPages: totalPages));
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

  test('first server page shows 10 items and loadMore appends the rest', () async {
    final items = List.generate(12, (i) => product('p$i', 'Product $i', 100.0 + i));
    final cubit = buildCubit(items);

    await cubit.getProducts();
    var state = cubit.state as ProductsLoaded;
    expect(state.products.length, 10);
    expect(state.hasMore, isTrue);

    cubit.loadMore();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    state = cubit.state as ProductsLoaded;
    expect(state.products.length, 12);
    expect(state.hasMore, isFalse);
  });

  test('search sends the keyword to the server', () async {
    final repo = FakeProductsRepo([
      product('1', 'Nike Shoes', 500),
      product('2', 'Adidas Shirt', 300),
      product('3', 'Nike Hat', 200),
    ]);
    final cubit =
        ProductsCubit(GetProductsUseCase(repo), GetProductDetailsUseCase(repo));

    await cubit.getProducts();
    cubit.setSearchQuery('nike');
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final state = cubit.state as ProductsLoaded;
    expect(repo.lastQuery?.keyword, 'nike');
    expect(state.products.length, 2);
    expect(state.query, 'nike');
  });

  test('sort toggles server sort param asc then desc', () async {
    final repo = FakeProductsRepo([
      product('1', 'A', 300),
      product('2', 'B', 100),
      product('3', 'C', 200),
    ]);
    final cubit =
        ProductsCubit(GetProductsUseCase(repo), GetProductDetailsUseCase(repo));

    await cubit.getProducts();
    cubit.toggleSortByPrice();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    var state = cubit.state as ProductsLoaded;
    expect(repo.lastQuery?.sort, 'price');
    expect(state.products.map((e) => e.price).toList(), [100, 200, 300]);

    cubit.toggleSortByPrice();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    state = cubit.state as ProductsLoaded;
    expect(repo.lastQuery?.sort, '-price');
    expect(state.products.map((e) => e.price).toList(), [300, 200, 100]);
  });
}
