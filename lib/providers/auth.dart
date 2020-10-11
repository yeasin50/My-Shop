import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/constants.dart' as Constants;
import '../models/https_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  static const String KEY_USER_DATA = 'userData';
  String _token;
  DateTime _experyDate;
  String _userId;
  Timer _authTimer;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_experyDate != null &&
        _experyDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _auth(String emai, String password, String urlSegment) async {
    // TODO: add url
    // https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
    //https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${Constants.WEB_API_KEY}';
    // print(url);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': emai,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _experyDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      notifyListeners();
      // print(response.body);
      final sharePrefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _experyDate.toIso8601String(),
      });
      sharePrefs.setString(KEY_USER_DATA, userData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(KEY_USER_DATA)) {
      return false;
    }
    final extractData =
        json.decode(pref.getString(KEY_USER_DATA)) as Map<String, Object>;
    final expairyDate = DateTime.parse(extractData['expiryDate']);
    if (expairyDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractData['token'];
    _userId = extractData['userId'];
    _experyDate = expairyDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logIn(String emai, String password) async {
    return _auth(emai, password, 'signInWithPassword');
  }

  Future<void> signUp(String emai, String password) async {
    return _auth(emai, password, 'signUp');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _experyDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pres = await SharedPreferences.getInstance();
    
    // here we can use clear being single data stored 
    // pres.remove(KEY_USER_DATA);
    pres.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    var expireTime = _experyDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expireTime), logOut);
  }
}
