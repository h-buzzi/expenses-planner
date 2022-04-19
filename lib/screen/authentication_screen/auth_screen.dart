import 'package:flutter/material.dart';
import 'package:my_expenses_planner/constants.dart';
import 'package:my_expenses_planner/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _login = FocusNode();
  final _password = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmPassword = FocusNode();
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void setAuthValue(String _authDataKey, String _enteredTextValue) {
    _authData[_authDataKey] = _enteredTextValue;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) {
      // Invalid!
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'] as String, _authData['password'] as String);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          'An Error Occurred!',
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Okay!',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(defaultPadding)),
          width: deviceSize.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextFormConstructor(
                      focusNode: _login,
                      nextFocus: _password,
                      setAuthData: setAuthValue,
                      authDataString: 'email',
                      obscure: false,
                      keyType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      passwordController: null,
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextFormConstructor(
                      focusNode: _password,
                      nextFocus: _confirmPassword,
                      setAuthData: setAuthValue,
                      authDataString: 'password',
                      obscure: true,
                      keyType: TextInputType.multiline,
                      inputAction: _authMode == AuthMode.Login
                          ? TextInputAction.done
                          : TextInputAction.next,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: defaultPadding),
                    if (_authMode == AuthMode.Signup)
                      Text(
                        'Confirm Password',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    if (_authMode == AuthMode.Signup)
                      TextFormConstructor(
                        nextFocus: _confirmPassword,
                        setAuthData: setAuthValue,
                        authDataString: '',
                        keyType: TextInputType.multiline,
                        obscure: true,
                        inputAction: TextInputAction.done,
                        focusNode: _confirmPassword,
                        passwordController: _passwordController,
                      ),
                    const SizedBox(height: defaultPadding),
                    Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                _authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGNUP',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        fontSize: 18, color: Colors.white),
                              ),
                        onPressed: _submit,
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Center(
                      child: OutlinedButton(
                          onPressed: _switchAuthMode,
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 2)),
                          child: Text(
                            '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: 18),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFormConstructor extends StatelessWidget {
  const TextFormConstructor({
    Key? key,
    required FocusNode nextFocus,
    required Function setAuthData,
    required String authDataString,
    required TextInputType keyType,
    required bool obscure,
    required TextInputAction inputAction,
    required FocusNode focusNode,
    required TextEditingController? passwordController,
  })  : _nextFocus = nextFocus,
        _setAuthData = setAuthData,
        _keyType = keyType,
        _obscure = obscure,
        _authDataString = authDataString,
        _inputAction = inputAction,
        _focusNode = focusNode,
        _passwordController = passwordController,
        super(key: key);

  final FocusNode _nextFocus;
  final Function _setAuthData;
  final String _authDataString;
  final TextInputType _keyType;
  final bool _obscure;
  final TextInputAction _inputAction;
  final FocusNode _focusNode;
  final TextEditingController? _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: _inputAction,
      keyboardType: _keyType,
      style: TextStyle(color: Theme.of(context).primaryColorLight),
      obscureText: _obscure,
      focusNode: _focusNode,
      controller: _authDataString == 'password' ? _passwordController : null,
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        errorMaxLines: 3,
        fillColor: Theme.of(context).canvasColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultPadding)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultPadding),
          borderSide: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      onFieldSubmitted: (_) {
        if (_authDataString.isNotEmpty) {
          FocusScope.of(context).requestFocus(_nextFocus);
        }
      },
      onSaved: (enteredValue) {
        if (_authDataString.isNotEmpty) {
          _setAuthData(_authDataString, enteredValue);
        }
      },
      validator: _authDataString == 'email'
          ? (enteredValue) {
              if (enteredValue == null || enteredValue.isEmpty) {
                return 'This field cannot be empty';
              }
              if (enteredValue.length < 4) {
                return 'Username needs to be at least 4 characters long';
              }
              final List<String> forbiddenChars = [
                '!',
                '@',
                '#',
                '\$',
                '%',
                '¨',
                '&',
                '*',
                '(',
                ')',
                '+',
                '=',
                '§',
                '´',
                '`',
                '{',
                '[',
                'ª',
                '}',
                ']',
                'º',
                '<',
                '>',
                ',',
                ':',
                ';',
                '~',
                '^',
                'ç',
                '/',
                '?',
                '°',
                '|',
                '\\',
                '"',
                '\'',
              ];
              if (forbiddenChars
                  .any((letter) => enteredValue.contains(letter))) {
                return 'Invalid characters detected, use only letters, numbers and (_ - .)';
              }
              return null;
            }
          : _authDataString.isEmpty
              ? (enteredValue) {
                  if (enteredValue == null || enteredValue.isEmpty) {
                    return 'Confirm Password cannot be empty';
                  }
                  if (enteredValue != _passwordController!.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                }
              : (enteredValue) {
                  if (enteredValue == null || enteredValue.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (enteredValue.length <= 6) {
                    return 'Password needs to be at least 7 characters long';
                  }
                  return null;
                },
    );
  }
}
