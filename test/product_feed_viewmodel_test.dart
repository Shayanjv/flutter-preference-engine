import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_preference_engine/models/product.dart';
import 'package:flutter_preference_engine/repositories/product_repository.dart';
import 'package:flutter_preference_engine/services/product_service.dart';
import 'package:flutter_preference_engine/viewmodels/product_feed_viewmodel.dart';

class _FakeProductService extends ProductService {
  _FakeProductService(this._products);

  final List<Product> _products;

  @override
  Future<List<Product>> fetchProducts() async => _products;
}

void main() {
  test('ProductFeedViewModel filters by category and search query', () async {
    final products = [
      const Product(
        id: 1,
        title: 'Blue Shirt',
        price: 20,
        description: 'Cotton shirt',
        category: 'clothes',
        image: 'img',
      ),
      const Product(
        id: 2,
        title: 'Silver Ring',
        price: 40,
        description: 'Accessory',
        category: 'jewelry',
        image: 'img',
      ),
    ];

    final repository = ProductRepository(_FakeProductService(products));
    final viewModel = ProductFeedViewModel(repository);

    await viewModel.load();
    viewModel.setCategory('clothes');
    viewModel.setSearchQuery('blue');

    expect(viewModel.products.length, 1);
    expect(viewModel.products.first.id, 1);
  });
}
