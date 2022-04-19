import 'package:flutter/material.dart';
import 'package:my_expenses_planner/screen/grid_calendar/grid_calendar_screen.dart';

class ExpensesListTile extends StatelessWidget {
  const ExpensesListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
      title: Text('Expenses', style: Theme.of(context).textTheme.bodyText1),
      onTap: () {
        Navigator.of(context)
            .pushReplacementNamed(GridCalendarScreen.routeName);
      },
    );
  }
}
