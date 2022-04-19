import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:provider/provider.dart';

class InfoParamDialog extends StatelessWidget {
  const InfoParamDialog({required String paramName, Key? key})
      : _paramName = paramName,
        super(key: key);
  final String _paramName;

  @override
  Widget build(BuildContext context) {
    final Color _canvasColor = Theme.of(context).canvasColor;
    final TextStyle _textStyle = Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(
            color: Provider.of<UserParams>(context).selectedThemeMode == 'night'
                ? Colors.white
                : Colors.black,
            fontSize: 14);
    return AlertDialog(
      backgroundColor: _canvasColor,
      title: Text(
        _paramName,
        style: _textStyle.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            if (_paramName == 'Salary')
              Text(
                'If you inform your Salary, the app will calculate how much you have spended and how much there is left, based from all your expenses (except Groceries and Meals if the other camps below are filled)',
                style: _textStyle,
                textAlign: TextAlign.justify,
              ),
            if (_paramName == 'Meal Voucher')
              Text(
                'If you inform the amount you receive in your Meal Voucher, the app will calculate how much you have spended and how much there is left, based from all your expenses with the Meals category',
                style: _textStyle,
                textAlign: TextAlign.justify,
              ),
            if (_paramName == 'Food Voucher')
              Text(
                'If you inform the amount you receive in your Food voucher, the app will calculate how much you have spended and how much there is left, based from all your expenses with the Groceries category',
                style: _textStyle,
                textAlign: TextAlign.justify,
              ),
          ],
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: _canvasColor),
            ),
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
