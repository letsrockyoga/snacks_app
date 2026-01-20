import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/models.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      const linux = LinuxInitializationSettings(defaultActionName: 'Open');
      const settings = InitializationSettings(android: android, iOS: ios, linux: linux);
      
      await _notifications.initialize(settings);
    } catch (e) {
      print('Notification init failed: $e');
    }
  }

  Future<void> showSnackNotification(Snack snack) async {
    try {
      const android = AndroidNotificationDetails(
        'snacks_channel',
        'Snacks de Movimiento',
        channelDescription: 'Notificaciones de snacks',
        importance: Importance.high,
        priority: Priority.high,
      );
      const ios = DarwinNotificationDetails();
      const linux = LinuxNotificationDetails();
      const details = NotificationDetails(android: android, iOS: ios, linux: linux);

      await _notifications.show(
        snack.id,
        '¡Hora del Snack ${snack.id}!',
        '${snack.name} - ${snack.duration ~/ 60} minutos',
        details,
      );
    } catch (e) {
      print('Show notification failed: $e');
    }
  }
}
