import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/expenses_class.dart';
import 'package:http/http.dart' as http;
import 'package:date_utils/date_utils.dart' as du;
import 'dart:convert';

class ExpensesList with ChangeNotifier {
  final List<Expenses> _expensesList = [];
  final String authToken;
  final String userId;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  bool _isLoading = false;
  bool _needsInit = true;
  String _filteredCategory = '';
  Map<String, double> _categoryExpense = {
    'mandatory': 0.0,
    'others': 0.0,
    'learning': 0.0,
    'leisure': 0.0,
    'meals': 0.0,
    'groceries': 0.0,
  };
  int _touchedIndex = -1;

  ExpensesList({required this.authToken, required this.userId});

  int get selectedMonth {
    return _selectedMonth;
  }

  int get selectedYear {
    return _selectedYear;
  }

  int numberOfDays() {
    return du.DateUtils.lastDayOfMonth(DateTime(_selectedYear, _selectedMonth))
        .day;
  }

  bool get needsInit {
    return _needsInit;
  }

  bool get isLoading {
    return _isLoading;
  }

  set setNeedsInit(bool newNeedsInitState) {
    _needsInit = false;
  }

  set setIsLoading(bool newIsLoadingState) {
    _isLoading = newIsLoadingState;
  }

  double get totalExpensesOfTheMonth {
    double totalExpenses = 0.0;
    _categoryExpense.forEach((key, value) {
      totalExpenses += value;
    });
    return totalExpenses;
  }

  double get allOtherCategoryExpensesOfTheMonth {
    if (_filteredCategory.isEmpty) {
      return (_categoryExpense['mandatory']! +
          _categoryExpense['leisure']! +
          _categoryExpense['learning']! +
          _categoryExpense['others']!);
    } else if (_filteredCategory != 'meals' &&
        _filteredCategory != 'groceries') {
      return _categoryExpense[_filteredCategory] as double;
    } else {
      return (_categoryExpense['mandatory']! +
          _categoryExpense['leisure']! +
          _categoryExpense['learning']! +
          _categoryExpense['others']!);
    }
  }

  double get mealsExpensesOfTheMonth {
    return _categoryExpense['meals']!;
  }

  double get groceriesExpensesOfTheMonth {
    return _categoryExpense['groceries']!;
  }

  Expenses findById(String id) {
    return _expensesList.firstWhere((expenses) => expenses.id == id);
  }

  List<Expenses> fetchExpensesFromDay(int day) {
    if (_filteredCategory.isEmpty) {
      return _expensesList.where((expenses) => expenses.day == day).toList();
    } else {
      return _expensesList
          .where((expenses) =>
              (expenses.day == day && expenses.category == _filteredCategory))
          .toList();
    }
  }

  double getDayPercentage(int day) {
    double totalCostOnThatDay = 0.0;
    if (_filteredCategory.isEmpty) {
      _expensesList
          .where((expense) => expense.day == day)
          .forEach((expensesOnThatDay) {
        totalCostOnThatDay += expensesOnThatDay.cost;
      });
    } else {
      _expensesList
          .where((expense) =>
              (expense.day == day && expense.category == _filteredCategory))
          .forEach((expensesOnThatDay) {
        totalCostOnThatDay += expensesOnThatDay.cost;
      });
    }
    if (totalCostOnThatDay == 0.0) {
      return 0.0;
    } else {
      return (totalCostOnThatDay / (totalExpensesOfTheMonth)) * 100;
    }
  }

  double getCategoryPercentage(String category) {
    return double.parse(
        ((_categoryExpense[category]! / totalExpensesOfTheMonth) * 100)
            .toStringAsFixed(2));
  }

  bool get isExpensesEmpty {
    return _expensesList.isEmpty;
  }

  //////////////////////////////////// SELECTING FILTER ////////////////////////////////////////////////////
  int get touchedIndex {
    return _touchedIndex;
  }

  String get filteredCategory {
    return _filteredCategory;
  }

  set setTouchedIndex(int touchedCircleIndex) {
    _touchedIndex = touchedCircleIndex;
    _filteredCategory = indexToCategory(touchedCircleIndex);
    notifyListeners();
  }

  String indexToCategory(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'mandatory';
      case 1:
        return 'learning';
      case 2:
        return 'leisure';
      case 3:
        return 'groceries';
      case 4:
        return 'meals';
      case 5:
        return 'others';
      default:
        return '';
    }
  }

  //////////////////////////////////// SERVER FUNCTIONS ////////////////////////////////////////////////////

  Future<void> addExpenseToList(
      Expenses addedExpense, DateTime expenseDate) async {
    final firebaseUrlExpenses = Uri.parse(
        'https://expenses-planner-hebgfk-default-rtdb.firebaseio.com/$userId/${expenseDate.year}/${expenseDate.month}.json?auth=$authToken');
    final response = await http.post(firebaseUrlExpenses,
        body: json.encode({
          'itemName': addedExpense.itemName,
          'descript': addedExpense.descript,
          'cost': addedExpense.cost,
          'category': addedExpense.category,
          'day': addedExpense.day,
        }));
    if (expenseDate.month == _selectedMonth &&
        expenseDate.year == _selectedYear) {
      _expensesList
          .add(addedExpense.copyWith(id: json.decode(response.body)['name']));
      _categoryExpense[addedExpense.category] =
          _categoryExpense[addedExpense.category]! + addedExpense.cost;
    }
    notifyListeners();
  }

  Future<void> updateExpense(
      Expenses updateExpense, DateTime expenseDate) async {
    final firebaseUrlExpenses = Uri.parse(
        'https://expenses-planner-hebgfk-default-rtdb.firebaseio.com/$userId/${expenseDate.year}/${expenseDate.month}/${updateExpense.id}.json?auth=$authToken');
    await http.patch(firebaseUrlExpenses,
        body: json.encode({
          'itemName': updateExpense.itemName,
          'descript': updateExpense.descript,
          'cost': updateExpense.cost,
          'category': updateExpense.category,
          'day': updateExpense.day,
        }));
    if (expenseDate.month == _selectedMonth &&
        expenseDate.year == _selectedYear) {
      final expensesIndex =
          _expensesList.indexWhere((exp) => exp.id == updateExpense.id);
      _categoryExpense[updateExpense.category] =
          _categoryExpense[updateExpense.category]! +
              updateExpense.cost -
              _expensesList[expensesIndex].cost;
      _expensesList[expensesIndex] = updateExpense;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetExpenses({int? selectedDate}) async {
    if (selectedDate == null) {
    } else if (selectedDate <= 12) {
      _selectedMonth = selectedDate;
      _isLoading = true;
      notifyListeners();
    } else {
      _selectedYear = selectedDate;
      _isLoading = true;
      notifyListeners();
    }
    _expensesList.clear();
    _categoryExpense = {
      'mandatory': 0.0,
      'others': 0.0,
      'learning': 0.0,
      'leisure': 0.0,
      'meals': 0.0,
      'groceries': 0.0,
    };
    final firebaseUrlOrders = Uri.parse(
        'https://expenses-planner-hebgfk-default-rtdb.firebaseio.com/$userId/$_selectedYear/$_selectedMonth.json?auth=$authToken');
    final response = await http.get(firebaseUrlOrders);
    if (json.decode(response.body) == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    extractedData.forEach((orderId, orderData) {
      _categoryExpense[orderData['category']] =
          _categoryExpense[orderData['category']]! + orderData['cost'];
      _expensesList.add(
        Expenses(
            id: orderId,
            itemName: orderData['itemName'],
            descript: orderData['descript'],
            cost: double.parse(orderData['cost'].toString()),
            category: orderData['category'],
            day: orderData['day']),
      );
    });
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    final url = Uri.parse(
        'https://expenses-planner-hebgfk-default-rtdb.firebaseio.com/$userId/$_selectedYear/$_selectedMonth/$id.json?auth=$authToken');
    final existingExpenseIndex =
        _expensesList.indexWhere((exp) => exp.id == id);
    Expenses? existingExpense = _expensesList[existingExpenseIndex];
    _expensesList.removeAt(existingExpenseIndex);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _expensesList.insert(existingExpenseIndex, existingExpense);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    _categoryExpense[existingExpense.category] =
        _categoryExpense[existingExpense.category]! - existingExpense.cost;
    notifyListeners();
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
