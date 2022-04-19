import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/screen/drawer/widget/day_night_mode_buttons.dart';
import 'package:my_expenses_planner/screen/drawer/widget/expenses_list_tile.dart';
import 'package:my_expenses_planner/screen/drawer/widget/logout_list_tile.dart';
import 'package:my_expenses_planner/screen/drawer/widget/user_params_list_tile.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).canvasColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 0,
            ),
            const ExpensesListTile(),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            const UserParamsListTile(),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            const LogoutListTile(),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const DayNightModeButtons()
          ],
        ),
      ),
    );
  }
}
