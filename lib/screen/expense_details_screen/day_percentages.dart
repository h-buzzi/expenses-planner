import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:provider/provider.dart';

class DayPercentageCircle extends StatelessWidget {
  DayPercentageCircle({
    Key? key,
    required Map<String, double> mapCost,
  })  : _categoryCosts = mapCost,
        super(key: key);
  final Map<String, double> _categoryCosts;
  static const radius = defaultPadding * 2;
  double _totalDayCost = 0.0;

  @override
  Widget build(BuildContext context) {
    final fontSize = Theme.of(context).textTheme.bodyText2!.fontSize! + 1;
    final textColor =
        Provider.of<UserParams>(context).selectedThemeMode == 'night'
            ? Colors.white
            : Colors.black;
    _categoryCosts.forEach(
      (key, value) {
        _totalDayCost += value;
      },
    );
    return Container(
      margin: const EdgeInsets.all(defaultPadding),
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.5,
      child: PieChart(
        PieChartData(
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: MediaQuery.of(context).size.width * 0.1,
            sections: [
              PieChartSectionData(
                color: Theme.of(context).primaryColor,
                value: _categoryCosts['mandatory'] == 0.0
                    ? 0.00000000000000000001
                    : (_categoryCosts['mandatory']! / _totalDayCost) * 100,
                title: _categoryCosts['mandatory'] == 0.0
                    ? ''
                    : '${((_categoryCosts['mandatory']! / _totalDayCost) * 100).toStringAsFixed(2)}%',
                radius: radius,
                titleStyle: TextStyle(fontSize: fontSize, color: textColor),
              ),
              PieChartSectionData(
                color: Theme.of(context).colorScheme.primaryContainer,
                value: _categoryCosts['learning'] == 0.0
                    ? 0.00000000000000000001
                    : (_categoryCosts['learning']! / _totalDayCost) * 100,
                title: _categoryCosts['learning'] == 0.0
                    ? ''
                    : '${((_categoryCosts['learning']! / _totalDayCost) * 100).toStringAsFixed(2)}%',
                radius: radius,
                titleStyle: TextStyle(fontSize: fontSize, color: textColor),
              ),
              PieChartSectionData(
                color: Theme.of(context).colorScheme.secondaryContainer,
                value: _categoryCosts['leisure'] == 0.0
                    ? 0.00000000000000000001
                    : (_categoryCosts['leisure']! / _totalDayCost) * 100,
                title: _categoryCosts['leisure'] == 0.0
                    ? ''
                    : '${((_categoryCosts['leisure']! / _totalDayCost) * 100).toStringAsFixed(2)}%',
                radius: radius,
                titleStyle: TextStyle(fontSize: fontSize, color: textColor),
              ),
              PieChartSectionData(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                value: _categoryCosts['groceries'] == 0.0
                    ? 0.00000000000000000001
                    : (_categoryCosts['groceries']! / _totalDayCost) * 100,
                title: _categoryCosts['groceries'] == 0.0
                    ? ''
                    : '${((_categoryCosts['groceries']! / _totalDayCost) * 100).toStringAsFixed(2)}%',
                radius: radius,
                titleStyle: TextStyle(fontSize: fontSize, color: textColor),
              ),
              PieChartSectionData(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                value: _categoryCosts['meals'] == 0.0
                    ? 0.00000000000000000001
                    : (_categoryCosts['meals']! / _totalDayCost) * 100,
                title: _categoryCosts['meals'] == 0.0
                    ? ''
                    : '${((_categoryCosts['meals']! / _totalDayCost) * 100).toStringAsFixed(2)}%',
                radius: radius,
                titleStyle: TextStyle(fontSize: fontSize, color: textColor),
              ),
              PieChartSectionData(
                color: Theme.of(context).colorScheme.outline,
                value: _categoryCosts['others'] == 0.0
                    ? 0.00000000000000000001
                    : (_categoryCosts['others']! / _totalDayCost) * 100,
                title: _categoryCosts['others'] == 0.0
                    ? ''
                    : '${((_categoryCosts['others']! / _totalDayCost) * 100).toStringAsFixed(2)}%',
                radius: radius,
                titleStyle: TextStyle(fontSize: fontSize, color: textColor),
              ),
            ]),
      ),
    );
  }
}
