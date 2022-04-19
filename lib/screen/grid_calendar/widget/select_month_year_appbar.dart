import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:my_expenses_planner/screen/grid_calendar/widget/month_list.dart';
import 'package:provider/provider.dart';

class SelectableMonthYearAppBar extends StatelessWidget {
  void _changeMoth(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(ctx).canvasColor,
              border: Border.symmetric(
                  horizontal:
                      BorderSide(color: Theme.of(ctx).primaryColor, width: 2))),
          height: MediaQuery.of(ctx).size.height * 0.2,
          child: MonthList(),
        );
      },
    );
  }

  void _changeYear(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) {
          return Container(
            padding: MediaQuery.of(ctx).viewInsets,
            height: MediaQuery.of(ctx).size.height * 0.5,
            decoration: BoxDecoration(
                color: Theme.of(ctx).canvasColor,
                border: Border.symmetric(
                    horizontal: BorderSide(
                        color: Theme.of(ctx).primaryColor, width: 2))),
            child: Align(
              alignment: Alignment.center,
              child: ChangeYearPicker(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          child: Text(
            DateFormat.MMMM().format(
                DateTime(0, Provider.of<ExpensesList>(context).selectedMonth)),
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
          ),
          onPressed: () {
            _changeMoth(context);
          },
        ),
        TextButton(
          child: Text(
            Provider.of<ExpensesList>(context).selectedYear.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
          ),
          onPressed: () {
            _changeYear(context);
          },
        ),
      ],
    );
  }
}

class ChangeYearPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final yearParamsProvider = Provider.of<ExpensesList>(context, listen: true);
    return YearPicker(
        firstDate: DateTime(2010),
        lastDate: DateTime(DateTime.now().year),
        selectedDate: DateTime(yearParamsProvider.selectedYear),
        onChanged: (_selectedYear) {
          yearParamsProvider
              .fetchAndSetExpenses(selectedDate: _selectedYear.year)
              .then((value) {
            Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
          });
        });
  }
}
