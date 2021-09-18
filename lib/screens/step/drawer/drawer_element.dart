import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerElement extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final VoidCallback _function;
  final bool _isHighlited;
  DrawerElement(this._text, this._icon, this._function, this._isHighlited);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isHighlited ? Color.fromARGB(255, 21, 74, 118) : Colors.black,
      child: ListTile(
          leading: Icon(
            _icon,
            color: Colors.white,
          ),
          title: Text(
            _text,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          onTap: _function),
    );
  }
}
