import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:randka_malzenska/shared/html/white_html.dart';

class Intro extends StatelessWidget {
  final String _text;
  final String _buttonText;
  final VoidCallback _introWatched;
  Intro(this._text, this._introWatched, this._buttonText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 15,
          child: Center(
            child: WhiteHtml(
              _text,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity,
                    30), // double.infinity is the width and 30 is the height
              ),
              onPressed: _introWatched,
              child: Text(
                _buttonText,
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }
}
