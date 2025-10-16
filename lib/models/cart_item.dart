import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedSize;
  final ProductColor? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor?.toJson(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'],
      selectedColor: json['selectedColor'] != null
          ? ProductColor.fromJson(json['selectedColor'])
          : null,
    );
  }

  // Para comparar items en el carrito
  String get uniqueKey => 
      '${product.id}_${selectedSize ?? ''}_${selectedColor?.name ?? ''}';
}
