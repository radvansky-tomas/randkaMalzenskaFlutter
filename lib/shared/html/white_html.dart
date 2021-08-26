import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WhiteHtml extends StatelessWidget {
  final String _data;
  WhiteHtml(this._data);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: _data,
      style: {
        'div': Style(color: Colors.white),
        'h1': Style(color: Colors.white),
        'h2': Style(color: Colors.white),
        'h3': Style(color: Colors.white),
        'h4': Style(color: Colors.white),
        'h5': Style(color: Colors.white),
        'p': Style(color: Colors.white),
        'ul': Style(color: Colors.white),
        'li': Style(color: Colors.white),
      },
    );
  }
}
