import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notificación presionada: ${response.payload}');
      },
    );

    // Solicitar permisos en Android 13+
    await _requestPermissions();

    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> showSamsungWatchPromotion() async {
    await initialize();

    final androidDetails = AndroidNotificationDetails(
      'promotions_channel',
      'Promociones',
      channelDescription: 'Notificaciones de ofertas y promociones especiales',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      styleInformation: const BigTextStyleInformation(
        '¡Solo por hoy! Aprovecha esta oferta exclusiva en el reloj Samsung Galaxy Watch. No dejes pasar esta oportunidad única.',
        contentTitle: '🎉 ¡OFERTA FLASH! 15% OFF',
        summaryText: 'Descuento especial',
      ),
      color: const Color(0xFFFF6B6B), // Color llamativo rojo
      ledColor: const Color(0xFFFF6B6B),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      '🎉 ¡OFERTA FLASH! 15% OFF 🔥',
      '⌚ Reloj Samsung Galaxy Watch - ¡Solo por hoy! Descuento exclusivo',
      notificationDetails,
      payload: 'samsung_watch_promo',
    );
  }
}
