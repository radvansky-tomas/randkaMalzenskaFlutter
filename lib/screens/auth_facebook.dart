import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/blocs/auth_bloc.dart';

class AuthFacebook extends StatelessWidget {
  const AuthFacebook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
        body: Center(
            //   child: Column(
            //     children: [
            //       SignInButton(Buttons.Facebook,
            //           // onPressed: () => authBloc.loginFacebook()),
            //     ],
            //   ),
            // ),
            ));
  }
}
