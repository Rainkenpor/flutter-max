import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get shipping => subtotal > 0 ? 10.10 : 0.0;

  double _discount = 0.0;
  double get discount => _discount;

  double get total => subtotal + shipping - discount;

  void addItem(
    Product product, {
    String? selectedSize,
    ProductColor? selectedColor,
  }) {
    final cartItem = CartItem(
      product: product,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
    );

    final key = cartItem.uniqueKey;

    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
    } else {
      _items[key] = cartItem;
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void updateQuantity(String key, int quantity) {
    if (_items.containsKey(key)) {
      if (quantity <= 0) {
        _items.remove(key);
      } else {
        _items[key]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String key) {
    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String key) {
    if (_items.containsKey(key)) {
      if (_items[key]!.quantity > 1) {
        _items[key]!.quantity--;
      } else {
        _items.remove(key);
      }
      notifyListeners();
    }
  }

  void applyPromoCode(String code) {
    // Simulación de aplicar código promocional
    // En producción, esto debería validarse con el backend
    if (code.toLowerCase() == 'max10') {
      _discount = subtotal * 0.1;
    } else if (code.toLowerCase() == 'max20') {
      _discount = subtotal * 0.2;
    } else {
      _discount = 0.0;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discount = 0.0;
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.values.any((item) => item.product.id == productId);
  }
}
