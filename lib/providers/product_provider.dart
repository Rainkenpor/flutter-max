import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart' as models;
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _featuredProducts = [];
  List<Product> _saleProducts = [];
  List<models.Category> _categories = [];
  Map<String, List<Product>> _productsByCategory = {};

  bool _isLoading = false;
  String? _error;

  List<Product> get featuredProducts => [..._featuredProducts];
  List<Product> get saleProducts => [..._saleProducts];
  List<models.Category> get categories => [..._categories];
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Product> getProductsByCategory(String categoryId) {
    return _productsByCategory[categoryId] ?? [];
  }

  Future<void> loadFeaturedProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _featuredProducts = await ApiService.getFeaturedProducts();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar productos destacados: $e';
      _featuredProducts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadSaleProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _saleProducts = await ApiService.getSaleProducts();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar productos en oferta: $e';
      _saleProducts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await ApiService.getCategories();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar categorías: $e';
      _categories = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final products = await ApiService.getProductsByCategory(categoryId);
      _productsByCategory[categoryId] = products;
      _error = null;
    } catch (e) {
      _error = 'Error al cargar productos de categoría: $e';
      _productsByCategory[categoryId] = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      return await ApiService.searchProducts(query);
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  Future<void> loadAllData() async {
    await Future.wait([
      loadFeaturedProducts(),
      loadSaleProducts(),
      loadCategories(),
    ]);
  }
}
