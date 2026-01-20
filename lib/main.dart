import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/timer_service.dart';
import 'services/notification_service.dart';
import 'services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('es', null);
  
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    firebaseInitialized = true;
  } catch (e) {
    print('Firebase initialization failed: $e');
    print('Running without Firebase sync');
  }
  
  await NotificationService().init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerService()),
        ChangeNotifierProvider(create: (_) => DataService()),
      ],
      child: const SnacksApp(),
    ),
  );
}

class SnacksApp extends StatelessWidget {
  const SnacksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snacks de Movimiento',
      theme: ThemeData(
        primaryColor: const Color(0xFF32B8C6),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF32B8C6),
          secondary: const Color(0xFFD4AF37),
          background: const Color(0xFFFFFFFF),
          surface: const Color(0xFFF8F8F8),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFF8F8F8),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        dividerColor: const Color(0xFFE0E0E0),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF000000)),
          bodyMedium: TextStyle(color: Color(0xFF000000)),
          bodySmall: TextStyle(color: Color(0xFF000000)),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
