import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/models/user_attributes.dart';
import 'package:randka_malzenska/screens/step/step_screen.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistryStatusScreen extends StatefulWidget {
  User user;
  RegistryStatusScreen(this.user);
  @override
  _RegistryStatusScreenState createState() => _RegistryStatusScreenState();
}

class _RegistryStatusScreenState extends State<RegistryStatusScreen> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'WYBIERZ STATUS ZWIĄZKU',
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: GenderButton(
                    "MAŁŻEŃSTWO",
                    () => {
                      _onPressed(
                        context,
                        prefs,
                        UserAttributes.marriage,
                        widget.user,
                      )
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: GenderButton(
                  "PRZED MAŁŻEŃSTWEM",
                  () => {
                    _onPressed(context, prefs, UserAttributes.beforeMarriage,
                        widget.user)
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context, SharedPreferences prefs, String text,
      User user) async {
    prefs.setString(PreferencesKey.userRelationshipStatus, text);
    ConnectionService service = new ConnectionService();
    List<String> attributes = [];
    attributes.add(text);
    String userSex = prefs.getString(PreferencesKey.userSex) ?? '';
    attributes.add(userSex);
    service
        .registerUser(user.displayName!, user.email!, user.uid, attributes)
        .whenComplete(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  //always start on first day after registration
                  return StepScreen(1, user);
                },
              ),
            ));
  }
}

class GenderButton extends StatelessWidget {
  final String _text;
  final VoidCallback _callback;
  GenderButton(this._text, this._callback);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          _text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 2, color: Colors.white),
      ),
      onPressed: _callback,
    );
  }
}
