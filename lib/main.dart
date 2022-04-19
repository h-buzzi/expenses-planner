import 'package:flutter/material.dart';
import 'package:my_expenses_planner/provider/authentication_provider.dart';
import 'package:my_expenses_planner/provider/expenses_list_class.dart';
import 'package:my_expenses_planner/provider/user_params.dart';
import 'package:my_expenses_planner/screen/add_new_expense/add_expenses_screen.dart';
import 'package:my_expenses_planner/screen/authentication_screen/auth_screen.dart';
import 'package:my_expenses_planner/screen/expense_details_screen/expense_details_screen.dart';
import 'package:my_expenses_planner/screen/grid_calendar/grid_calendar_screen.dart';
import 'package:my_expenses_planner/screen/user_params/user_params_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, ExpensesList>(
          create: (context) => ExpensesList(userId: '', authToken: ''),
          update: (context, auth, previousExpenses) => ExpensesList(
              authToken: auth.token != null ? auth.token as String : '',
              userId: auth.userId != null ? auth.userId as String : ''),
        ),
        ChangeNotifierProxyProvider<Auth, UserParams>(
          create: (context) => UserParams(
            authToken: '',
            userId: '',
          ),
          update: (context, auth, previousExpenses) => UserParams(
              authToken: auth.token != null ? auth.token as String : '',
              userId: auth.userId != null ? auth.userId as String : ''),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) {
          ifAuth(targetScreen) => authData.isAuth ? targetScreen : AuthScreen();
          return MaterialApp(
            title: 'My Expenses Planner',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              canvasColor: Provider.of<UserParams>(context).colorMode,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                  secondary: Colors.white,
                  tertiary: Colors.grey,
                  primaryContainer: Colors.red.shade700,
                  secondaryContainer: Colors.amber.shade700,
                  tertiaryContainer: Colors.lightGreen.shade900,
                  onTertiaryContainer: Colors.blueGrey,
                  outline: Colors.brown),
              // primarySw = mandatory, primaryC = learning, secondaryC = leisure, tertiaryC = groceries, onTertiary = meals, outline = others
              textTheme: TextTheme(
                bodyText1: TextStyle(
                    color: Colors.indigo.shade300,
                    fontFamily: 'Square',
                    fontSize: 14),
                bodyText2: const TextStyle(
                    color: Colors.black, fontFamily: 'Square', fontSize: 14),
                headline1: TextStyle(
                    color: Colors.indigo.shade300,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
                headline2: const TextStyle(
                    color: Colors.white, fontFamily: 'Roboto', fontSize: 17),
              ),
            ),
            home: authData.isAuth
                ? GridCalendarScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? Scaffold(
                                backgroundColor: Theme.of(context).canvasColor,
                                body: Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              )
                            : AuthScreen()),
            routes: {
              GridCalendarScreen.routeName: (context) =>
                  ifAuth(GridCalendarScreen()),
              ExpenseDetailsScreen.routeName: (context) =>
                  ifAuth(const ExpenseDetailsScreen()),
              AuthScreen.routeName: (context) => AuthScreen(),
              AddNewExpenseScreen.routeName: (context) =>
                  ifAuth(AddNewExpenseScreen()),
              UserParamsScreen.routeName: (context) =>
                  ifAuth(const UserParamsScreen()),
            },
          );
        },
      ),
    );
  }
}
