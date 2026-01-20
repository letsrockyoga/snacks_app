# Snacks de Movimiento App

Aplicación multiplataforma de temporizador inteligente de snacks de movimiento para teletrabajadores.

## Características

- 7 snacks diarios de 5 minutos cada uno
- Sistema dinámico 45-5 (45 min trabajo, 5 min snack)
- Notificaciones push
- Calendario de progreso
- Sistema de puntuación (10 puntos por snack)
- Sincronización en la nube con Firebase

## Requisitos

- Flutter 3.0+
- Dart 3.0+
- Firebase account

## Configuración

1. Instalar dependencias:
```bash
cd snacks_app
flutter pub get
```

2. Configurar Firebase:
   - Crear proyecto en Firebase Console
   - Descargar `google-services.json` (Android) y colocar en `android/app/`
   - Descargar `GoogleService-Info.plist` (iOS) y colocar en `ios/Runner/`

3. Ejecutar:
```bash
flutter run
```

## Estructura

```
lib/
├── main.dart                 # Entry point
├── models/
│   └── models.dart          # Data models
├── data/
│   └── snacks_data.dart     # Exercise definitions
├── services/
│   ├── timer_service.dart   # Timer logic
│   ├── notification_service.dart
│   └── data_service.dart    # Firebase sync
└── screens/
    ├── home_screen.dart     # Main screen
    ├── snack_screen.dart    # Exercise details
    └── calendar_screen.dart # Progress calendar
```

## Los 7 Snacks

1. **08:45** - Antebrazos Explosivos
2. **09:35** - Fuerza Superior
3. **10:25** - Fuerza Inferior
4. **12:20** - Core Intenso
5. **14:45** - Antebrazos 2.0
6. **15:35** - Fuerza Superior 2.0
7. **16:25** - Cardio HIIT

## Sistema de Puntuación

- Completado perfecto: 10 puntos
- Con dificultades: 7 puntos
- Incompleto: 3 puntos
- Bonus día completo (7/7): +5 puntos
- Máximo semanal: 385 puntos

## Build para Producción

### ✅ Android
```bash
flutter build apk --release
# APK en: build/app/outputs/flutter-apk/app-release.apk
```

### ✅ iOS
```bash
flutter build ios --release
# Requiere Xcode y certificados de Apple Developer
```

### ✅ Web
```bash
flutter build web --release
# Archivos en: build/web/
```

### ✅ Windows
```bash
flutter build windows --release
# Ejecutable en: build/windows/runner/Release/
```

### ✅ macOS
```bash
flutter build macos --release
# App en: build/macos/Build/Products/Release/
```

### ✅ Linux
```bash
flutter build linux --release
# Ejecutable en: build/linux/x64/release/bundle/
```

## Ejecutar en Plataformas Específicas

```bash
# Ver dispositivos disponibles
flutter devices

# Android
flutter run -d android

# iOS
flutter run -d ios

# Web (Chrome)
flutter run -d chrome

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```
