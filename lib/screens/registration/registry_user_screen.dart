import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/registration/registry_marriage_status_screen.dart';
import 'package:randka_malzenska/screens/video/video_screen.dart';

class RegistryUserScreen extends StatelessWidget {
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
              'Tu będzie rejestracja',
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
                    "Idź dalej",
                    () => {
                      _onPressed(
                        context,
                        'https://player.vimeo.com/external/486833973.hd.mp4?s=b5034e69142ea5b3028f8f9696ec688a30e81c14&profile_id=175',
                        new RegistryStatusScreen(),
                      )
                    },
                  ),
                ),
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
