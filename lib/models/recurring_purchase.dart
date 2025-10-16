import 'product.dart';

enum RecurringFrequency {
  daily(1, 'Diario', 'Todos los días'),
  weekly(7, 'Semanal', 'Cada semana'),
  biweekly(14, 'Quincenal', 'Cada 15 días'),
  monthly(30, 'Mensual', 'Cada mes'),
  bimonthly(60, 'Bimensual', 'Cada 2 meses'),
  quarterly(90, 'Trimestral', 'Cada 3 meses');

  final int days;
  final String label;
  final String description;

  const RecurringFrequency(this.days, this.label, this.description);
}

class RecurringPurchase {
  final String id;
  final Product product;
  final int quantity;
  final RecurringFrequency frequency;
  final DateTime startDate;
  final DateTime? nextOrderDate;
  final bool isActive;
  final DateTime createdAt;
  final double totalSaved;
  final int ordersCompleted;

  RecurringPurchase({
    required this.id,
    required this.product,
    required this.quantity,
    required this.frequency,
    required this.startDate,
    this.nextOrderDate,
    this.isActive = true,
    required this.createdAt,
    this.totalSaved = 0,
    this.ordersCompleted = 0,
  });

  RecurringPurchase copyWith({
    String? id,
    Product? product,
    int? quantity,
    RecurringFrequency? frequency,
    DateTime? startDate,
    DateTime? nextOrderDate,
    bool? isActive,
    DateTime? createdAt,
    double? totalSaved,
    int? ordersCompleted,
  }) {
    return RecurringPurchase(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextOrderDate: nextOrderDate ?? this.nextOrderDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      totalSaved: totalSaved ?? this.totalSaved,
      ordersCompleted: ordersCompleted ?? this.ordersCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'frequency': frequency.name,
      'startDate': startDate.toIso8601String(),
      'nextOrderDate': nextOrderDate?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'totalSaved': totalSaved,
      'ordersCompleted': ordersCompleted,
    };
  }

  factory RecurringPurchase.fromJson(Map<String, dynamic> json) {
    return RecurringPurchase(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      frequency: RecurringFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => RecurringFrequency.monthly,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      nextOrderDate: json['nextOrderDate'] != null
          ? DateTime.parse(json['nextOrderDate'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalSaved: (json['totalSaved'] as num?)?.toDouble() ?? 0,
      ordersCompleted: json['ordersCompleted'] as int? ?? 0,
    );
  }

  double get monthlyTotal => (product.price * quantity * 30) / frequency.days;
  
  int get daysUntilNext {
    if (nextOrderDate == null) return 0;
    return nextOrderDate!.difference(DateTime.now()).inDays;
  }
}
