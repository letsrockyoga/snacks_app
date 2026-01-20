import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/models.dart';
import '../data/snacks_data.dart';

class ConfigService extends ChangeNotifier {
  List<Snack> _snacks = [];
  bool _isLoaded = false;

  List<Snack> get snacks => _snacks;
  bool get isLoaded => _isLoaded;

  ConfigService() {
    _init();
  }

  Future<void> _init() async {
    await loadSnacks();
  }

  Future<void> loadSnacks() async {
    try {
      final jsonString = await rootBundle.loadString('assets/config/snacks.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _snacks = jsonData.map((s) => Snack.fromJson(s)).toList();
      _isLoaded = true;
    } catch (e) {
      print('Error loading snacks config: $e');
      print('Using default snacks data');
      _snacks = SnacksData.snacks;
      _isLoaded = true;
    }
    notifyListeners();
  }

  Snack? getSnackById(int id) {
    try {
      return _snacks.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
