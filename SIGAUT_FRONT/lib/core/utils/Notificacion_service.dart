import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();

  /// --------------------------------------------------------
  /// 🔔 Inicializa las notificaciones locales
  /// --------------------------------------------------------
  static Future<void> initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _local.initialize(settings);

    _foregroundListener();
  }

  /// --------------------------------------------------------
  /// 📩 Listener de mensajes cuando app está abierta
  /// --------------------------------------------------------
  static void _foregroundListener() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("📩 Notificación en FOREGROUND");

      showLocalNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });
  }

  /// --------------------------------------------------------
  /// 🔔 Mostrar notificación local (como WhatsApp)
  /// --------------------------------------------------------
  static Future<void> showLocalNotification({
    required String? title,
    required String? body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sigaut_channel',
      'SIGAUT Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // ID ÚNICO
      title,
      body,
      platformDetails,
    );
  }
}
