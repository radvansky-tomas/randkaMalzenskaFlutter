import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:randka_malzenska/shared/database_helpers.dart';

class CameraContent extends StatefulWidget {
  final String _label;
  final int _primaryOrder;
  final int _secondaryOrder;
  final VoidCallback _callback;
  CameraContent(
      this._label, this._primaryOrder, this._secondaryOrder, this._callback);

  @override
  _CameraContentState createState() => _CameraContentState();
}

class _CameraContentState extends State<CameraContent> {
  Future<Photo?>? photo;
  @override
  void initState() {
    super.initState();
    photo = _readPhoto(widget._primaryOrder, widget._secondaryOrder);
  }

  refresh() {
    setState(() {
      photo = _readPhoto(widget._primaryOrder, widget._secondaryOrder);
    });
  }

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
        FutureBuilder<Photo?>(
            future: photo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Container(
                    height: 300, child: Image.file(File(snapshot.data!.path!)));
              } else {
                return SizedBox();
              }
            }),
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

Future<Photo?> _readPhoto(int primaryOrder, int secondaryOrder) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  return await helper.queryPhotoByPosition(primaryOrder, secondaryOrder);
}
