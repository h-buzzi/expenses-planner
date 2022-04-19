import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:my_expenses_planner/screen/grid_calendar/percentages/percentage_circle.dart';
import 'package:my_expenses_planner/screen/grid_calendar/percentages/percentages_list.dart';
import 'package:provider/provider.dart';

class CategoryPercentages extends StatefulWidget {
  const CategoryPercentages({Key? key}) : super(key: key);

  @override
  State<CategoryPercentages> createState() => _CategoryPercentagesState();
}

class _CategoryPercentagesState extends State<CategoryPercentages> {
  @override
  Widget build(BuildContext context) {
    final _userIncomeProvider = Provider.of<UserParams>(context);
    if (MediaQuery.of(context).size.width >= 390) {
      return Row(
        children: (_userIncomeProvider.userSalary > 0.0 ||
                _userIncomeProvider.foodVoucher > 0.0 ||
                _userIncomeProvider.mealVoucher > 0.0)
            ? const [
                Expanded(flex: 6, child: PercentagesList()),
                Expanded(
                  flex: 4,
                  child: PercentageCircle(),
                )
              ]
            : const [PercentageCircle()],
      );
    } else if (MediaQuery.of(context).size.width < 390) {
      return Column(
        children: (_userIncomeProvider.userSalary > 0.0 ||
                _userIncomeProvider.foodVoucher > 0.0 ||
                _userIncomeProvider.mealVoucher > 0.0)
            ? const [
                SizedBox(
                  height: 30,
                ),
                PercentageCircle(),
                PercentagesList()
              ]
            : const [
                SizedBox(
                  height: 30,
                ),
                PercentageCircle(),
              ],
      );
    } else {
      return const SizedBox(
        height: 1,
      );
    }
  }
}
