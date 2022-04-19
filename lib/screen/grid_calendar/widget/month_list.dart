import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:provider/provider.dart';

class MonthList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (ctx, i) {
        return InkWell(
          splashColor: Theme.of(context).primaryColorDark,
          onTap: () {
            Provider.of<ExpensesList>(context, listen: false)
                .fetchAndSetExpenses(selectedDate: i + 1)
                .then((value) {
              Navigator.of(ctx).canPop() ? Navigator.of(context).pop() : null;
            });
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.all(defaultPadding * 0.75),
              padding: const EdgeInsets.all(defaultPadding / 2),
              width: MediaQuery.of(ctx).size.width * 0.33,
              decoration: BoxDecoration(
                  color: Theme.of(ctx).primaryColor,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(defaultPadding / 2))),
              child: Text(
                DateFormat.MMMM().format(
                  DateTime(0, i + 1),
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        );
      },
    );
  }
}
