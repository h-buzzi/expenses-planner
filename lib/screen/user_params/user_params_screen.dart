import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:my_expenses_planner/screen/drawer/app_drawer.dart';
import 'package:my_expenses_planner/screen/grid_calendar/grid_calendar_screen.dart';
import 'package:my_expenses_planner/screen/user_params/widget/day_night_button_set_default_theme.dart';
import 'package:my_expenses_planner/screen/user_params/widget/user_params_section_container.dart';
import 'package:my_expenses_planner/screen/user_params/widget/user_params_textform_constructor.dart';
import 'package:provider/provider.dart';

class UserParamsScreen extends StatefulWidget {
  static const routeName = '/user-params-screen';

  const UserParamsScreen({Key? key}) : super(key: key);

  @override
  State<UserParamsScreen> createState() => _UserParamsScreenState();
}

class _UserParamsScreenState extends State<UserParamsScreen> {
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> _userIncomeFinancesData = {};
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final UserParams _userParams =
          Provider.of<UserParams>(context, listen: false);
      _userIncomeFinancesData = {
        'userSalary': _userParams.userSalary,
        'foodVoucher': _userParams.foodVoucher,
        'mealVoucher': _userParams.mealVoucher,
        'selectedThemeMode': _userParams.selectedThemeMode
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _setFinanceData(String _financeDataKey, dynamic _enteredFinanceValue) {
    _userIncomeFinancesData[_financeDataKey] = _enteredFinanceValue;
  }

  Future<void> _submitData() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserParams>(context, listen: false).setUserParamsToServer(
        _userIncomeFinancesData['userSalary'] as double,
        _userIncomeFinancesData['foodVoucher'] as double,
        _userIncomeFinancesData['mealVoucher'] as double,
        _userIncomeFinancesData['selectedThemeMode'] as String);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(GridCalendarScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'User Income',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).canvasColor,
      ),
      drawer: _isLoading ? null : AppDrawer(),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              heroTag: 'userParams',
              backgroundColor: Theme.of(context).primaryColorDark,
              child: Icon(
                Icons.save,
                color: Theme.of(context).canvasColor,
              ),
              onPressed: _submitData,
            ),
      body: Form(
        key: _form,
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                      vertical: defaultPadding * 0.5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(defaultPadding),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SectionContainer(
                            sectionString: 'Salary',
                          ),
                          TextFormUserParamsConstructor(
                            financeCategory: 'userSalary',
                            setFinanceFunction: _setFinanceData,
                            initialValue: _userIncomeFinancesData['userSalary']!
                                .toStringAsFixed(2),
                          ),
                          const SectionContainer(
                            sectionString: 'Food Voucher',
                          ),
                          TextFormUserParamsConstructor(
                            financeCategory: 'foodVoucher',
                            setFinanceFunction: _setFinanceData,
                            initialValue:
                                _userIncomeFinancesData['foodVoucher']!
                                    .toStringAsFixed(2),
                          ),
                          const SectionContainer(
                            sectionString: 'Meal Voucher',
                          ),
                          TextFormUserParamsConstructor(
                            financeCategory: 'mealVoucher',
                            setFinanceFunction: _setFinanceData,
                            initialValue:
                                _userIncomeFinancesData['mealVoucher']!
                                    .toStringAsFixed(2),
                          ),
                          const SectionContainer(
                            sectionString: 'Default Theme',
                          ),
                          Container(
                            child: DayNightSetUserParamButtons(
                              submitThemeSelected: _setFinanceData,
                            ),
                            color: Theme.of(context).canvasColor,
                            padding:
                                const EdgeInsets.all(defaultPadding * 0.25),
                          ),
                          const SizedBox(height: defaultPadding * 1.5),
                        ]),
                  ),
                ),
        ),
      ),
    );
  }
}
