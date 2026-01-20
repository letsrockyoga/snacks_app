# Configuración de Snacks

Este archivo permite configurar los snacks y ejercicios sin necesidad de recompilar la aplicación.

## Ubicación
`assets/config/snacks.json`

## Estructura

```json
[
  {
    "id": 1,
    "name": "NOMBRE DEL SNACK",
    "time": "08:45",
    "duration": 165,
    "objective": "Objetivo del snack",
    "exercises": [
      {
        "name": "Nombre del ejercicio",
        "duration": 60,
        "description": "Descripción breve",
        "initialPosition": "Posición inicial",
        "movement": "Cómo realizar el movimiento",
        "whatToFeel": "Qué debes sentir",
        "errorsToAvoid": ["Error 1", "Error 2"],
        "gifUrl": "assets/gifs/ejercicio.gif"
      }
    ]
  }
]
```

## Campos

### Snack
- **id**: Número único del snack (1-7)
- **name**: Nombre del snack (mayúsculas)
- **time**: Hora sugerida en formato "HH:MM"
- **duration**: Duración total en segundos (debe coincidir con la suma de duraciones de ejercicios)
- **objective**: Objetivo del snack
- **exercises**: Array de ejercicios

### Exercise
- **name**: Nombre del ejercicio
- **duration**: Duración en segundos
- **description**: Descripción breve del ejercicio
- **initialPosition**: Descripción de la posición inicial
- **movement**: Instrucciones del movimiento
- **whatToFeel**: Qué sensación debe tener el usuario
- **errorsToAvoid**: Array de errores comunes a evitar
- **gifUrl**: (Opcional) Ruta al GIF animado del ejercicio

## Agregar GIFs

1. Coloca los archivos GIF en `assets/gifs/`
2. Referencia el archivo en el campo `gifUrl` del ejercicio: `"assets/gifs/nombre_ejercicio.gif"`
3. Si no hay GIF disponible, omite el campo `gifUrl` o déjalo como `null`

## Modificar la configuración

1. Edita el archivo `assets/config/snacks.json`
2. Asegúrate de que el JSON sea válido
3. Verifica que la duración total del snack coincida con la suma de duraciones de ejercicios
4. Reinicia la aplicación para cargar los cambios

## Ejemplo de modificación

Para cambiar la duración de un ejercicio:

```json
{
  "name": "Flexiones Estándar",
  "duration": 90,  // Cambiado de 60 a 90 segundos
  ...
}
```

Recuerda actualizar también el campo `duration` del snack padre.

## Validación

La aplicación cargará los valores por defecto si:
- El archivo JSON no existe
- El JSON tiene errores de sintaxis
- Faltan campos requeridos

Los errores se mostrarán en la consola de debug.
