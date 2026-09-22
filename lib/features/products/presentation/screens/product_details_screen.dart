import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String id;
  const ProductDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details'), backgroundColor: const Color(0xFF3BB77E)),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (ctx, state) {
          if (state is ProductsLoading) return const CustomLoading();
          if (state is ProductsFailure) return CustomErrorWidget(message: state.message, onRetry: () => ctx.read<ProductsCubit>().getProductDetails(id));
          if (state is ProductDetailsLoaded) {
            final p = state.product;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(imageUrl: p.imageCover, height: 300, width: double.infinity, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Text('EGP ${p.price}', style: const TextStyle(fontSize: 22, color: Color(0xFF3BB77E), fontWeight: FontWeight.bold)),
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.amber),
                          Text(' ${p.ratingsAverage} (${p.ratingsQuantity})'),
                        ]),
                        const SizedBox(height: 16),
                        const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(p.description),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Add to Cart'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3BB77E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}