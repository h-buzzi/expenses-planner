import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

enum AuthMode { Signup, Login }

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryTime;
  String? _userId;
  Timer? _authTimer;
  final String _apiKey = 'AIzaSyCUxdEIkXlWiXa7qxKx7-wGbs--75gNVLQ ';

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryTime != null &&
        _expiryTime!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(
        email + '@hebgfksgjccr990002.com',
        password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey',
        AuthMode.Signup);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(
        email + '@hebgfksgjccr990002.com',
        password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey',
        AuthMode.Login);
  }

  Future<void> _authenticate(
      String email, String password, String url, AuthMode authType) async {
    final _firebaseAuthenticate = Uri.parse(url); //url para acessar o servidor
    try {
      //tenta autenticar/conectar com o servidor
      final response = await http.post(
        //espera uma respota do servidor
        _firebaseAuthenticate, //envia o json como body do pedido, informando o e-mail e senha inseridos, e pede para retornar um tokenSeguro
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response
          .body); //Uma vez tendo a resposta do servidor, decodifica do formato json
      if (responseData['error'] != null) {
        //Se tiver erro
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken']; //Se não tiver pega o token
      _userId = responseData['localId']; //pega também o id do usuário
      if (authType == AuthMode.Signup) {
        await http.post(
            Uri.parse(
                'https://expenses-planner-hebgfk-default-rtdb.firebaseio.com/$_userId/userparams.json?auth=$_token'),
            body: json.encode({
              'userSalary': 0.00,
              'foodVoucher': 0.00,
              'mealVoucher': 0.00,
              'selectedThemeMode': 'night',
            }));
      }
      _expiryTime = DateTime.now().add(
        //Cria o tempo de quando o token será inválido (ou seja, pega o tempo de agora e adiciona a duração do token)
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout(); //Inicia o timer de autoLogout
      notifyListeners(); //Avisa o aplicativo do login/registro
      final prefs = await SharedPreferences
          .getInstance(); //Pede para criar uma instância na memória com as informações do usuário
      final userData = json.encode({
        //Salva as informações do usuário como json
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryTime!.toIso8601String()
      });
      prefs.setString('userData', userData); //Salva na instância da memória
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryTime = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryTime!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    try {
      SharedPreferences.getInstance();
    } catch (e) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    try {
      json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    } catch (error) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    if (_token == null || _userId == null) {
      return false;
    } else if (_token!.isEmpty || _userId!.isEmpty) {
      return false;
    }
    _expiryTime = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
