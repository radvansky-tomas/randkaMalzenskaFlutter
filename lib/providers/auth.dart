import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;
import 'package:randka_malzenska/models/http_exception.dart';
import 'package:randka_malzenska/services/auth_firebase_service.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  UserCredential? _userCredential;

  final authService = AuthService();
  final fb = FacebookLogin();

  Stream<User?> get currentUser => authService.currentUser;

  Future<void> loginFacebook() async {
    print('Starting Facebook login');
    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );

    switch (res.status) {
      case FacebookLoginStatus.success:
        //get token
        final FacebookAccessToken? fbToken = res.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken!.token);
        //User credential to sing in with firebase
        final result = await authService.signInWithCrendetail(credential);
        print('${result.user!.displayName} is now logged in');
        _token = fbToken.token;
        _userId = fbToken.userId;
        _expiryDate = fbToken.expires;
        _userCredential = result;
        notifyListeners();
        break;
      case FacebookLoginStatus.cancel:
        print('uzytkownik wycofal login');
        break;
      case FacebookLoginStatus.error:
        print('${res.error}error achtung');
        break;
    }
  }

  logout() {
    authService.logout();
    _userCredential = null;
    notifyListeners();
  }

  // bool get isAuth {
  //   return token != null;
  // }

  UserCredential? get isAuth {
    return user;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  UserCredential? get user {
    if (_userCredential != null) {
      return _userCredential;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD1kY0b5-J6S5_JL8jeD6oIMU2eZ-y_vRI');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> signup(String email, String password) async {
    UserCredential result =
        await authService.signUpWithEmailAndPassword(email, password);
    _userCredential = result;
    notifyListeners();
  }

  Future<void> signin(String email, String password) async {
    UserCredential result =
        await authService.signInWithEmailAndPassword(email, password);
    _userCredential = result;
    notifyListeners();
  }
}
