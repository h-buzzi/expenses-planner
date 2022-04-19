import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

class LogoutListTile extends StatelessWidget {
  const LogoutListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor),
      title: Text('Logout', style: Theme.of(context).textTheme.bodyText1),
      onTap: () {
        Navigator.of(context).pop();
        Provider.of<Auth>(context, listen: false).logout();
      },
    );
  }
}
