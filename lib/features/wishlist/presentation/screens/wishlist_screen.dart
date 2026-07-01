import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist'), backgroundColor: const Color(0xFF3BB77E)),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (ctx, state) {
          if (state is WishlistLoading) return const CustomLoading();
          if (state is WishlistFailure) return CustomErrorWidget(message: state.message, onRetry: () => ctx.read<WishlistCubit>().getWishlist());
          if (state is WishlistLoaded) {
            if (state.items.isEmpty) return const Center(child: Text('Wishlist is empty'));
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (_, i) {
                final item = state.items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: ClipRRect(borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(imageUrl: item.imageCover, width: 60, height: 60, fit: BoxFit.cover)),
                    title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('EGP ${item.price}', style: const TextStyle(color: Color(0xFF3BB77E), fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => ctx.read<WishlistCubit>().remove(item.id),
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