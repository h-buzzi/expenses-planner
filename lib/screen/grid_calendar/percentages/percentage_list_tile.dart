import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';

class PercentageTile extends StatelessWidget {
  const PercentageTile({
    Key? key,
    required String title,
    required Color categoryColor,
    required double expenseCost,
    required double userIncome,
  })  : _title = title,
        _categoryColor = categoryColor,
        _expenseCost = expenseCost,
        _userIncome = userIncome,
        super(key: key);

  final String _title;
  final Color _categoryColor;
  final double _expenseCost;
  final double _userIncome;

  @override
  Widget build(BuildContext context) {
    final double _percentage = _expenseCost / _userIncome;
    final _subtitleStyle =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: _categoryColor);
    return ListTile(
      title: Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _title,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: _categoryColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  '  $_userIncome \$',
                  style: _subtitleStyle.copyWith(fontWeight: FontWeight.normal),
                )
              ]),
          ProgressLine(
              color: _categoryColor,
              percentage: _percentage <= 1 ? _percentage : 1)
        ],
      ),
      subtitle:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(children: [
          Text(
            '-${_expenseCost.toStringAsFixed(2)} \$',
            style: _subtitleStyle,
          ),
          Text(
            '${(_percentage * 100).toStringAsFixed(2)} %',
            style: _subtitleStyle,
          )
        ]),
        Column(
          children: [
            Text(
              '${(_userIncome - _expenseCost).toStringAsFixed(2)} \$',
              style: _subtitleStyle,
            ),
            Text(
              '${((1 - _percentage) * 100).toStringAsFixed(2)} %',
              style: _subtitleStyle,
            )
          ],
        )
      ]),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    required this.color,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: defaultPadding * 0.25),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 10,
            decoration: BoxDecoration(
                color: color.withOpacity(0.25),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
          LayoutBuilder(builder: (ctxx, constraints) {
            return Container(
              width: constraints.maxWidth * percentage,
              height: 10,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            );
          })
        ],
      ),
    );
  }
}
