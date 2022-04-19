import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/expenses_class.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:my_expenses_planner/screen/add_new_expense/add_expenses_screen.dart';
import 'package:my_expenses_planner/screen/expense_details_screen/day_percentages.dart';
import 'package:provider/provider.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  const ExpenseDetailsScreen({Key? key}) : super(key: key);

  static const routeName = '/expense-details-screen';

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  bool _isLoading = false;

  void _showItemDescript(BuildContext ctx, Expenses _selectedExpense) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) {
          return Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(ctx).size.height * 0.33,
            decoration: BoxDecoration(
                color: Theme.of(ctx).canvasColor,
                border: Border.symmetric(
                    horizontal: BorderSide(
                        color: Theme.of(ctx).primaryColor, width: 2))),
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(ctx).size.width * 0.8,
                child: Column(children: [
                  Text(
                    _selectedExpense.itemName,
                    style: Theme.of(ctx).textTheme.headline1!.copyWith(
                        color: Provider.of<UserParams>(context, listen: false)
                                    .selectedThemeMode ==
                                'night'
                            ? Colors.white
                            : Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Stack(
                    children: [
                      Text(
                        '\$${_selectedExpense.cost.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: Theme.of(ctx).textTheme.headline2!.copyWith(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = _selectedExpense
                                  .returnCategoryColor(context)),
                      ),
                      Text(
                        '\$${_selectedExpense.cost.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: Theme.of(ctx)
                            .textTheme
                            .headline2!
                            .copyWith(color: Theme.of(context).canvasColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    _selectedExpense.descript,
                    style: Theme.of(ctx)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 19),
                    textAlign: TextAlign.justify,
                  )
                ]),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final int _day = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).canvasColor,
        title: Text(
          '${DateFormat.MMMM().format(DateTime(0, Provider.of<ExpensesList>(context, listen: false).selectedMonth))} - Day $_day',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'expenseDetails',
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).canvasColor,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AddNewExpenseScreen.routeName,
              arguments: {'id': '', 'day': _day});
        },
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Consumer<ExpensesList>(
              builder: (context, expensesList, child) {
                Map<String, double> _categoryExpensesCostMap = {
                  'mandatory': 0.0,
                  'learning': 0.0,
                  'leisure': 0.0,
                  'meals': 0.0,
                  'groceries': 0.0,
                  'others': 0.0,
                };
                final List<Expenses> _expensesOnDay =
                    expensesList.fetchExpensesFromDay(_day);
                final double _deviceWidth = MediaQuery.of(context).size.width;
                if (_expensesOnDay != null && _expensesOnDay.isNotEmpty) {
                  for (var expense in _expensesOnDay) {
                    _categoryExpensesCostMap[expense.category] =
                        _categoryExpensesCostMap[expense.category]! +
                            expense.cost;
                  }
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.68,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: _expensesOnDay.length,
                          itemBuilder: (context, index) {
                            final _currentExpense = _expensesOnDay[index];
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    _showItemDescript(context, _currentExpense);
                                  },
                                  leading: SizedBox(
                                    width: _deviceWidth * 0.1,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          ((_currentExpense.cost /
                                                          expensesList
                                                              .totalExpensesOfTheMonth) *
                                                      100)
                                                  .toStringAsFixed(0) +
                                              '%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    _currentExpense.itemName,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontSize: 15),
                                  ),
                                  subtitle: MediaQuery.of(context).size.width <
                                          390
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(
                                                  defaultPadding * 0.25),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: Text(
                                                _currentExpense.cost
                                                        .toStringAsFixed(2) +
                                                    '\$',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(fontSize: 16),
                                              ),
                                            ),
                                            Text(
                                              _currentExpense.category,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: _currentExpense
                                                          .returnCategoryColor(
                                                              context),
                                                      fontSize: 15),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(
                                                  defaultPadding * 0.25),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: Text(
                                                _currentExpense.cost
                                                        .toStringAsFixed(2) +
                                                    '\$',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(fontSize: 16),
                                              ),
                                            ),
                                            Text(
                                              _currentExpense.category,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: _currentExpense
                                                          .returnCategoryColor(
                                                              context),
                                                      fontSize: 15),
                                            ),
                                          ],
                                        ),
                                  trailing: FittedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                AddNewExpenseScreen.routeName,
                                                arguments: {
                                                  'id': _currentExpense.id,
                                                  'day': -1
                                                });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red.shade700,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            expensesList
                                                .deleteExpense(
                                                    _currentExpense.id)
                                                .then((value) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      if (_expensesOnDay != null && _expensesOnDay.isNotEmpty)
                        DayPercentageCircle(
                          mapCost: _categoryExpensesCostMap,
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
