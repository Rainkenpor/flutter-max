import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recurring_purchase_provider.dart';
import '../providers/product_provider.dart';
import '../core/theme/app_colors.dart';
import '../models/recurring_purchase.dart';
import '../models/product.dart';

class RecurringPurchasesScreen extends StatefulWidget {
  const RecurringPurchasesScreen({super.key});

  @override
  State<RecurringPurchasesScreen> createState() =>
      _RecurringPurchasesScreenState();
}

class _RecurringPurchasesScreenState extends State<RecurringPurchasesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Compras Recurrentes'),
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: 'Mis Compras'),
            Tab(text: 'Agregar Nueva'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Estadísticas
          Consumer<RecurringPurchaseProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Activas',
                        value: '${provider.activeRecurringPurchases.length}',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_today,
                        label: 'Próximas',
                        value: '${provider.upcomingOrders.length}',
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.savings_outlined,
                        label: 'Ahorro/mes',
                        value:
                            'Q${provider.totalMonthlySavings.toStringAsFixed(0)}',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _MyRecurringPurchasesTab(),
                _AddRecurringPurchaseTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de estadística
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Tab de mis compras recurrentes
class _MyRecurringPurchasesTab extends StatelessWidget {
  const _MyRecurringPurchasesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<RecurringPurchaseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.recurringPurchases.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.autorenew_rounded,
                  size: 80,
                  color: AppColors.grey400.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                const Text(
                  '¡Empieza a ahorrar tiempo!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'Configura compras automáticas para tus productos favoritos y nunca te quedes sin ellos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textLight),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // Cambiar a la pestaña "Agregar Nueva"
                    DefaultTabController.of(context).animateTo(1);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Primera Compra'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.recurringPurchases.length,
          itemBuilder: (context, index) {
            final purchase = provider.recurringPurchases[index];
            return _RecurringPurchaseCard(purchase: purchase);
          },
        );
      },
    );
  }
}

// Card de compra recurrente
class _RecurringPurchaseCard extends StatelessWidget {
  final RecurringPurchase purchase;

  const _RecurringPurchaseCard({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final daysUntilNext = purchase.daysUntilNext;
    final isUpcoming = daysUntilNext <= 7 && daysUntilNext > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUpcoming ? Colors.orange.withOpacity(0.3) : AppColors.border,
          width: isUpcoming ? 2 : 1,
        ),
        boxShadow: [
          if (isUpcoming)
            BoxShadow(
              color: Colors.orange.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        children: [
          // Información del producto
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagen del producto
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: purchase.product.images.isNotEmpty
                        ? purchase.product.images.first
                        : '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.grey100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.grey100,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Detalles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              purchase.product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Switch activo/inactivo
                          Switch(
                            value: purchase.isActive,
                            onChanged: (value) {
                              context
                                  .read<RecurringPurchaseProvider>()
                                  .toggleRecurringPurchase(purchase.id);
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Frecuencia y cantidad
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  purchase.frequency.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '×${purchase.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Precio
                      Text(
                        'Q${(purchase.product.price * purchase.quantity).toStringAsFixed(2)} por orden',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Información de próxima orden
          if (purchase.isActive && purchase.nextOrderDate != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUpcoming
                    ? Colors.orange.withOpacity(0.1)
                    : AppColors.grey50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isUpcoming ? Icons.warning_amber_rounded : Icons.schedule,
                    size: 16,
                    color: isUpcoming ? Colors.orange : AppColors.grey400,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      daysUntilNext == 0
                          ? 'Próxima orden: ¡Hoy!'
                          : daysUntilNext == 1
                          ? 'Próxima orden: Mañana'
                          : 'Próxima orden: En $daysUntilNext días',
                      style: TextStyle(
                        fontSize: 13,
                        color: isUpcoming
                            ? Colors.orange[700]
                            : AppColors.textLight,
                        fontWeight: isUpcoming
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),

                  // Botón de editar
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    color: AppColors.grey400,
                    onPressed: () {
                      _showEditDialog(context, purchase);
                    },
                  ),

                  // Botón de eliminar
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.red,
                    onPressed: () {
                      _showDeleteDialog(context, purchase);
                    },
                  ),
                ],
              ),
            ),

          // Estadísticas adicionales
          if (!purchase.isActive)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.pause_circle_outline,
                    size: 16,
                    color: AppColors.grey400,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Compra pausada',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Botón de editar
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    color: AppColors.grey400,
                    onPressed: () {
                      _showEditDialog(context, purchase);
                    },
                  ),

                  // Botón de eliminar
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.red,
                    onPressed: () {
                      _showDeleteDialog(context, purchase);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, RecurringPurchase purchase) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditRecurringPurchaseSheet(purchase: purchase),
    );
  }

  void _showDeleteDialog(BuildContext context, RecurringPurchase purchase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar compra recurrente'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${purchase.product.name}" de tus compras recurrentes?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<RecurringPurchaseProvider>().deleteRecurringPurchase(
                purchase.id,
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// Bottom sheet para editar compra recurrente
class _EditRecurringPurchaseSheet extends StatefulWidget {
  final RecurringPurchase purchase;

  const _EditRecurringPurchaseSheet({required this.purchase});

  @override
  State<_EditRecurringPurchaseSheet> createState() =>
      _EditRecurringPurchaseSheetState();
}

class _EditRecurringPurchaseSheetState
    extends State<_EditRecurringPurchaseSheet> {
  late int _quantity;
  late RecurringFrequency _frequency;

  @override
  void initState() {
    super.initState();
    _quantity = widget.purchase.quantity;
    _frequency = widget.purchase.frequency;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Editar compra recurrente',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 24),

              // Cantidad
              const Text(
                'Cantidad',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1
                        ? () {
                            setState(() => _quantity--);
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _quantity++);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Frecuencia
              const Text(
                'Frecuencia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RecurringFrequency.values.map((freq) {
                  final isSelected = _frequency == freq;
                  return ChoiceChip(
                    label: Text(freq.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _frequency = freq);
                      }
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final provider = context.read<RecurringPurchaseProvider>();
                    provider.updateQuantity(widget.purchase.id, _quantity);
                    provider.updateFrequency(widget.purchase.id, _frequency);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tab para agregar nueva compra recurrente
class _AddRecurringPurchaseTab extends StatelessWidget {
  const _AddRecurringPurchaseTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Combinar productos destacados y en oferta
        final products = [
          ...productProvider.featuredProducts,
          ...productProvider.saleProducts,
        ];

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: AppColors.grey400.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No hay productos disponibles',
                  style: TextStyle(fontSize: 16, color: AppColors.textLight),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isRecurring = context
                .watch<RecurringPurchaseProvider>()
                .isProductRecurring(product.id);

            return _AddProductCard(product: product, isRecurring: isRecurring);
          },
        );
      },
    );
  }
}

// Card para agregar producto
class _AddProductCard extends StatelessWidget {
  final Product product;
  final bool isRecurring;

  const _AddProductCard({required this.product, required this.isRecurring});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isRecurring
              ? null
              : () {
                  _showAddDialog(context, product);
                },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagen del producto
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: product.images.isNotEmpty
                        ? product.images.first
                        : '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.grey100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.grey100,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Detalles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Q${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Botón agregar
                if (isRecurring)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'Activa',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  IconButton(
                    onPressed: () {
                      _showAddDialog(context, product);
                    },
                    icon: const Icon(Icons.add_circle),
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddRecurringPurchaseSheet(product: product),
    );
  }
}

// Bottom sheet para agregar compra recurrente
class _AddRecurringPurchaseSheet extends StatefulWidget {
  final Product product;

  const _AddRecurringPurchaseSheet({required this.product});

  @override
  State<_AddRecurringPurchaseSheet> createState() =>
      _AddRecurringPurchaseSheetState();
}

class _AddRecurringPurchaseSheetState
    extends State<_AddRecurringPurchaseSheet> {
  int _quantity = 1;
  RecurringFrequency _frequency = RecurringFrequency.monthly;

  @override
  Widget build(BuildContext context) {
    final monthlyTotal =
        (widget.product.price * _quantity * 30) / _frequency.days;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Título
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.autorenew_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Configurar compra recurrente',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Producto
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.images.isNotEmpty
                          ? widget.product.images.first
                          : '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: AppColors.grey100),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.grey100,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Q${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Cantidad
              const Text(
                'Cantidad por orden',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1
                        ? () {
                            setState(() => _quantity--);
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                    iconSize: 32,
                  ),
                  Expanded(
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _quantity++);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                    iconSize: 32,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Frecuencia
              const Text(
                '¿Cada cuánto lo necesitas?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RecurringFrequency.values.map((freq) {
                  final isSelected = _frequency == freq;
                  return ChoiceChip(
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(freq.label),
                        Text(
                          freq.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white70
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _frequency = freq);
                      }
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Resumen
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Costo mensual estimado:',
                          style: TextStyle(fontSize: 14, color: AppColors.text),
                        ),
                        Text(
                          'Q${monthlyTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recibirás $_quantity ${_quantity == 1 ? 'unidad' : 'unidades'} ${_frequency.description.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Botón agregar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context
                        .read<RecurringPurchaseProvider>()
                        .addRecurringPurchase(
                          product: widget.product,
                          quantity: _quantity,
                          frequency: _frequency,
                        );

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '¡${widget.product.name} agregado a compras recurrentes!',
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Activar compra recurrente',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


