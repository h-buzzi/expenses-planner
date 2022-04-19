import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserParams with ChangeNotifier {
  final String authToken;
  final String userId;
  double _userSalary = 0.0;
  double _foodVoucher = 0.0;
  double _mealVoucher = 0.0;
  String _userParamsId = '';
  Color _colorMode = Colors.grey.shade900;
  String _selectedThemeMode = 'night';

  UserParams({required this.authToken, required this.userId});

  Color get colorMode {
    return _colorMode;
  }

  double get userSalary {
    return _userSalary;
  }

  double get foodVoucher {
    return _foodVoucher;
  }

  double get mealVoucher {
    return _mealVoucher;
  }

  String get selectedThemeMode {
    return _selectedThemeMode;
  }

  set setColorMode(String mode) {
    if (mode == 'day') {
      _selectedThemeMode = mode;
      _colorMode = Colors.grey.shade50;
    } else if (mode == 'night') {
      _colorMode = Colors.grey.shade900;
      _selectedThemeMode = mode;
    }
    notifyListeners();
  }

  set setUserSalary(double userSettedSalary) {
    _userSalary = userSettedSalary;
    notifyListeners();
  }

  set setFoodVoucher(double userSettedFoodVoucher) {
    _foodVoucher = userSettedFoodVoucher;
    notifyListeners();
  }

  set setMealVoucher(double userSettedMealVoucher) {
    _mealVoucher = userSettedMealVoucher;
    notifyListeners();
  }

  Future<void> setUserParamsToServer(
      double _newUserSalary,
      double _newFoodVoucher,
      double _newMealVoucher,
      String _newSelectedThemeMode) async {
    final firebaseUrlUserParams = Uri.parse(
        'https://expenses-planner-hebgfk-default-rtdb.firebaseio.com/$userId/userparams/$_userParamsId.json?auth=$authToken');
    await http.patch(firebaseUrlUserParams,
        body: json.encode({
          'userSalary': _newUserSalary,
          'foodVoucher': _newFoodVoucher,
          'mealVoucher': _newMealVoucher,
          'selectedThemeMode': _newSelectedThemeMode
        }));
    _userSalary = _newUserSalary;
    _foodVoucher = _newFoodVoucher;
    _mealVoucher = _newMealVoucher;
    _selectedThemeMode = _newSelectedThemeMode;
    if (_newSelectedThemeMode == 'day') {
      _colorMode = Colors.grey.shade50;
    } else if (_newSelectedThemeMode == 'night') {
      _colorMode = Colors.grey.shade900;
    }
    notifyListeners();
  }

  Future<void> fetchUserParams() async {
    final firebaseUrlUserParams = Uri.parse(
        'https://expenses-planner-hebgfk-default-rtdb.firebaseio.com/$userId/userparams.json?auth=$authToken');
    final response = await http.get(firebaseUrlUserParams);
    if (json.decode(response.body) == null) {
      notifyListeners();
      return;
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      notifyListeners();
      return;
    }
    extractedData.forEach((paramsId, paramsData) {
      _userParamsId = paramsId;
      _userSalary = paramsData['userSalary'];
      _foodVoucher = paramsData['foodVoucher'];
      _mealVoucher = paramsData['mealVoucher'];
      if (paramsData['selectedThemeMode'] == 'day') {
        _selectedThemeMode = paramsData['selectedThemeMode'];
        _colorMode = Colors.grey.shade50;
      } else if (paramsData['selectedThemeMode'] == 'night') {
        _colorMode = Colors.grey.shade900;
        _selectedThemeMode = paramsData['selectedThemeMode'];
      }
      notifyListeners();
    });
  }
}
