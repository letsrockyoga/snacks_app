import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/timer_service.dart';
import '../services/data_service.dart';

class SnackScreen extends StatefulWidget {
  final Snack snack;

  const SnackScreen({super.key, required this.snack});

  @override
  State<SnackScreen> createState() => _SnackScreenState();
}

class _SnackScreenState extends State<SnackScreen> {
  final ScrollController _scrollController = ScrollController();
  int _lastExerciseIndex = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentExercise(int currentIndex) {
    if (currentIndex != _lastExerciseIndex && _scrollController.hasClients) {
      _lastExerciseIndex = currentIndex;
      final position = currentIndex * 400.0; // Approximate card height
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snack.name),
      ),
      body: Consumer<TimerService>(
        builder: (context, timerService, _) {
          final minutes = timerService.remainingSeconds ~/ 60;
          final seconds = timerService.remainingSeconds % 60;

          if (timerService.isSnackActive) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToCurrentExercise(timerService.currentExerciseIndex);
            });
          }

          return Column(
            children: [
              Container(
                color: const Color(0xFF32B8C6),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      widget.snack.objective,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.snack.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = widget.snack.exercises[index];
                    final isCurrent = timerService.isSnackActive && 
                                     timerService.currentExerciseIndex == index;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: isCurrent ? const Color(0xFFF8F8F8) : null,
                      elevation: isCurrent ? 8 : 1,
                      child: Container(
                        decoration: isCurrent ? BoxDecoration(
                          border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                          borderRadius: BorderRadius.circular(12),
                        ) : null,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (isCurrent)
                                    const Icon(Icons.play_circle, color: Color(0xFFD4AF37), size: 24),
                                  if (isCurrent)
                                    const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${index + 1}. ${exercise.name}',
                                      style: TextStyle(
                                        fontSize: 18, 
                                        fontWeight: isCurrent ? FontWeight.w900 : FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '⏱️ ${exercise.duration} segundos',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              if (exercise.gifUrl != null) ...[
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    exercise.gifUrl!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        color: const Color(0xFFF8F8F8),
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported, size: 48, color: Colors.black26),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              _buildSection('Descripción', exercise.description),
                              _buildSection('Posición Inicial', exercise.initialPosition),
                              _buildSection('Movimiento', exercise.movement),
                              _buildSection('Lo que debes sentir', exercise.whatToFeel),
                              if (exercise.errorsToAvoid.isNotEmpty)
                                _buildErrorsList(exercise.errorsToAvoid),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (timerService.remainingSeconds == 0)
                _buildCompletionButtons(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildErrorsList(List<String> errors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚠️ Errores a evitar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
          ),
          const SizedBox(height: 4),
          ...errors.map((error) => Padding(
            padding: const EdgeInsets.only(left: 8, top: 2),
            child: Text('• $error', style: const TextStyle(fontSize: 13)),
          )),
        ],
      ),
    );
  }

  Widget _buildCompletionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('¿Cómo te fue?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEffortButton(context, '🟢', 'Perfecto', 'perfecto'),
              _buildEffortButton(context, '🟡', 'Con dificultad', 'dificultades'),
              _buildEffortButton(context, '🔴', 'Incompleto', 'incompleto'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffortButton(BuildContext context, String emoji, String label, String level) {
    return ElevatedButton(
      onPressed: () async {
        await context.read<DataService>().completeSnack(widget.snack.id, widget.snack.name, level);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
