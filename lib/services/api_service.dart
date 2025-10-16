import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://apigt.tienda.max.com.gt';
  static const String strapiUrl = 'https://strapi.tienda.max.com.gt/api';
  static const String apiKey = 'ROGi1LWB3saRqFw4Xdqc4Z9jGWVxYLl9ZEZjbJu9';

  // Headers comunes
  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      };

  // Obtener categorías
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/v1/catalogs/categories/summary?categoryDepth=5&categoryType=Base%2CPromoci%C3%B3n',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((e) => Category.fromJson(e)).toList();
        } else if (data is Map && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => Category.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Obtener información de categorías desde Strapi
  static Future<List<Category>> getCategoriesInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$strapiUrl/category-infos?populate=deep'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => Category.fromJson(e['attributes'] ?? e))
              .toList();
        }
        return [];
      } else {
        throw Exception(
            'Failed to load categories info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories info: $e');
      return [];
    }
  }

  // Obtener productos por IDs
  static Future<List<Product>> getProductsByIds(List<String> ids) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v2/products/byTarget'),
        headers: _headers,
        body: json.encode({
          'target': 'ids',
          'keyParameters': {'ids': ids}
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((e) => Product.fromJson(e)).toList();
        } else if (data is Map && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => Product.fromJson(e))
              .toList();
        } else if (data is Map && data['products'] != null) {
          return (data['products'] as List)
              .map((e) => Product.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products by ids: $e');
      return [];
    }
  }

  // Obtener productos por categoría
  static Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v2/products/byTarget'),
        headers: _headers,
        body: json.encode({
          'target': 'category',
          'keyParameters': {'categoryId': categoryId}
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((e) => Product.fromJson(e)).toList();
        } else if (data is Map && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => Product.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception(
            'Failed to load products by category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Buscar productos
  static Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v2/products/byTarget'),
        headers: _headers,
        body: json.encode({
          'target': 'search',
          'keyParameters': {'query': query}
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((e) => Product.fromJson(e)).toList();
        } else if (data is Map && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => Product.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Obtener localizaciones
  static Future<List<Map<String, dynamic>>> getLocations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/catalogs/locations?type=delivery'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      } else {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

  // Productos destacados (simulado con IDs específicos)
  static Future<List<Product>> getFeaturedProducts() async {
    final featuredIds = [
      'SML705FDA',
      'SML300NZE',
      'BAND10PURP',
      'WATCHGT5B',
      'WATCHGT4V',
      'SML320NZS',
    ];
    return getProductsByIds(featuredIds);
  }

  // Productos en oferta
  static Future<List<Product>> getSaleProducts() async {
    final saleIds = [
      'WATCHFIT4B',
      'MIWATCH5B',
      'MIWATCH5P',
      'WATCHFIT4PROB',
      'MX4M3LZA',
      'WATCHFIT4M',
    ];
    return getProductsByIds(saleIds);
  }
}
