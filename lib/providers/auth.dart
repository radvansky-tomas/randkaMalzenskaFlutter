import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:randka_malzenska/services/auth/auth_firebase_service.dart';

class Auth with ChangeNotifier {
  final authService = AuthService();
  final fb = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User?> get currentUser => authService.currentUser;

  Future<void> loginFacebook({required BuildContext context}) async {
    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );

    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? fbToken = res.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken!.token);
        //User credential to sing in with firebase
        await authService.signInWithCrendetail(credential);
        notifyListeners();
        break;
      case FacebookLoginStatus.cancel:
        ScaffoldMessenger.of(context).showSnackBar(
          Auth.customSnackBar(
            content: 'Wycofałeś logowanie z Facebook.',
          ),
        );
        break;
      case FacebookLoginStatus.error:
        print('ERROR LOGOWANIE FACEBOOK' +
            res.error!.developerMessage.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          Auth.customSnackBar(
            content: 'Wstąpił błąd przy logowaniu.',
          ),
        );
        break;
    }
  }

  logout() {
    fb.logOut();
    googleSignIn.signOut();
    authService.logout();
  }

  Future<void> signup(String email, String password) async {
    await authService.signUpWithEmailAndPassword(email, password);
    notifyListeners();
  }

  Future<void> signin(String email, String password) async {
    await authService.signInWithEmailAndPassword(email, password);
    notifyListeners();
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        await auth.signInWithCredential(credential);
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Auth.customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Auth.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Auth.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
