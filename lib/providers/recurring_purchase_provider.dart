import 'package:flutter/foundation.dart';
import '../models/recurring_purchase.dart';
import '../models/product.dart';

class RecurringPurchaseProvider extends ChangeNotifier {
  List<RecurringPurchase> _recurringPurchases = [];
  bool _isLoading = false;

  List<RecurringPurchase> get recurringPurchases => _recurringPurchases;
  List<RecurringPurchase> get activeRecurringPurchases =>
      _recurringPurchases.where((rp) => rp.isActive).toList();
  bool get isLoading => _isLoading;

  RecurringPurchaseProvider() {
    _loadRecurringPurchases();
  }

  // Cargar compras recurrentes (por ahora en memoria)
  Future<void> _loadRecurringPurchases() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar persistencia con SharedPreferences o base de datos
      await Future.delayed(const Duration(milliseconds: 500));
      _updateNextOrderDates();
    } catch (e) {
      debugPrint('Error loading recurring purchases: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Guardar compras recurrentes (por ahora en memoria)
  Future<void> _saveRecurringPurchases() async {
    try {
      // TODO: Implementar persistencia con SharedPreferences o base de datos
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('Error saving recurring purchases: $e');
    }
  }

  // Agregar nueva compra recurrente
  Future<void> addRecurringPurchase({
    required Product product,
    required int quantity,
    required RecurringFrequency frequency,
  }) async {
    final now = DateTime.now();
    final nextOrder = now.add(Duration(days: frequency.days));
    
    final newPurchase = RecurringPurchase(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      quantity: quantity,
      frequency: frequency,
      startDate: now,
      nextOrderDate: nextOrder,
      isActive: true,
      createdAt: now,
      totalSaved: 0,
      ordersCompleted: 0,
    );

    _recurringPurchases.add(newPurchase);
    await _saveRecurringPurchases();
    notifyListeners();
  }

  // Actualizar compra recurrente
  Future<void> updateRecurringPurchase(RecurringPurchase purchase) async {
    final index = _recurringPurchases.indexWhere((rp) => rp.id == purchase.id);
    if (index != -1) {
      _recurringPurchases[index] = purchase;
      await _saveRecurringPurchases();
      notifyListeners();
    }
  }

  // Eliminar compra recurrente
  Future<void> deleteRecurringPurchase(String id) async {
    _recurringPurchases.removeWhere((rp) => rp.id == id);
    await _saveRecurringPurchases();
    notifyListeners();
  }

  // Pausar/Reanudar compra recurrente
  Future<void> toggleRecurringPurchase(String id) async {
    final index = _recurringPurchases.indexWhere((rp) => rp.id == id);
    if (index != -1) {
      _recurringPurchases[index] = _recurringPurchases[index].copyWith(
        isActive: !_recurringPurchases[index].isActive,
      );
      await _saveRecurringPurchases();
      notifyListeners();
    }
  }

  // Actualizar cantidad
  Future<void> updateQuantity(String id, int quantity) async {
    final index = _recurringPurchases.indexWhere((rp) => rp.id == id);
    if (index != -1) {
      _recurringPurchases[index] = _recurringPurchases[index].copyWith(
        quantity: quantity,
      );
      await _saveRecurringPurchases();
      notifyListeners();
    }
  }

  // Actualizar frecuencia
  Future<void> updateFrequency(String id, RecurringFrequency frequency) async {
    final index = _recurringPurchases.indexWhere((rp) => rp.id == id);
    if (index != -1) {
      final now = DateTime.now();
      _recurringPurchases[index] = _recurringPurchases[index].copyWith(
        frequency: frequency,
        nextOrderDate: now.add(Duration(days: frequency.days)),
      );
      await _saveRecurringPurchases();
      notifyListeners();
    }
  }

  // Actualizar fechas de próxima orden
  void _updateNextOrderDates() {
    final now = DateTime.now();
    bool hasChanges = false;

    for (int i = 0; i < _recurringPurchases.length; i++) {
      final purchase = _recurringPurchases[i];
      
      if (purchase.isActive && purchase.nextOrderDate != null) {
        if (purchase.nextOrderDate!.isBefore(now)) {
          // Calcular nueva fecha de orden
          final nextOrder = now.add(Duration(days: purchase.frequency.days));
          _recurringPurchases[i] = purchase.copyWith(
            nextOrderDate: nextOrder,
            ordersCompleted: purchase.ordersCompleted + 1,
          );
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      _saveRecurringPurchases();
    }
  }

  // Obtener ahorro total estimado
  double get totalMonthlySavings {
    return _recurringPurchases
        .where((rp) => rp.isActive)
        .fold(0, (sum, rp) => sum + (rp.product.originalPrice != null 
            ? ((rp.product.originalPrice! - rp.product.price) * rp.quantity * 30) / rp.frequency.days
            : 0));
  }

  // Obtener gasto mensual estimado
  double get totalMonthlySpending {
    return _recurringPurchases
        .where((rp) => rp.isActive)
        .fold(0, (sum, rp) => sum + rp.monthlyTotal);
  }

  // Verificar si un producto ya está en compras recurrentes
  bool isProductRecurring(String productId) {
    return _recurringPurchases.any(
      (rp) => rp.product.id == productId && rp.isActive,
    );
  }

  // Obtener próximas órdenes (próximos 30 días)
  List<RecurringPurchase> get upcomingOrders {
    final now = DateTime.now();
    final in30Days = now.add(const Duration(days: 30));
    
    return _recurringPurchases
        .where((rp) => 
            rp.isActive && 
            rp.nextOrderDate != null &&
            rp.nextOrderDate!.isBefore(in30Days))
        .toList()
      ..sort((a, b) => a.nextOrderDate!.compareTo(b.nextOrderDate!));
  }
}
