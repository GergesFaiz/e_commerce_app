import '../../domain/entities/wishlist_entity.dart';

class WishlistState {
  final List<WishlistItemEntity> items;
  final Set<String> ids;
  final bool loading;
  final String? error;
  const WishlistState({
    this.items = const [],
    this.ids = const {},
    this.loading = false,
    this.error,
  });

  WishlistState copyWith({
    List<WishlistItemEntity>? items,
    Set<String>? ids,
    bool? loading,
    String? error,
  }) {
    return WishlistState(
      items: items ?? this.items,
      ids: ids ?? this.ids,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
