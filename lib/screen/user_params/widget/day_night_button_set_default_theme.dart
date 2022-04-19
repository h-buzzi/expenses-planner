import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:provider/provider.dart';

class DayNightSetUserParamButtons extends StatefulWidget {
  const DayNightSetUserParamButtons({
    required submitThemeSelected,
    Key? key,
  })  : _submitThemeSelected = submitThemeSelected,
        super(key: key);
  final Function _submitThemeSelected;

  @override
  State<DayNightSetUserParamButtons> createState() =>
      _DayNightSetUserParamButtonsState();
}

class _DayNightSetUserParamButtonsState
    extends State<DayNightSetUserParamButtons> {
  String mode = '';
  @override
  void didChangeDependencies() {
    mode = Provider.of<UserParams>(context, listen: false).selectedThemeMode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            widget._submitThemeSelected('selectedThemeMode', 'day');
            setState(() {
              mode = 'day';
            });
          },
          icon: Icon(
            mode == 'day' ? Icons.light_mode : Icons.light_mode_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        IconButton(
            onPressed: () {
              widget._submitThemeSelected('selectedThemeMode', 'night');
              setState(() {
                mode = 'night';
              });
            },
            icon: Icon(
              mode == 'night' ? Icons.dark_mode : Icons.dark_mode_outlined,
              color: Theme.of(context).primaryColor,
            ))
      ],
    );
  }
}
