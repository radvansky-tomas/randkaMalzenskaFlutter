import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';

class AccountContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<Auth>(context);
    Future<void> _logout() async {
      await Provider.of<Auth>(context, listen: false).logout(context: context);
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
