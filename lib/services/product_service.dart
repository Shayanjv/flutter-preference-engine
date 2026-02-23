import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static final Uri _productsUri = Uri.parse('https://fakestoreapi.com/products');

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(_productsUri);
      if (response.statusCode != 200) {
        throw ProductServiceException(
          'Unexpected response: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body) as List<dynamic>;
      return decoded
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ProductServiceException) {
        rethrow;
      }
      throw ProductServiceException('Failed to fetch products: $e');
    }
  }
}

class ProductServiceException implements Exception {
  ProductServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
