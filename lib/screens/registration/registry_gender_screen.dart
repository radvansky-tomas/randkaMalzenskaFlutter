import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/models/user_attributes.dart';
import 'package:randka_malzenska/screens/auth_screen.dart';
import 'package:randka_malzenska/screens/video/video_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistryUserDataScreen extends StatelessWidget {
  final SharedPreferences prefs;
  RegistryUserDataScreen(this.prefs);

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
              'WYBIERZ PŁEĆ',
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: GenderButton(
                    "MĘŻCZYZNA",
                    () => {
                      _onPressed(
                        context,
                        'https://player.vimeo.com/external/488460782.hd.mp4?s=acb30451ae7fcc25aaffd83347158bde864fd52e&profile_id=175',
                        new AuthScreen(),
                        prefs,
                        UserAttributes.male,
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
                  "KOBIETA",
                  () => {
                    _onPressed(
                      context,
                      'https://player.vimeo.com/external/488452170.hd.mp4?s=c11e831bae18770783db2434ee9775de18579151&profile_id=175',
                      new AuthScreen(),
                      prefs,
                      UserAttributes.female,
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

  void _onPressed(BuildContext context, String path, Widget widget,
      SharedPreferences prefs, String text) {
    prefs.setString(PreferencesKey.userSex, text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return VideoScreen(path, widget, false);
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
