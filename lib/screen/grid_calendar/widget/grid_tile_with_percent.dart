import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:provider/provider.dart';

class GridTileWithPercent extends StatelessWidget {
  const GridTileWithPercent({
    Key? key,
    required int index,
  })  : _index = index,
        super(key: key);

  final int _index;

  Color gridDayColor(int day, BuildContext context, double dayPercentage) {
    if (dayPercentage == 0.0) {
      return Colors.grey[600]!;
    } else {
      if (dayPercentage >= 30) {
        return Theme.of(context).primaryColor;
      }
      return Theme.of(context)
          .primaryColor
          .withOpacity(0.4 + ((dayPercentage / 100) * 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Consumer<ExpensesList>(
        builder: (_, expensesList, __) {
          final double _dayPercent = expensesList.getDayPercentage(_index);
          return Container(
            margin: const EdgeInsets.all(defaultPadding * 0.25),
            color: gridDayColor(_index, context, _dayPercent),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                _dayPercent > 0 ? '${_dayPercent.toStringAsFixed(0)}%' : '',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 17),
              ),
            ),
          );
        },
      ),
      footer: Container(
        margin: const EdgeInsets.all(defaultPadding * 0.25),
        color: Colors.black45,
        child: Text(
          '$_index',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
