import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:provider/provider.dart';

class PercentageCircle extends StatefulWidget {
  const PercentageCircle({Key? key}) : super(key: key);

  @override
  State<PercentageCircle> createState() => _PercentageCircleState();
}

class _PercentageCircleState extends State<PercentageCircle> {
  bool _needsInit = true;
  int touchedIndex = -1;
  @override
  void didChangeDependencies() {
    if (_needsInit) {
      touchedIndex =
          Provider.of<ExpensesList>(context, listen: false).touchedIndex;
    }
    _needsInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _percentageProvider = Provider.of<ExpensesList>(context);
    touchedIndex = _percentageProvider.touchedIndex;
    final String _themeMode =
        Provider.of<UserParams>(context).selectedThemeMode;
    return Container(
      margin: const EdgeInsets.only(right: defaultPadding),
      height: MediaQuery.of(context).size.height * 0.14,
      width: double.infinity,
      child: Stack(children: [
        if (touchedIndex != -1)
          Center(
            child: Icon(
              Icons.restart_alt,
              color: Theme.of(context).primaryColor,
            ),
          ),
        PieChart(
          PieChartData(
              pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null) {
                  return;
                }
                if (pieTouchResponse.touchedSection == null) {
                  _percentageProvider.setTouchedIndex = -1;
                  return;
                }
                if (touchedIndex ==
                    pieTouchResponse.touchedSection!.touchedSectionIndex) {
                  return;
                }
                _percentageProvider.setTouchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              }),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: MediaQuery.of(context).size.width * 0.1,
              sections: showingSections(
                  textColor:
                      _themeMode == 'night' ? Colors.white : Colors.black,
                  mandatoryPercent:
                      _percentageProvider.getCategoryPercentage('mandatory'),
                  learningPercent:
                      _percentageProvider.getCategoryPercentage('learning'),
                  leisurePercent:
                      _percentageProvider.getCategoryPercentage('leisure'),
                  mealsPercent:
                      _percentageProvider.getCategoryPercentage('meals'),
                  groceriesPercent:
                      _percentageProvider.getCategoryPercentage('groceries'),
                  othersPercent:
                      _percentageProvider.getCategoryPercentage('others'))),
        ),
      ]),
    );
  }

  List<PieChartSectionData> showingSections(
      {required double mandatoryPercent,
      required double learningPercent,
      required double leisurePercent,
      required double mealsPercent,
      required double groceriesPercent,
      required double othersPercent,
      required Color textColor}) {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched
          ? Theme.of(context).textTheme.bodyText2!.fontSize! * 1.35
          : Theme.of(context).textTheme.bodyText2!.fontSize! + 1;
      final radius = isTouched ? defaultPadding * 2 + 10 : defaultPadding * 2;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).primaryColor,
            value: mandatoryPercent == 0.0
                ? 0.00000000000000000001
                : mandatoryPercent,
            title: mandatoryPercent == 0.0 ? '' : '$mandatoryPercent%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: textColor),
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.primaryContainer,
            value: learningPercent == 0.0
                ? 0.00000000000000000001
                : learningPercent,
            title: learningPercent == 0.0 ? '' : '$learningPercent%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: textColor),
          );
        case 2:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.secondaryContainer,
            value:
                leisurePercent == 0.0 ? 0.00000000000000000001 : leisurePercent,
            title: leisurePercent == 0.0 ? '' : '$leisurePercent%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: textColor),
          );
        case 3:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            value: groceriesPercent == 0.0
                ? 0.00000000000000000001
                : groceriesPercent,
            title: groceriesPercent == 0.0 ? '' : '$groceriesPercent%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: textColor),
          );
        case 4:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
            value: mealsPercent == 0.0 ? 0.00000000000000000001 : mealsPercent,
            title: mealsPercent == 0.0 ? '' : '$mealsPercent%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: textColor),
          );
        case 5:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.outline,
            value:
                othersPercent == 0.0 ? 0.00000000000000000001 : othersPercent,
            title: othersPercent == 0.0 ? '' : '$othersPercent%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: textColor),
          );
        default:
          throw Error();
      }
    });
  }
}
