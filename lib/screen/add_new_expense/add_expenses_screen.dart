import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/expenses_class.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:my_expenses_planner/screen/add_new_expense/widget/category_button.dart';
import 'package:provider/provider.dart';

class AddNewExpenseScreen extends StatefulWidget {
  static const routeName = '/add-edit-product-screen';
  @override
  State<AddNewExpenseScreen> createState() => _AddNewExpenseScreenState();
}

class _AddNewExpenseScreenState extends State<AddNewExpenseScreen> {
  //Initialization of parameters
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;
  bool _initializedDate = false;
  String appBarTitle = 'Adding a new Expense';
  DateTime _selectedDate = DateTime(1);
  Expenses _expense =
      Expenses(id: '', itemName: '', cost: 0.0, day: 0, category: '');

  //Initital check for existing or new product
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final expensesIdOrDate =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final expensesId = expensesIdOrDate['id'] as String;
      final selectedDay = expensesIdOrDate['day'] as int;
      final _definedTime = Provider.of<ExpensesList>(context, listen: false);
      if (expensesId.isNotEmpty) {
        appBarTitle = 'Editing an Expense';
        _expense = Provider.of<ExpensesList>(context, listen: false)
            .findById(expensesId);
        _selectedDate = DateTime(_definedTime.selectedYear,
            _definedTime.selectedMonth, _expense.day);
        setState(() {
          _initializedDate = true;
        });
      } else if (selectedDay != -1) {
        _selectedDate = DateTime(
            _definedTime.selectedYear, _definedTime.selectedMonth, selectedDay);
        _expense = _expense.copyWith(day: selectedDay);
        setState(() {
          _initializedDate = true;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  // ShowingDatePicker and Handling it
  void _datePicker() {
    final _definedTime = Provider.of<ExpensesList>(context, listen: false);
    showDatePicker(
        context: context,
        initialDate: DateTime(
            _definedTime.selectedYear,
            _definedTime.selectedMonth,
            DateTime.now().month == _definedTime.selectedMonth
                ? DateTime.now().day
                : 1),
        firstDate: DateTime(2010),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Theme.of(context).canvasColor,
                    onSurface: Theme.of(context).primaryColor),
                dialogBackgroundColor: Theme.of(context).canvasColor),
            child: child as Widget,
          );
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
        _expense = _expense.copyWith(day: _selectedDate.day);
      }
    });
  }

  void _saveData() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _selectedDate == DateTime(1) || _expense.category.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
    if (_expense.id.isNotEmpty) {
      await Provider.of<ExpensesList>(context, listen: false)
          .updateExpense(_expense, _selectedDate);
    } else {
      try {
        await Provider.of<ExpensesList>(context, listen: false)
            .addExpenseToList(_expense, _selectedDate);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _selectCategory(String _category) {
    setState(() {
      _expense = _expense.copyWith(category: _category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final InputDecoration _textFieldDecor = InputDecoration(
      labelText: '',
      fillColor: Theme.of(context).primaryColor,
      filled: true,
      labelStyle: TextStyle(
        color: Theme.of(context).canvasColor,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorStyle: const TextStyle(color: Colors.red),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultPadding)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultPadding),
        borderSide: BorderSide(
            width: 2, color: Theme.of(context).colorScheme.secondary),
      ),
    );
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                appBarTitle,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).canvasColor),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).canvasColor,
            ),
            body: Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                appBarTitle,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).canvasColor),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).canvasColor,
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'addNewExpense',
              backgroundColor: Theme.of(context).primaryColorDark,
              child: Icon(
                Icons.save,
                color: Theme.of(context).canvasColor,
              ),
              onPressed: _saveData,
            ),
            body: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Expense name
                      TextFormField(
                        decoration: _textFieldDecor.copyWith(labelText: 'Name'),
                        textInputAction: TextInputAction.next,
                        initialValue: _expense.itemName,
                        onFieldSubmitted: (enteredValue) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (enteredTitle) {
                          _expense = _expense.copyWith(itemName: enteredTitle);
                        },
                        validator: (enteredValue) {
                          if (enteredValue!.isEmpty) {
                            return 'Please enter a name for your expense!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      //Decription
                      TextFormField(
                        decoration:
                            _textFieldDecor.copyWith(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        focusNode: _descriptionFocusNode,
                        initialValue: _expense.descript,
                        maxLines: 3,
                        onFieldSubmitted: (enteredValue) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (enteredValue) {
                          _expense = _expense.copyWith(descript: enteredValue);
                        },
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),

                      TextFormField(
                        decoration:
                            _textFieldDecor.copyWith(labelText: 'Price'),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        initialValue: _expense.id.isEmpty
                            ? null
                            : _expense.cost.toStringAsFixed(2),
                        onSaved: (enteredValue) {
                          _expense = _expense.copyWith(
                              cost: double.parse(enteredValue!));
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price!';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero!';
                          }
                        },
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CategoryButton(
                                  category: 'mandatory',
                                  colorCategory: _expense.category ==
                                          'mandatory'
                                      ? _expense.returnCategoryColor(context)
                                      : Theme.of(context).colorScheme.tertiary,
                                  submitCategory: _selectCategory),
                              const SizedBox(
                                width: defaultPadding / 2,
                              ),
                              CategoryButton(
                                  category: 'others',
                                  colorCategory: _expense.category == 'others'
                                      ? _expense.returnCategoryColor(context)
                                      : Theme.of(context).colorScheme.tertiary,
                                  submitCategory: _selectCategory),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CategoryButton(
                                  category: 'learning',
                                  colorCategory: _expense.category == 'learning'
                                      ? _expense.returnCategoryColor(context)
                                      : Theme.of(context).colorScheme.tertiary,
                                  submitCategory: _selectCategory),
                              const SizedBox(
                                width: defaultPadding / 2,
                              ),
                              CategoryButton(
                                  category: 'leisure',
                                  colorCategory: _expense.category == 'leisure'
                                      ? _expense.returnCategoryColor(context)
                                      : Theme.of(context).colorScheme.tertiary,
                                  submitCategory: _selectCategory),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CategoryButton(
                                  category: 'meals',
                                  colorCategory: _expense.category == 'meals'
                                      ? _expense.returnCategoryColor(context)
                                      : Theme.of(context).colorScheme.tertiary,
                                  submitCategory: _selectCategory),
                              const SizedBox(
                                width: defaultPadding / 2,
                              ),
                              CategoryButton(
                                  category: 'groceries',
                                  colorCategory: _expense.category ==
                                          'groceries'
                                      ? _expense.returnCategoryColor(context)
                                      : Theme.of(context).colorScheme.tertiary,
                                  submitCategory: _selectCategory),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(defaultPadding) * 0.5,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(defaultPadding * 0.25)),
                                color: Theme.of(context).canvasColor,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor)),
                            child: Text(
                              _selectedDate == DateTime(1)
                                  ? 'Please Choose a Date!'
                                  : DateFormat('d/M/y').format(_selectedDate),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          if (!_initializedDate)
                            OutlinedButton(
                              onPressed: _datePicker,
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              child: Text(
                                'Choose Date',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
