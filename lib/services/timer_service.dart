import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'notification_service.dart';
import 'config_service.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  DateTime? _lastSnackTime;
  int _currentSnackIndex = 0;
  int _remainingSeconds = 0;
  bool _isSnackActive = false;
  Snack? _currentSnack;
  int _currentExerciseIndex = 0;
  int _snackInterval = 45;
  bool _isPaused = false;
  DateTime? _pausedAt;
  ConfigService? _configService;

  int get currentSnackIndex => _currentSnackIndex;
  int get remainingSeconds => _remainingSeconds;
  bool get isSnackActive => _isSnackActive;
  Snack? get currentSnack => _currentSnack;
  int get currentExerciseIndex => _currentExerciseIndex;
  int get snackInterval => _snackInterval;
  bool get isPaused => _isPaused;

  void setConfigService(ConfigService configService) {
    _configService = configService;
  }
  
  DateTime? get nextSnackTime {
    if (_lastSnackTime == null) return _getInitialSnackTime();
    if (_isPaused && _pausedAt != null) {
      return _pausedAt;
    }
    return _lastSnackTime!.add(Duration(minutes: _snackInterval));
  }

  TimerService() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTime = prefs.getString('lastSnackTime');
    if (lastTime != null) {
      _lastSnackTime = DateTime.parse(lastTime);
    }
    _currentSnackIndex = prefs.getInt('currentSnackIndex') ?? 0;
    _snackInterval = prefs.getInt('snackInterval') ?? 45;
    _startCountdown();
  }

  DateTime _getInitialSnackTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 8, 45);
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPaused || _isSnackActive) return;
      
      final next = nextSnackTime;
      if (next == null) return;
      
      final diff = next.difference(DateTime.now()).inSeconds;
      if (diff <= 0 && !_isSnackActive) {
        _triggerSnack();
      }
      notifyListeners();
    });
  }

  void _triggerSnack() {
    if (_configService == null || _configService!.snacks.isEmpty) return;
    if (_currentSnackIndex >= _configService!.snacks.length) {
      _currentSnackIndex = 0;
    }
    _currentSnack = _configService!.snacks[_currentSnackIndex];
    NotificationService().showSnackNotification(_currentSnack!);
    notifyListeners();
  }

  void startSnack() {
    _isSnackActive = true;
    _currentExerciseIndex = 0;
    _remainingSeconds = _currentSnack!.duration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _updateCurrentExercise();
        notifyListeners();
      } else {
        _finishSnack();
      }
    });
    notifyListeners();
  }

  void _updateCurrentExercise() {
    if (_currentSnack == null) return;
    
    int elapsed = _currentSnack!.duration - _remainingSeconds;
    int accumulatedTime = 0;
    
    for (int i = 0; i < _currentSnack!.exercises.length; i++) {
      accumulatedTime += _currentSnack!.exercises[i].duration;
      if (elapsed < accumulatedTime) {
        _currentExerciseIndex = i;
        return;
      }
    }
  }

  void _finishSnack() async {
    _isSnackActive = false;
    _lastSnackTime = DateTime.now();
    _currentSnackIndex++;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSnackTime', _lastSnackTime!.toIso8601String());
    await prefs.setInt('currentSnackIndex', _currentSnackIndex);
    
    _currentSnack = null;
    _startCountdown();
    notifyListeners();
  }

  void postponeSnack() {
    _lastSnackTime = DateTime.now().subtract(Duration(minutes: _snackInterval - 10));
    _startCountdown();
    notifyListeners();
  }

  Future<void> setSnackInterval(int minutes) async {
    _snackInterval = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('snackInterval', minutes);
    notifyListeners();
  }

  void togglePause() {
    if (_isPaused) {
      // Resume
      final pausedDuration = _pausedAt!.difference(DateTime.now());
      _lastSnackTime = DateTime.now().add(pausedDuration).subtract(Duration(minutes: _snackInterval));
      _isPaused = false;
      _pausedAt = null;
    } else {
      // Pause
      _isPaused = true;
      _pausedAt = nextSnackTime;
    }
    notifyListeners();
  }

  void resetTimer() {
    _lastSnackTime = DateTime.now();
    _isPaused = false;
    _pausedAt = null;
    notifyListeners();
  }

  void triggerSnackNow() {
    _lastSnackTime = DateTime.now().subtract(Duration(minutes: _snackInterval));
    _isPaused = false;
    _pausedAt = null;
    _triggerSnack();
    notifyListeners();
  }

  String getTimeUntilNext() {
    final next = nextSnackTime;
    if (next == null) return '--:--';
    
    final diff = next.difference(DateTime.now());
    if (diff.isNegative) return '00:00';
    
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
