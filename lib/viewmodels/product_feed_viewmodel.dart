import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductFeedViewModel extends ChangeNotifier {
  ProductFeedViewModel(this._repository);

  final ProductRepository _repository;
  List<Product> _allProducts = <Product>[];
  List<Product> _filteredProducts = <Product>[];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = _allCategories;

  static const String _allCategories = 'All';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Product> get products => List.unmodifiable(_filteredProducts);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<String> get categories {
    final unique = _allProducts.map((p) => p.category).toSet().toList()..sort();
    return <String>[_allCategories, ...unique];
  }

  Future<void> load({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _repository.getProducts(forceRefresh: forceRefresh);
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Unable to load products. Pull to refresh and try again.';
      _filteredProducts = <Product>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    final normalized = _searchQuery.toLowerCase();

    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == _allCategories ||
          product.category == _selectedCategory;
      final matchesSearch = product.title.toLowerCase().contains(normalized) ||
          product.description.toLowerCase().contains(normalized);
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
