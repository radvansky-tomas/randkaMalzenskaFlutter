import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';

class Home extends StatelessWidget {
  final UserCredential userCredential;

  Home(this.userCredential);

  @override
  Widget build(BuildContext context) {
    Future<void> _logoutFace() async {
      await Provider.of<Auth>(context, listen: false).logout();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Witaj ${userCredential.user!.displayName}',
              style: TextStyle(fontSize: 35.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(userCredential.user!.photoURL!),
              radius: 60.0,
            ),
            SizedBox(
              height: 100.0,
            ),
            SignInButton(
              Buttons.Facebook,
              text: 'Wyloguj z Facebook',
              onPressed: _logoutFace,
            ),
          ],
        ),
      ),
    );
  }
}
