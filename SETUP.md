# Snacks App - Guía de Configuración

## Paso 1: Instalar Flutter

Si no tienes Flutter instalado:
```bash
# Linux/macOS
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verificar instalación
flutter doctor
```

## Paso 2: Configurar Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto llamado "snacks-app"
3. Habilita Firestore Database
4. Habilita Authentication (Email/Password)

### Para Android:
1. Añade una app Android con package name: `com.example.snacks_app`
2. Descarga `google-services.json`
3. Colócalo en `android/app/google-services.json`

### Para iOS:
1. Añade una app iOS con bundle ID: `com.example.snacksApp`
2. Descarga `GoogleService-Info.plist`
3. Colócalo en `ios/Runner/GoogleService-Info.plist`

### Para Web/Desktop:
1. Añade las apps correspondientes en Firebase
2. Copia las credenciales a `lib/firebase_options.dart`

## Paso 3: Instalar Dependencias

```bash
cd snacks_app
flutter pub get
```

## Paso 4: Ejecutar la App

### Android/iOS (con dispositivo conectado o emulador):
```bash
flutter run
```

### Web:
```bash
flutter run -d chrome
```

### Desktop:
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## Paso 5: Configurar Notificaciones

### Android:
Las notificaciones funcionarán automáticamente con los permisos en AndroidManifest.xml

### iOS:
1. Abre `ios/Runner.xcworkspace` en Xcode
2. Ve a Signing & Capabilities
3. Añade "Push Notifications" capability
4. Añade "Background Modes" y marca "Background fetch" y "Remote notifications"

## Estructura de Firestore

La app creará automáticamente estas colecciones:

```
sessions/
  {sessionId}/
    - userId: string
    - date: timestamp
    - snackNumber: number
    - snackName: string
    - completed: boolean
    - effortLevel: string
    - points: number
```

## Reglas de Seguridad de Firestore

En Firebase Console > Firestore > Rules, usa:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /sessions/{sessionId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Troubleshooting

### Error: "Firebase not initialized"
- Verifica que `google-services.json` esté en la ubicación correcta
- Ejecuta `flutter clean` y `flutter pub get`

### Notificaciones no funcionan
- Android: Verifica permisos en AndroidManifest.xml
- iOS: Verifica capabilities en Xcode

### Error de compilación Android
- Verifica que `minSdk` sea al menos 24
- Ejecuta `cd android && ./gradlew clean`

## Próximos Pasos

1. Personaliza los colores en `lib/main.dart`
2. Añade más ejercicios en `lib/data/snacks_data.dart`
3. Configura horarios personalizados
4. Implementa autenticación de usuarios
