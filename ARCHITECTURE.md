# Arquitectura del Proyecto - Max Marketplace

## 📐 Patrón de Arquitectura

El proyecto sigue una **arquitectura en capas** con **separación de responsabilidades**:

```
┌─────────────────────────────────────────┐
│           PRESENTACIÓN (UI)             │
│  Screens, Widgets, Navigation           │
├─────────────────────────────────────────┤
│       LÓGICA DE NEGOCIO (BLoC)         │
│  Providers (State Management)           │
├─────────────────────────────────────────┤
│          SERVICIOS (Services)           │
│  API Calls, Data Processing             │
├─────────────────────────────────────────┤
│         MODELOS (Models)                │
│  Data Classes, Entities                 │
└─────────────────────────────────────────┘
```

## 🏗️ Componentes Principales

### 1. Capa de Presentación (`/screens`, `/widgets`)

**Responsabilidad**: Interfaz de usuario y navegación

#### Screens
- `main_screen.dart` - Contenedor principal con bottom navigation
- `home_screen.dart` - Pantalla de inicio
- `categories_screen.dart` - Exploración de categorías
- `favorites_screen.dart` - Productos favoritos
- `cart_screen.dart` - Carrito de compras
- `profile_screen.dart` - Perfil de usuario
- `product_detail_screen.dart` - Detalle del producto

#### Widgets Reutilizables
- `custom_bottom_nav_bar.dart` - Barra de navegación inferior
- `product_card.dart` - Tarjeta de producto

**Principios**:
- Widgets pequeños y reutilizables
- Separación de lógica y UI
- Uso de Consumer para escuchar cambios de estado

### 2. Capa de Lógica de Negocio (`/providers`)

**Responsabilidad**: Gestión de estado y lógica de negocio

#### CartProvider
```dart
- Gestiona items del carrito
- Calcula totales y descuentos
- Aplica códigos promocionales
```

#### FavoritesProvider
```dart
- Mantiene lista de favoritos
- Toggle favoritos
- Verifica si producto es favorito
```

#### ProductProvider
```dart
- Carga productos desde API
- Gestiona categorías
- Maneja estados de carga y error
```

**Patrón**: Provider (ChangeNotifier)
- Notifica cambios a la UI automáticamente
- Estado centralizado y accesible
- Fácil testing

### 3. Capa de Servicios (`/services`)

**Responsabilidad**: Comunicación con APIs externas

#### ApiService
```dart
- Endpoints de Max API
- Parsing de respuestas
- Manejo de errores
- Headers y autenticación
```

**Métodos principales**:
- `getCategories()` - Obtener categorías
- `getProductsByIds()` - Productos por IDs
- `getProductsByCategory()` - Productos por categoría
- `searchProducts()` - Búsqueda de productos
- `getFeaturedProducts()` - Productos destacados
- `getSaleProducts()` - Productos en oferta

### 4. Capa de Modelos (`/models`)

**Responsabilidad**: Definición de estructuras de datos

#### Product
```dart
- Información del producto
- Parsing JSON
- Cálculos (descuento, etc.)
```

#### Category
```dart
- Estructura de categorías
- Soporte para subcategorías
```

#### CartItem
```dart
- Producto en carrito
- Cantidad y opciones seleccionadas
```

#### User
```dart
- Información de usuario
- LoyaltyInfo (próximamente)
```

### 5. Capa de Tema (`/core/theme`)

**Responsabilidad**: Diseño visual consistente

```dart
AppColors - Paleta de colores
AppTheme - Tema de Material Design
```

## 🔄 Flujo de Datos

### Ejemplo: Agregar producto al carrito

```
1. Usuario toca "Add to Cart"
   ↓
2. ProductDetailScreen llama a CartProvider
   ↓
3. CartProvider.addItem(product, size, color)
   ↓
4. CartProvider actualiza _items
   ↓
5. CartProvider.notifyListeners()
   ↓
6. Consumer<CartProvider> en UI se actualiza
   ↓
7. Badge en BottomNavBar muestra nuevo count
```

### Ejemplo: Cargar productos

```
1. HomeScreen inicia
   ↓
2. initState() llama ProductProvider.loadAllData()
   ↓
3. ProductProvider.loadFeaturedProducts()
   ↓
4. ApiService.getFeaturedProducts()
   ↓
5. HTTP request a Max API
   ↓
6. Parse JSON → List<Product>
   ↓
7. ProductProvider actualiza _featuredProducts
   ↓
8. ProductProvider.notifyListeners()
   ↓
9. Consumer<ProductProvider> reconstruye UI
```

## 🎯 Principios de Diseño

### 1. Single Responsibility Principle (SRP)
- Cada clase tiene una única responsabilidad
- Services solo manejan API calls
- Providers solo manejan estado
- Screens solo manejan UI

### 2. Separation of Concerns
- UI separada de lógica de negocio
- Modelos separados de servicios
- Estado centralizado en Providers

### 3. DRY (Don't Repeat Yourself)
- Widgets reutilizables
- Funciones helper en modelos
- Constantes centralizadas (colores, URLs)

### 4. Dependency Injection
- Providers inyectados en el árbol de widgets
- Fácil testing y mock de dependencias

## 🧪 Testing Strategy

### Unit Tests
```dart
// Probar lógica de Providers
test('Add item to cart increases count', () {
  final cart = CartProvider();
  cart.addItem(mockProduct);
  expect(cart.itemCount, 1);
});
```

### Widget Tests
```dart
// Probar widgets individuales
testWidgets('Product card displays correctly', (tester) async {
  await tester.pumpWidget(ProductCard(product: mockProduct));
  expect(find.text(mockProduct.name), findsOneWidget);
});
```

### Integration Tests
```dart
// Probar flujos completos
testWidgets('User can add product to cart', (tester) async {
  // Navigate to product detail
  // Tap add to cart button
  // Verify cart count increased
});
```

## 🔐 Seguridad

### API Security
- API Key en constantes (mover a env en producción)
- HTTPS para todas las requests
- Validación de datos del servidor

### Data Privacy
- No almacenar datos sensibles en local
- Validar inputs de usuario
- Sanitizar datos antes de enviar

## 📊 Performance

### Optimizaciones Implementadas

1. **Imágenes**
   - CachedNetworkImage para caché automático
   - Placeholders durante carga
   - Error widgets para imágenes faltantes

2. **State Management**
   - Solo notifica cambios cuando es necesario
   - Consumer para actualizaciones granulares
   - Evita rebuilds innecesarios

3. **Lists**
   - ListView.builder para listas largas
   - GridView para productos
   - Lazy loading de imágenes

## 🚀 Escalabilidad

### Preparado para crecer

1. **Más Providers**
   - Fácil agregar nuevos providers
   - Estado modular y desacoplado

2. **Más Screens**
   - Navegación lista para más pantallas
   - Routing puede extenderse

3. **Más Features**
   - Arquitectura soporta nuevas funcionalidades
   - Providers pueden extenderse

## 🔄 State Management Flow

```dart
// Ejemplo de flujo completo
┌─────────────┐
│   Widget    │ ← Consumer escucha cambios
└──────┬──────┘
       │ context.read<Provider>().method()
       ↓
┌─────────────┐
│  Provider   │ ← ChangeNotifier
└──────┬──────┘
       │ notifyListeners()
       ↓
┌─────────────┐
│   Service   │ ← Llama API
└──────┬──────┘
       │ HTTP request
       ↓
┌─────────────┐
│  Max API    │ ← Servidor
└─────────────┘
```

## 📱 Navigation Flow

```
main.dart
    ↓
MainScreen (BottomNavBar)
    ├─→ HomeScreen
    │     └─→ ProductDetailScreen
    ├─→ CategoriesScreen
    │     └─→ (CategoryProductsScreen - futuro)
    ├─→ FavoritesScreen
    │     └─→ ProductDetailScreen
    ├─→ CartScreen
    │     └─→ CheckoutScreen (futuro)
    └─→ ProfileScreen
          ├─→ OrdersScreen (futuro)
          ├─→ AddressesScreen (futuro)
          └─→ SettingsScreen (futuro)
```

## 🎨 Theme System

```dart
AppTheme.lightTheme
    ├─→ AppColors (colores de Max)
    ├─→ TextTheme (estilos de texto)
    ├─→ ButtonTheme (estilos de botones)
    ├─→ InputDecorationTheme (inputs)
    └─→ CardTheme (tarjetas)
```

## 📦 Dependencies Management

```yaml
dependencies:
  flutter: SDK
  provider: ^6.1.1         # State management
  http: ^1.2.0             # API calls
  cached_network_image     # Image caching
  carousel_slider          # Carousels
  smooth_page_indicator    # Page dots
  font_awesome_flutter     # Icons
```

---

**Esta arquitectura permite**:
- ✅ Fácil mantenimiento
- ✅ Escalabilidad
- ✅ Testing efectivo
- ✅ Desarrollo en equipo
- ✅ Reutilización de código
