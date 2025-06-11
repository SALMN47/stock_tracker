import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockpls/models/product_model.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void add(Product product) {
    state = [...state, product];
  }

  void remove(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }

  void clear() {
    state = [];
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
  (ref) => ProductNotifier(),
);
