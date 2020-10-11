import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/constants.dart' as Constants;
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
      notifyListeners();
      // print(response.body);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logIn(String emai, String password) async {
    return _auth(emai, password, 'signInWithPassword');
  }

  Future<void> signUp(String emai, String password) async {
    return _auth(emai, password, 'signUp');
  }
}
