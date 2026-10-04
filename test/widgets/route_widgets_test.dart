import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/widgets/route_widgets.dart';
import 'package:e_commerce/features/products/domain/entities/product_entity.dart';
import 'package:e_commerce/features/products/presentation/widgets/product_card.dart';
import 'package:e_commerce/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:e_commerce/features/wishlist/domain/repos/i_wishlist_repo.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _SavedWishlist implements IWishlistRepo {
  _SavedWishlist(this.ids);
  final List<String> ids;

  @override
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist() async => Right(ids
      .map((id) => WishlistItemEntity(id: id, title: id, imageCover: '', price: 1))
      .toList());
  @override
  Future<Either<Failure, List<String>>> addToWishlist(String productId) async => Right(ids);
  @override
  Future<Either<Failure, List<String>>> removeFromWishlist(String productId) async => Right(ids);
}

ProductEntity _product({required String id, double? discount}) => ProductEntity(
      id: id,
      title: 'Wireless Headphones',
      description: '',
      imageCover: '',
      price: 1299,
      priceAfterDiscount: discount,
      ratingsAverage: 4.7,
      ratingsQuantity: 10,
      sold: 3,
      quantity: 5,
      images: const [],
      categoryName: 'Electronics',
    );

void main() {
  Future<void> pumpCard(WidgetTester tester, ProductEntity product,
      {List<String> wished = const []}) async {
    final repo = _SavedWishlist(wished);
    final cubit = WishlistCubit(GetWishlistUseCase(repo), AddToWishlistUseCase(repo),
        RemoveFromWishlistUseCase(repo));
    await cubit.getWishlist();
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 180, height: 260, child: ProductCard(product: product)),
            ),
          ),
        ),
      ),
    );
  }

  group('ProductCard', () {
    testWidgets('shows the discounted price and strikes the original', (tester) async {
      await pumpCard(tester, _product(id: 'p1', discount: 999));

      expect(find.text('EGP 999'), findsOneWidget);
      final old = tester.widget<Text>(find.text('1,299 EGP'));
      expect(old.style!.decoration, TextDecoration.lineThrough);
      expect(find.text('Review (4.7)'), findsOneWidget);
    });

    testWidgets('shows a single price without a discount', (tester) async {
      await pumpCard(tester, _product(id: 'p1'));

      expect(find.text('EGP 1,299'), findsOneWidget);
      expect(find.textContaining('EGP', findRichText: true), findsOneWidget);
    });

    testWidgets('fills the heart for wishlisted products', (tester) async {
      await pumpCard(tester, _product(id: 'p1'), wished: ['p1']);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      await pumpCard(tester, _product(id: 'p2'), wished: ['p1']);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  });

  group('RouteBottomNav', () {
    testWidgets('highlights the current tab and reports taps', (tester) async {
      int? tapped;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          bottomNavigationBar: RouteBottomNav(currentIndex: 0, onTap: (i) => tapped = i),
        ),
      ));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite_border));
      expect(tapped, 2);
    });
  });

  group('QtyStepper', () {
    testWidgets('shows the quantity and fires both buttons', (tester) async {
      var qty = 2;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => QtyStepper(
              qty: qty,
              onMinus: () => setState(() => qty--),
              onPlus: () => setState(() => qty++),
            ),
          ),
        ),
      ));

      expect(find.text('2'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('3'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });
  });
}
