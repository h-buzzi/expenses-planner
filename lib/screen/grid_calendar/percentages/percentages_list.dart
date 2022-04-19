import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:my_expenses_planner/screen/grid_calendar/percentages/percentage_list_tile.dart';
import 'package:provider/provider.dart';

class PercentagesList extends StatelessWidget {
  const PercentagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userIncomeProvider = Provider.of<UserParams>(context);
    final _expenses = Provider.of<ExpensesList>(context);

    double getCorrectAllExpenses() {
      if (_userIncomeProvider.foodVoucher == 0.0 &&
          _userIncomeProvider.mealVoucher == 0.0) {
        return _expenses.totalExpensesOfTheMonth;
      } else if (_userIncomeProvider.foodVoucher == 0.0 &&
          _userIncomeProvider.mealVoucher != 0.0) {
        return (_expenses.allOtherCategoryExpensesOfTheMonth +
            _expenses.groceriesExpensesOfTheMonth);
      } else if (_userIncomeProvider.foodVoucher != 0.0 &&
          _userIncomeProvider.mealVoucher == 0.0) {
        return _expenses.allOtherCategoryExpensesOfTheMonth +
            _expenses.mealsExpensesOfTheMonth;
      } else {
        return _expenses.allOtherCategoryExpensesOfTheMonth;
      }
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (_userIncomeProvider.userSalary > 0.0 &&
              ((_expenses.filteredCategory != 'meals' &&
                      _expenses.filteredCategory != 'groceries') ||
                  _expenses.filteredCategory.isEmpty))
            PercentageTile(
              title: 'Salary',
              categoryColor: Theme.of(context).primaryColor,
              expenseCost: getCorrectAllExpenses(),
              userIncome: _userIncomeProvider.userSalary,
            ),
          if (_userIncomeProvider.mealVoucher > 0.0 &&
              (_expenses.filteredCategory == 'meals' ||
                  _expenses.filteredCategory.isEmpty))
            PercentageTile(
              title: 'Meal Voucher',
              categoryColor: Theme.of(context).colorScheme.onTertiaryContainer,
              expenseCost: _expenses.mealsExpensesOfTheMonth,
              userIncome: _userIncomeProvider.mealVoucher,
            ),
          if (_userIncomeProvider.foodVoucher > 0.0 &&
              (_expenses.filteredCategory == 'groceries' ||
                  _expenses.filteredCategory.isEmpty))
            PercentageTile(
              title: 'Food Voucher',
              categoryColor: Theme.of(context).colorScheme.tertiaryContainer,
              expenseCost: _expenses.groceriesExpensesOfTheMonth,
              userIncome: _userIncomeProvider.foodVoucher,
            ),
        ],
      ),
    );
  }
}
