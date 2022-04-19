import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:provider/provider.dart';

class DayNightModeButtons extends StatefulWidget {
  const DayNightModeButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<DayNightModeButtons> createState() => _DayNightModeButtonsState();
}

class _DayNightModeButtonsState extends State<DayNightModeButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            Provider.of<UserParams>(context, listen: false).setColorMode =
                'day';
          },
          icon: Icon(
            Provider.of<UserParams>(context).selectedThemeMode == 'day'
                ? Icons.light_mode
                : Icons.light_mode_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        IconButton(
            onPressed: () {
              Provider.of<UserParams>(context, listen: false).setColorMode =
                  'night';
            },
            icon: Icon(
              Provider.of<UserParams>(context).selectedThemeMode == 'night'
                  ? Icons.dark_mode
                  : Icons.dark_mode_outlined,
              color: Theme.of(context).primaryColor,
            ))
      ],
    );
  }
}
