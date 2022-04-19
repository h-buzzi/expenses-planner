import 'package:flutter/material.dart';
import 'package:my_expenses_planner/screen/user_params/user_params_screen.dart';

class UserParamsListTile extends StatelessWidget {
  const UserParamsListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.monetization_on_outlined,
          color: Theme.of(context).primaryColor),
      title: Text('User Income', style: Theme.of(context).textTheme.bodyText1),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(UserParamsScreen.routeName);
      },
    );
  }
}
