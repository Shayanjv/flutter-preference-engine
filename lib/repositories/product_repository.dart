import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {
  ProductRepository(this._service);

  final ProductService _service;
  List<Product>? _cache;

  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache != null) {
      return _cache!;
    }

    final products = await _service.fetchProducts();
    _cache = products;
    return products;
  }
}
