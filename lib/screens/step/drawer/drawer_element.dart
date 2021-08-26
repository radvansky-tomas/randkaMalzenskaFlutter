import 'package:flutter/material.dart';

class DrawerElement extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final VoidCallback _function;
  final bool _isHighlited;
  DrawerElement(this._text, this._icon, this._function, this._isHighlited);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isHighlited ? Colors.blue : Colors.black,
      child: ListTile(
          leading: Icon(
            _icon,
            color: Colors.white,
          ),
          title: Text(
            _text,
            style: TextStyle(color: Colors.white),
          ),
          onTap: _function),
    );
  }
}
