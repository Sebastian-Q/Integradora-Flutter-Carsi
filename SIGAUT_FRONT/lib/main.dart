import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/utils/Notificacion_service.dart';
import 'package:sigaut_frontend/features/others/view/splash_screen.dart';

/// 📌 Handler global para mensajes en background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationService.showLocalNotification(
    title: message.notification?.title,
    body: message.notification?.body,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Registrar handler de background ANTES de runApp
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Inicializar notificaciones locales (como WhatsApp)
  await NotificationService.initializeLocalNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = '/home';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
