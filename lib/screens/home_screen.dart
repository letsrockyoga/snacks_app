import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/timer_service.dart';
import '../services/data_service.dart';
import 'snack_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snacks de Movimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            ),
          ),
        ],
      ),
      body: Consumer2<TimerService, DataService>(
        builder: (context, timerService, dataService, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPointsCard(dataService),
                  const SizedBox(height: 24),
                  if (!timerService.isSnackActive)
                    _buildNextSnackCard(timerService),
                  if (!timerService.isSnackActive)
                    const SizedBox(height: 24),
                  if (timerService.currentSnack != null && !timerService.isSnackActive)
                    _buildSnackAlert(timerService),
                  if (timerService.isSnackActive)
                    _buildActiveSnack(timerService),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsCard(DataService dataService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat('Puntos Hoy', '${dataService.todayPoints}', Colors.green),
            _buildStat('Racha', '${dataService.streak} días', Colors.orange),
            _buildStat('Snacks', '${dataService.sessions.length}/7', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildNextSnackCard(TimerService timerService) {
    final isDisabled = timerService.isSnackActive;
    
    return Card(
      color: const Color(0xFFF8F8F8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Próximo Snack', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 8),
            Text(
              timerService.getTimeUntilNext(),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF32B8C6)),
            ),
            const SizedBox(height: 8),
            Text(
              'Snack ${timerService.currentSnackIndex + 1}/7',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: isDisabled ? null : () => timerService.togglePause(),
                  icon: Icon(timerService.isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(timerService.isPaused ? 'Reanudar' : 'Pausar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32B8C6),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isDisabled ? null : () => timerService.resetTimer(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32B8C6),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: isDisabled ? null : () => timerService.triggerSnackNow(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDisabled ? null : const Color(0xFFD4AF37),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Snack YA!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnackAlert(TimerService timerService) {
    final snack = timerService.currentSnack!;
    return Card(
      color: const Color(0xFFF8F8F8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD4AF37), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '¡Hora del Snack ${snack.id}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
            ),
            const SizedBox(height: 8),
            Text(snack.name, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    timerService.startSnack();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SnackScreen(snack: snack)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Iniciar'),
                ),
                OutlinedButton(
                  onPressed: () => timerService.postponeSnack(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF32B8C6)),
                    foregroundColor: const Color(0xFF32B8C6),
                  ),
                  child: const Text('Posponer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSnack(TimerService timerService) {
    final minutes = timerService.remainingSeconds ~/ 60;
    final seconds = timerService.remainingSeconds % 60;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SnackScreen(snack: timerService.currentSnack!)),
        );
      },
      child: Card(
        color: const Color(0xFFF8F8F8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF32B8C6), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('Snack en Progreso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF32B8C6)),
              ),
              const SizedBox(height: 8),
              const Text('Toca para ver detalles', style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
