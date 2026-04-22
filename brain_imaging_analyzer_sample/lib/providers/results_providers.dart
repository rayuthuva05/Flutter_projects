import 'package:flutter/material.dart';

class ResultsProviders extends ChangeNotifier{
  final List<Map<String, dynamic>> _results = [];

  List<Map<String, dynamic>> get results => _results;

  void addResult(Map<String, dynamic> data) {
    _results.add(data);
    notifyListeners();
  }
}