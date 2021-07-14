import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/auth_screen.dart';

class AccountContent extends StatefulWidget {
  @override
  _AccountContentState createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent> {
  late StreamSubscription<User?> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<Auth>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthScreen()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<Auth>(context);
    Future<void> _logout() async {
      await Provider.of<Auth>(context, listen: false).logout();
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: StreamBuilder<User?>(
        stream: authBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!.email!,
                  style: TextStyle(fontSize: 35.0),
                ),
                SizedBox(
                  height: 120.0,
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.amber[700])),
                  child: Text(
                    'Wyloguj',
                    style: TextStyle(fontSize: 35),
                  ),
                  onPressed: _logout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
