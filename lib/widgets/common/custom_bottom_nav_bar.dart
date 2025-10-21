import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey400,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.grid_view_rounded,
                isSelected: currentIndex == 0,
              ),
              label: 'Categorías',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.favorite_border,
                isSelected: currentIndex == 1,
              ),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.home_outlined,
                isSelected: currentIndex == 2,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.shopping_bag_outlined,
                isSelected: currentIndex == 3,
                showBadge: true,
              ),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.person_outline,
                isSelected: currentIndex == 4,
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final bool showBadge;

  const _NavIcon({
    required this.icon,
    required this.isSelected,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container(
      padding: isSelected
          ? const EdgeInsets.symmetric(horizontal: 17, vertical: 8)
          : const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : AppColors.grey400,
        size: 24,
      ),
    );

    if (showBadge) {
      return Consumer<CartProvider>(
        builder: (context, cart, child) {
          final itemCount = cart.totalQuantity;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              iconWidget,
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      itemCount > 9 ? '9+' : '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }

    return iconWidget;
  }
}
