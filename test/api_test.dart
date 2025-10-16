import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 Testing Max APIs...\n');

  const baseUrl = 'https://apigt.tienda.max.com.gt';
  const apiKey = 'ROGi1LWB3saRqFw4Xdqc4Z9jGWVxYLl9ZEZjbJu9';

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',
    'x-api-key': apiKey,
    'Origin': 'https://www.max.com.gt',
  };

  // Test 1: Categorías
  print('📂 Testing Categories API...');
  try {
    final categoriesResponse = await http.get(
      Uri.parse(
        '$baseUrl/v1/catalogs/categories/summary?categoryDepth=5&categoryType=Base%2CPromoci%C3%B3n',
      ),
      headers: headers,
    );

    print('Status: ${categoriesResponse.statusCode}');
    if (categoriesResponse.statusCode == 200) {
      final data = json.decode(categoriesResponse.body);
      print('Response type: ${data.runtimeType}');
      if (data is List && data.isNotEmpty) {
        print('Categories count: ${data.length}');
        print('First category structure:');
        print(JsonEncoder.withIndent('  ').convert(data.first));
      } else if (data is Map) {
        print('Response is Map with keys: ${data.keys.join(", ")}');
        print(JsonEncoder.withIndent('  ').convert(data));
      }
    } else {
      print('Error: ${categoriesResponse.body}');
    }
  } catch (e) {
    print('Error fetching categories: $e');
  }

  print('\n' + '=' * 50 + '\n');

  // Test 2: Productos por IDs
  print('🛍️ Testing Products by IDs API...');
  try {
    final productsResponse = await http.post(
      Uri.parse('$baseUrl/v2/products/byTarget'),
      headers: headers,
      body: json.encode({
        'target': 'ids',
        'keyParameters': {
          'ids': ['SML705FDA', 'SML300NZE', 'BAND10PURP']
        }
      }),
    );

    print('Status: ${productsResponse.statusCode}');
    if (productsResponse.statusCode == 200) {
      final data = json.decode(productsResponse.body);
      print('Response type: ${data.runtimeType}');
      if (data is List && data.isNotEmpty) {
        print('Products count: ${data.length}');
        print('First product structure:');
        print(JsonEncoder.withIndent('  ').convert(data.first));
      } else if (data is Map) {
        print('Response is Map with keys: ${data.keys.join(", ")}');
        if (data['products'] != null) {
          print('Products count: ${(data['products'] as List).length}');
          if ((data['products'] as List).isNotEmpty) {
            print('First product:');
            print(JsonEncoder.withIndent('  ')
                .convert((data['products'] as List).first));
          }
        } else {
          print(JsonEncoder.withIndent('  ').convert(data));
        }
      }
    } else {
      print('Error: ${productsResponse.body}');
    }
  } catch (e) {
    print('Error fetching products: $e');
  }

  print('\n🎉 API Testing Complete!');
}
