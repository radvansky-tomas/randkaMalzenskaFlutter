import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'home.dart';

class AuthFacebook extends StatelessWidget {
  const AuthFacebook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SignInButton(Buttons.Facebook,
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home())))
        ],
      ),
    ));
  }
}
