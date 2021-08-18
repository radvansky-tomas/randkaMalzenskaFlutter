import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:randka_malzenska/shared/database_helpers.dart';

class CameraContent extends StatefulWidget {
  final String _label;
  final Photo? _photo;
  final VoidCallback _callback;
  CameraContent(this._label, this._photo, this._callback);

  @override
  _CameraContentState createState() => _CameraContentState();
}

class _CameraContentState extends State<CameraContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget._label,
          style: TextStyle(color: Colors.white),
        ),
        widget._photo != null
            ? Container(
                height: 300, child: Image.file(File(widget._photo!.path!)))
            : SizedBox(),
        TextButton.icon(
            onPressed: widget._callback,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            icon: Icon(Icons.camera),
            label: Text(
              "Zrób sobie zdjęcie",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }
}
