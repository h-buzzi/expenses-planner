import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/screen/user_params/widget/alert_dialog_param_explain.dart';

class SectionContainer extends StatefulWidget {
  const SectionContainer({
    required sectionString,
    Key? key,
  })  : _sectionString = sectionString,
        super(key: key);
  final String _sectionString;

  @override
  State<SectionContainer> createState() => _SectionContainerState();
}

class _SectionContainerState extends State<SectionContainer> {
  Future<void> _showMyDialog() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return InfoParamDialog(
            paramName: widget._sectionString,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(defaultPadding / 2),
            margin: const EdgeInsets.only(top: defaultPadding * 1.5),
            child: Text(
              widget._sectionString,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).canvasColor),
            ),
          ),
          if (widget._sectionString != 'Default Theme')
            IconButton(
                onPressed: () {
                  _showMyDialog();
                },
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: Theme.of(context).canvasColor,
                ))
        ]);
  }
}
