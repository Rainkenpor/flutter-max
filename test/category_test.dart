import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🧪 Testing Categories API...\n');

  try {
    // Test 1: Obtener categorías
    print('📡 Fetching categories from API...');
    final response = await http.get(
      Uri.parse('https://apigt.tienda.max.com.gt/v1/catalogs/categories/summary?categoryDepth=5&categoryType=Base%2CPromoci%C3%B3n'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Origin': 'https://www.max.com.gt',
        'x-api-key': 'ROGi1LWB3saRqFw4Xdqc4Z9jGWVxYLl9ZEZjbJu9',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body Length: ${response.body.length} bytes\n');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      
      print('📦 Response Structure:');
      print('Type: ${data.runtimeType}');
      print('Keys: ${data is Map ? data.keys.toList() : "Not a Map"}');
      print('\n');

      // Verificar si es un array directo o un objeto con array
      if (data is List) {
        print('✅ Response is a direct array');
        print('Total categories: ${data.length}');
        
        if (data.isNotEmpty) {
          print('\n📋 First Category Structure:');
          final firstCategory = data[0];
          print(json.encode(firstCategory));
          print('\n');
          
          print('First Category Fields:');
          if (firstCategory is Map) {
            firstCategory.forEach((key, value) {
              print('  - $key: ${value.runtimeType} ${value is List ? "(${value.length} items)" : ""}');
            });
          }
          
          // Verificar si tiene children/subcategorías
          if (firstCategory['children'] != null) {
            print('\n🔸 Has children/subcategories: ${firstCategory['children'].length}');
            if (firstCategory['children'].isNotEmpty) {
              print('First subcategory structure:');
              print(json.encode(firstCategory['children'][0]));
            }
          }
        }
      } else if (data is Map) {
        print('✅ Response is an object');
        print('Keys in response: ${data.keys.toList()}');
        
        // Buscar el array de categorías
        data.forEach((key, value) {
          print('  - $key: ${value.runtimeType} ${value is List ? "(${value.length} items)" : ""}');
          
          if (value is List && value.isNotEmpty) {
            print('\n📋 First item in "$key":');
            print(json.encode(value[0]));
          }
        });
      }

      // Test 2: Verificar campos específicos
      print('\n\n🔍 Checking Expected Fields...');
      final categories = data is List ? data : (data['categories'] ?? data['data'] ?? []);
      
      if (categories is List && categories.isNotEmpty) {
        final firstCat = categories[0];
        print('Checking first category fields:');
        print('  ✓ Has "id": ${firstCat['id'] != null}');
        print('  ✓ Has "name": ${firstCat['name'] != null}');
        print('  ✓ Has "title": ${firstCat['title'] != null}');
        print('  ✓ Has "icon": ${firstCat['icon'] != null}');
        print('  ✓ Has "image": ${firstCat['image'] != null}');
        print('  ✓ Has "children": ${firstCat['children'] != null}');
        print('  ✓ Has "subcategories": ${firstCat['subcategories'] != null}');
        
        print('\n📊 Available Fields in First Category:');
        if (firstCat is Map) {
          firstCat.keys.forEach((key) {
            print('  - $key');
          });
        }
      }

    } else {
      print('❌ Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }

  } catch (e) {
    print('❌ Error during test: $e');
  }
}
