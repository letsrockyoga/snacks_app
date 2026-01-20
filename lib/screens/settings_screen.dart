import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/timer_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Consumer<TimerService>(
        builder: (context, timerService, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Intervalo entre Snacks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('${timerService.snackInterval} minutos'),
                subtitle: Slider(
                  value: timerService.snackInterval.toDouble(),
                  min: 15,
                  max: 90,
                  divisions: 15,
                  label: '${timerService.snackInterval} min',
                  onChanged: (value) {
                    timerService.setSnackInterval(value.toInt());
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
