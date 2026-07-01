import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products'), backgroundColor: const Color(0xFF3BB77E)),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (ctx, state) {
          if (state is ProductsLoading) return const CustomLoading();
          if (state is ProductsFailure) return CustomErrorWidget(message: state.message, onRetry: () => ctx.read<ProductsCubit>().getProducts());
          if (state is ProductsLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72,
              ),
              itemCount: state.products.length,
              itemBuilder: (_, i) {
                final p = state.products[i];
                return GestureDetector(
                  onTap: () => context.go('/product/${p.id}'),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(imageUrl: p.imageCover, height: 140, width: double.infinity, fit: BoxFit.cover)),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('EGP ${p.price}', style: const TextStyle(color: Color(0xFF3BB77E), fontWeight: FontWeight.bold)),
                            Row(children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              Text(' ${p.ratingsAverage}', style: const TextStyle(fontSize: 12)),
                            ]),
                          ]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}