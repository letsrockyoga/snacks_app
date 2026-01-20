import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';

class DataService extends ChangeNotifier {
  FirebaseFirestore? _firestore;
  List<Session> _sessions = [];
  int _todayPoints = 0;
  int _streak = 0;

  List<Session> get sessions => _sessions;
  int get todayPoints => _todayPoints;
  int get streak => _streak;

  DataService() {
    _init();
  }

  Future<void> _init() async {
    await loadTodaySessions();
    await _calculateStreak();
  }

  Future<void> loadTodaySessions() async {
    try {
      _firestore = Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null;
      
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? 'local';
      
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      // Load from local storage first
      final localData = prefs.getString('sessions_$userId') ?? '[]';
      final List<dynamic> localJson = json.decode(localData);
      _sessions = localJson.map((s) => Session.fromJson(s)).where((s) {
        return s.date.isAfter(startOfDay.subtract(const Duration(days: 1)));
      }).toList();
      
      // Try to sync with Firebase if available
      if (_firestore != null) {
        try {
          final snapshot = await _firestore!
              .collection('sessions')
              .where('userId', isEqualTo: userId)
              .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
              .get();
          
          final firebaseSessions = snapshot.docs.map((doc) => Session.fromJson(doc.data())).toList();
          
          // Merge with local sessions
          for (var fbSession in firebaseSessions) {
            if (!_sessions.any((s) => s.id == fbSession.id)) {
              _sessions.add(fbSession);
            }
          }
        } catch (e) {
          print('Firebase sync failed: $e');
        }
      }
      
      _calculateTodayPoints();
      notifyListeners();
    } catch (e) {
      print('Load sessions failed: $e');
      _sessions = [];
    }
  }

  void _calculateTodayPoints() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    _todayPoints = _sessions
        .where((s) => s.completed && s.date.isAfter(startOfDay))
        .fold(0, (sum, s) => sum + s.points);
  }

  Future<void> _calculateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? 'local';
    
    final localData = prefs.getString('sessions_$userId') ?? '[]';
    final List<dynamic> localJson = json.decode(localData);
    final allSessions = localJson.map((s) => Session.fromJson(s)).toList();
    
    if (allSessions.isEmpty) {
      _streak = 0;
      return;
    }
    
    // Group by day and check if day had at least 1 completed snack
    final Map<String, bool> dailyCompletion = {};
    for (var session in allSessions) {
      if (session.completed) {
        final dayKey = '${session.date.year}-${session.date.month}-${session.date.day}';
        dailyCompletion[dayKey] = true;
      }
    }
    
    // Count consecutive days from today backwards
    _streak = 0;
    final today = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final checkDay = today.subtract(Duration(days: i));
      final dayKey = '${checkDay.year}-${checkDay.month}-${checkDay.day}';
      if (dailyCompletion[dayKey] == true) {
        _streak++;
      } else if (i > 0) {
        break;
      }
    }
    
    notifyListeners();
  }

  Future<void> saveSession(Session session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? 'local';
      
      // Save to local storage
      final localData = prefs.getString('sessions_$userId') ?? '[]';
      final List<dynamic> localJson = json.decode(localData);
      localJson.add(session.toJson());
      await prefs.setString('sessions_$userId', json.encode(localJson));
      
      // Try to save to Firebase
      if (_firestore != null) {
        try {
          await _firestore!.collection('sessions').doc(session.id).set(session.toJson());
        } catch (e) {
          print('Firebase save failed: $e');
        }
      }
      
      _sessions.add(session);
      _calculateTodayPoints();
      await _calculateStreak();
      notifyListeners();
    } catch (e) {
      print('Save session failed: $e');
    }
  }

  Future<void> completeSnack(int snackNumber, String snackName, String effortLevel) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? 'local';
    
    int points = 10;
    if (effortLevel == 'perfecto') points = 10;
    else if (effortLevel == 'dificultades') points = 7;
    else points = 3;

    final session = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      date: DateTime.now(),
      snackNumber: snackNumber,
      snackName: snackName,
      startTime: DateTime.now().subtract(const Duration(minutes: 5)),
      endTime: DateTime.now(),
      completed: true,
      effortLevel: effortLevel,
      points: points,
    );

    await saveSession(session);
  }

  Future<Map<DateTime, int>> getMonthlyData(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? 'local';
    
    final localData = prefs.getString('sessions_$userId') ?? '[]';
    final List<dynamic> localJson = json.decode(localData);
    final allSessions = localJson.map((s) => Session.fromJson(s)).toList();
    
    final monthSessions = allSessions.where((s) => 
      s.date.year == year && s.date.month == month && s.completed
    ).toList();

    final Map<DateTime, int> dailyPoints = {};
    for (var session in monthSessions) {
      final day = DateTime(session.date.year, session.date.month, session.date.day);
      dailyPoints[day] = (dailyPoints[day] ?? 0) + session.points;
    }
    return dailyPoints;
  }
}
