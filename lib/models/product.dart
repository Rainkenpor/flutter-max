class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String category;
  final String? brand;
  final List<String>? sizes;
  final List<ProductColor>? colors;
  final bool isHighRated;
  final double? rating;
  final int? reviewCount;
  final Map<String, dynamic>? additionalData;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.category,
    this.brand,
    this.sizes,
    this.colors,
    this.isHighRated = false,
    this.rating,
    this.reviewCount,
    this.additionalData,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Extraer precio de la estructura real de la API
    final prices = json['prices'] as Map<String, dynamic>?;
    double regularPrice = 0.0;
    double? salesPrice;
    
    if (prices != null) {
      regularPrice = _parsePrice(prices['regularPrice']?['value']);
      final salePriceValue = prices['salesPrice']?['value'];
      if (salePriceValue != null) {
        salesPrice = _parsePrice(salePriceValue);
      }
    }
    
    // Usar salesPrice si existe, sino regularPrice
    final finalPrice = salesPrice ?? regularPrice;
    final originalPriceValue = salesPrice != null ? regularPrice : null;
    
    // Extraer imagen
    final thumbnailImage = json['thumbnailImage'] as Map<String, dynamic>?;
    final imageUrl = thumbnailImage?['url'] as String?;
    
    // Extraer categorías
    final categories = json['categories'] as List?;
    final categoryName = categories != null && categories.isNotEmpty
        ? categories.first['title'] ?? ''
        : '';
    
    // Extraer marca
    final brandData = json['brand'] as Map<String, dynamic>?;
    final brandName = brandData?['name'] as String?;
    
    return Product(
      id: json['sku'] ?? json['id'] ?? '',
      name: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      price: finalPrice,
      originalPrice: originalPriceValue,
      images: imageUrl != null ? [imageUrl] : [],
      category: categoryName,
      brand: brandName,
      sizes: null, // Las tallas vendrían en variants si existen
      colors: null, // Los colores vendrían en variants si existen
      isHighRated: false, // Podría basarse en ratings si existen
      rating: null,
      reviewCount: null,
      additionalData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'images': images,
      'category': category,
      'brand': brand,
      'sizes': sizes,
      'colors': colors?.map((c) => c.toJson()).toList(),
      'isHighRated': isHighRated,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      return double.tryParse(price.replaceAll(',', '')) ?? 0.0;
    }
    return 0.0;
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }
}

class ProductColor {
  final String name;
  final String hex;

  ProductColor({
    required this.name,
    required this.hex,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      name: json['name'] ?? '',
      hex: json['hex'] ?? json['color'] ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hex': hex,
    };
  }
}
