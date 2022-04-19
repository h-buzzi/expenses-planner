import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:my_expenses_planner/screen/add_new_expense/add_expenses_screen.dart';
import 'package:my_expenses_planner/screen/drawer/app_drawer.dart';
import 'package:my_expenses_planner/screen/expense_details_screen/expense_details_screen.dart';
import 'package:my_expenses_planner/screen/grid_calendar/percentages/category_percentages.dart';
import 'package:my_expenses_planner/screen/grid_calendar/widget/grid_tile_with_percent.dart';
import 'package:my_expenses_planner/screen/grid_calendar/widget/select_month_year_appbar.dart';
import 'package:provider/provider.dart';

class GridCalendarScreen extends StatefulWidget {
  static const routeName = '/Grid-Calendar-Screen';

  @override
  State<GridCalendarScreen> createState() => _GridCalendarScreenState();
}

class _GridCalendarScreenState extends State<GridCalendarScreen> {
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    var expensListProvid = Provider.of<ExpensesList>(context, listen: false);
    if (expensListProvid.needsInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserParams>(context, listen: false)
          .fetchUserParams()
          .then((value) {
        expensListProvid.fetchAndSetExpenses().then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    expensListProvid.setNeedsInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _expensesListProvider = Provider.of<ExpensesList>(context);
    return _isLoading || _expensesListProvider.isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            ),
          )
        : Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
              title: SelectableMonthYearAppBar(),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).canvasColor,
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'gridCalendarScreen',
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).canvasColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewExpenseScreen.routeName,
                    arguments: {'id': '', 'day': -1});
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _expensesListProvider.numberOfDays(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width >= 390
                          ? 7
                          : MediaQuery.of(context).size.width >= 280
                              ? 5
                              : 4,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.12,
                    ),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ExpenseDetailsScreen.routeName,
                              arguments: index + 1);
                        },
                        child: GridTileWithPercent(index: index + 1),
                      );
                    },
                  ),
                  if (!_expensesListProvider.isExpensesEmpty)
                    const CategoryPercentages(),
                ],
              ),
            ),
          );
  }
}
