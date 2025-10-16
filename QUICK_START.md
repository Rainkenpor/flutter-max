# Guía de Inicio Rápido - Max Marketplace

## 🚀 Ejecutar la Aplicación

### Opción 1: Usando VS Code

1. Abrir el proyecto en VS Code
2. Conectar un dispositivo Android/iOS o iniciar un emulador
3. Presionar `F5` o ir a `Run > Start Debugging`

### Opción 2: Usando Terminal

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release (más rápido)
flutter run --release

# Ejecutar en un dispositivo específico
flutter run -d <device-id>
```

## 📱 Dispositivos Soportados

- **Android**: Mínimo API 21 (Android 5.0)
- **iOS**: Mínimo iOS 12.0
- **Web**: Chrome, Firefox, Safari
- **Windows**: Windows 10+
- **macOS**: macOS 10.14+
- **Linux**: Ubuntu 20.04+

## 🔍 Verificación del Sistema

```bash
# Verificar instalación de Flutter
flutter doctor

# Verificar que no haya problemas
flutter doctor -v
```

## 🐛 Solución de Problemas Comunes

### Problema: "No devices available"
**Solución**: 
- Android: Iniciar Android Studio > AVD Manager > Iniciar emulador
- iOS: Xcode > Open Developer Tool > Simulator
- Web: `flutter run -d chrome`

### Problema: "Gradle build failed"
**Solución**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problema: "CocoaPods not installed" (iOS)
**Solución**:
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Problema: Errores de dependencias
**Solución**:
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## 🎯 Navegación en la App

### Pantallas Principales

1. **Home** (🏠)
   - Ver banner de promociones
   - Explorar marcas
   - Ver ofertas del día
   - Productos destacados

2. **Categorías** (📂)
   - Explorar todas las categorías
   - Click en categoría para ver productos

3. **Favoritos** (❤️)
   - Ver productos guardados
   - Click en corazón para agregar/remover

4. **Carrito** (🛒)
   - Ver productos agregados
   - Ajustar cantidades
   - Aplicar códigos promo
   - Ver resumen de compra

5. **Perfil** (👤)
   - Información de usuario
   - Max Loyalty (próximamente)
   - Configuración

### Flujo de Compra

1. **Buscar/Explorar producto**
   - Home → Productos destacados
   - Categorías → Seleccionar categoría
   
2. **Ver detalle**
   - Click en producto
   - Ver imágenes, descripción
   - Seleccionar talla y color
   
3. **Agregar al carrito**
   - Click en botón "Men's Shoes"
   - Ver confirmación

4. **Checkout**
   - Ir a carrito
   - Aplicar código promo (opcional)
   - Click en "Checkout"

## 📊 Datos de Prueba

### Códigos Promocionales
- `max10` → 10% descuento
- `max20` → 20% descuento

### IDs de Productos de Prueba
```dart
// Productos destacados
SML705FDA, SML300NZE, BAND10PURP, WATCHGT5B, WATCHGT4V, SML320NZS

// Productos en oferta
WATCHFIT4B, MIWATCH5B, MIWATCH5P, WATCHFIT4PROB, MX4M3LZA, WATCHFIT4M
```

## 🔄 Hot Reload

Durante el desarrollo, puedes usar Hot Reload para ver cambios instantáneamente:

- **Presiona `r`** en la terminal donde corre la app
- **VS Code**: Presiona `Ctrl+F5` o el botón de Hot Reload
- Solo funciona en modo debug

## 📦 Build para Producción

### Android APK
```bash
flutter build apk --release
# APK en: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Para Play Store)
```bash
flutter build appbundle --release
# Bundle en: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
# Luego abrir ios/Runner.xcworkspace en Xcode para archivar
```

## 🛠️ Desarrollo

### Estructura de Archivos a Conocer

```
lib/
├── main.dart                  # Punto de entrada
├── core/theme/               # Colores y tema
├── models/                   # Modelos de datos
├── providers/                # Estado global
├── screens/                  # Pantallas
├── services/api_service.dart # Llamadas API
└── widgets/                  # Componentes reutilizables
```

### Hacer Cambios

1. **Cambiar colores**: `lib/core/theme/app_colors.dart`
2. **Modificar API**: `lib/services/api_service.dart`
3. **Agregar pantalla**: `lib/screens/`
4. **Crear widget**: `lib/widgets/`

### State Management

La app usa Provider para el estado:
- `CartProvider` → Carrito de compras
- `FavoritesProvider` → Favoritos
- `ProductProvider` → Productos y categorías

## 📝 Logs y Debug

```bash
# Ver logs en tiempo real
flutter logs

# Ver logs de un dispositivo específico
flutter logs -d <device-id>
```

## 🔐 Configuración API

Las credenciales de API están en:
`lib/services/api_service.dart`

```dart
static const String baseUrl = 'https://apigt.tienda.max.com.gt';
static const String apiKey = 'ROGi1LWB3saRqFw4Xdqc4Z9jGWVxYLl9ZEZjbJu9';
```

## 📞 Soporte

Para problemas técnicos:
1. Verificar logs: `flutter logs`
2. Verificar doctor: `flutter doctor`
3. Limpiar proyecto: `flutter clean && flutter pub get`
4. Reiniciar IDE y emulador

---

**¡Listo para desarrollar! 🚀**
