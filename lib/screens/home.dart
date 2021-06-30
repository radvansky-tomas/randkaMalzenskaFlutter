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
      await Provider.of<Auth>(context, listen: false).logout(context: context);
    }

    var displeyName = userCredential.user!.displayName;
    if (displeyName == null) {
      displeyName = userCredential.user!.email;
    }

    var photoUrl = userCredential.user!.photoURL;
    if (photoUrl == null) {
      photoUrl =
          'https://i.wpimg.pl/730x0/m.fitness.wp.pl/4-ea52435acc6cf488e05e75c209b2bd.jpg';
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Witaj $displeyName',
              style: TextStyle(fontSize: 35.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(photoUrl),
              radius: 60.0,
            ),
            SizedBox(
              height: 100.0,
            ),
            TextButton(
              child: Text('Wyloguj'),
              onPressed: _logoutFace,
            ),
          ],
        ),
      ),
    );
  }
}
