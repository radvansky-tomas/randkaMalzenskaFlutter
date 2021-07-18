import 'dart:io';

import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final _path;
  PhotoScreen(this._path);
  @override
  Widget build(BuildContext context) {
    return Image.file(File(_path));
  }
}
