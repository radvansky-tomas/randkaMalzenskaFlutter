import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/models/user_attributes.dart';
import 'package:randka_malzenska/screens/step/step_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistryStatusScreen extends StatefulWidget {
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
                    () => {_onPressed(context, prefs, UserAttributes.marriage)},
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
                    _onPressed(
                      context,
                      prefs,
                      UserAttributes.beforeMarriage,
                    )
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context, SharedPreferences prefs, String text) {
    prefs.setString(PreferencesKey.userRelationshipStatus, text);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return StepScreen();
        },
      ),
    );
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
