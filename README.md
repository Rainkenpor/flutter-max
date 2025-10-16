# Max Marketplace

Aplicación de marketplace móvil para tiendas Max Guatemala desarrollada en Flutter.

## 📱 Características

### Implementado

- **Home Screen** 
  - Banner carousel con promociones
  - Sección de marcas (Nike, Adidas, Puma, NB, Converse)
  - Today Sale con countdown timer
  - Productos destacados
  - Barra de búsqueda

- **Categorías**
  - Grid de categorías disponibles
  - Navegación a productos por categoría

- **Favoritos**
  - Gestión de productos favoritos
  - Persistencia de favoritos

- **Carrito de Compras (My Chart)**
  - Agregar/eliminar productos
  - Control de cantidad
  - Aplicación de códigos promocionales
  - Resumen de compra (subtotal, envío, descuentos)
  - Checkout

- **Detalle de Producto**
  - Carousel de imágenes
  - Selección de tallas
  - Selección de colores
  - Badge de "High Rated"
  - Agregar a favoritos
  - Agregar al carrito

- **Perfil de Usuario**
  - Información del usuario
  - Sección de Max Loyalty (próximamente)
  - Mis órdenes
  - Direcciones
  - Métodos de pago
  - Configuración

### Paleta de Colores

- **Rojo Principal**: `#FF0000`
- **Negro**: `#111826`
- **Blanco**: `#FFFFFF`
- **Grises**: Varios tonos para UI

## 🛠️ Tecnologías

- **Flutter**: Framework de desarrollo
- **Provider**: State management
- **HTTP**: Consumo de APIs
- **Cached Network Image**: Caché de imágenes
- **Carousel Slider**: Carouseles de imágenes
- **Smooth Page Indicator**: Indicadores de página

## 📡 APIs Integradas

El proyecto consume los siguientes endpoints de Max:

- **Categorías**: `GET /v1/catalogs/categories/summary`
- **Productos por IDs**: `POST /v2/products/byTarget`
- **Localizaciones**: `GET /v1/catalogs/locations`
- **Strapi (Categorías)**: `GET /api/category-infos`

API Key: `ROGi1LWB3saRqFw4Xdqc4Z9jGWVxYLl9ZEZjbJu9`

## 📂 Estructura del Proyecto

```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
├── models/
│   ├── product.dart
│   ├── category.dart
│   ├── cart_item.dart
│   └── user.dart
├── providers/
│   ├── cart_provider.dart
│   ├── favorites_provider.dart
│   └── product_provider.dart
├── screens/
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── categories_screen.dart
│   ├── favorites_screen.dart
│   ├── cart_screen.dart
│   ├── profile_screen.dart
│   └── product_detail_screen.dart
├── services/
│   └── api_service.dart
├── widgets/
│   └── common/
│       ├── custom_bottom_nav_bar.dart
│       └── product_card.dart
└── main.dart
```

## 🚀 Instalación y Ejecución

### Requisitos previos
- Flutter SDK (>=3.9.2)
- Dart SDK
- Android Studio o Xcode (para emuladores)

### Pasos

1. Clonar el repositorio
```bash
git clone [url-del-repositorio]
cd max_marketplace
```

2. Instalar dependencias
```bash
flutter pub get
```

3. Ejecutar la aplicación
```bash
flutter run
```

## 📝 Códigos Promocionales de Prueba

- `max10`: 10% de descuento
- `max20`: 20% de descuento

## 🎯 Próximas Funcionalidades

### Por Implementar

- **Max Loyalty Program**
  - Sistema de puntos
  - Niveles de membresía (Bronze, Silver, Gold)
  - Recompensas exclusivas
  - Historial de puntos

- **Búsqueda Avanzada**
  - Filtros por categoría
  - Filtros por precio
  - Ordenamiento

- **Autenticación**
  - Login/Registro
  - Recuperación de contraseña
  - OAuth (Google, Facebook)

- **Checkout Completo**
  - Selección de dirección de envío
  - Métodos de pago
  - Confirmación de orden

- **Órdenes**
  - Historial de compras
  - Tracking de envíos
  - Detalles de orden

## 🔧 Configuración de Desarrollo

### Variables de Entorno

Las URLs de API y la API Key están configuradas en:
`lib/services/api_service.dart`

### Testing

```bash
# Ejecutar tests
flutter test

# Análisis de código
flutter analyze
```

## 📱 Navegación

La aplicación utiliza un `BottomNavigationBar` personalizado con 5 pestañas:

1. **Home** - Pantalla principal
2. **Categorías** - Explorar categorías
3. **Favoritos** - Productos guardados
4. **Carrito** - My Chart (con badge de cantidad)
5. **Perfil** - Configuración y loyalty

## 🎨 Diseño

El diseño está basado en las imágenes de referencia proporcionadas, siguiendo los principios de:

- Material Design
- UX/UI moderna y limpia
- Paleta de colores de Max
- Componentes reutilizables
- Responsive design

## 📄 Licencia

Este proyecto es privado y pertenece a Max Guatemala.

## 👥 Autor

Desarrollado para Max Marketplace

---

**Versión**: 1.0.0+1
**Última actualización**: Octubre 2025
