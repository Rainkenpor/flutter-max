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
    return Product(
      id: json['id'] ?? json['sku'] ?? '',
      name: json['name'] ?? json['description'] ?? '',
      description: json['description'] ?? json['longDescription'] ?? '',
      price: _parsePrice(json['price'] ?? json['normalPrice']),
      originalPrice: json['originalPrice'] != null 
          ? _parsePrice(json['originalPrice']) 
          : null,
      images: _parseImages(json['images'] ?? json['image'] ?? []),
      category: json['category'] ?? json['categoryName'] ?? '',
      brand: json['brand'] ?? json['manufacturer'],
      sizes: _parseSizes(json['sizes'] ?? json['attributes']?['size']),
      colors: _parseColors(json['colors'] ?? json['attributes']?['color']),
      isHighRated: json['isHighRated'] ?? false,
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
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

  static List<String> _parseImages(dynamic images) {
    if (images is List) {
      return images.map((e) => e.toString()).toList();
    }
    if (images is String) {
      return [images];
    }
    return [];
  }

  static List<String>? _parseSizes(dynamic sizes) {
    if (sizes == null) return null;
    if (sizes is List) {
      return sizes.map((e) => e.toString()).toList();
    }
    return null;
  }

  static List<ProductColor>? _parseColors(dynamic colors) {
    if (colors == null) return null;
    if (colors is List) {
      return colors.map((e) {
        if (e is Map) {
          return ProductColor.fromJson(e as Map<String, dynamic>);
        }
        return ProductColor(name: e.toString(), hex: '#000000');
      }).toList();
    }
    return null;
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
