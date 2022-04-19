import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';

class TextFormUserParamsConstructor extends StatelessWidget {
  const TextFormUserParamsConstructor({
    required financeCategory,
    required setFinanceFunction,
    required initialValue,
    Key? key,
  })  : _financeCategory = financeCategory,
        _setFinanceWithValue = setFinanceFunction,
        _initialValue = initialValue,
        super(key: key);
  final String _financeCategory;
  final Function _setFinanceWithValue;
  final String _initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.none,
      keyboardType: TextInputType.number,
      initialValue: _initialValue,
      style: TextStyle(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        errorMaxLines: 3,
        fillColor: Theme.of(context).canvasColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultPadding)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultPadding),
          borderSide: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      onSaved: (enteredValue) {
        _setFinanceWithValue(
            _financeCategory,
            double.parse(
                (double.parse(enteredValue as String)).toStringAsFixed(2)));
      },
      validator: (enteredValue) {
        if (enteredValue == null) {
          return 'This field cannot be empty';
        }
        if (enteredValue.isEmpty) {
          return 'This field cannot be empty';
        }
        try {
          double.parse(enteredValue);
        } on Exception catch (e) {
          return 'Please enter a valid value';
        }
        if (double.parse(enteredValue) < 0) {
          return 'Please enter a number greater or equal to zero (0)';
        }
        return null;
      },
    );
  }
}
