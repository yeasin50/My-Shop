import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stateManagement/models/https_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _experyDate;
  String _userId;

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
    final url = 'from fstoreAPI $urlSegment';
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
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> logIn(String emai, String password) async {
    return _auth(emai, password, 'verifyPassword');
  }

  Future<void> signUp(String emai, String password) async {
    return _auth(emai, password, 'signupNewUser');
  }
}
