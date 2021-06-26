import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/auth_screen.dart';

class Home extends StatelessWidget {
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
              'Ktos zalogowany',
              style: TextStyle(fontSize: 35.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.wpimg.pl/730x0/m.fitness.wp.pl/4-ea52435acc6cf488e05e75c209b2bd.jpg'),
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
