import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/html/html_screen.dart';
import 'package:randka_malzenska/screens/registration/registry_user_screen.dart';
import 'package:randka_malzenska/screens/video/video_screen.dart';

class RegistryUserDataScreen extends StatelessWidget {
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
                        new RegistryUserScreen(),
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
                      new RegistryUserScreen(),
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

  void _onPressed(BuildContext context, String path, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return VideoScreen(
            path,
            widget,
          );
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
