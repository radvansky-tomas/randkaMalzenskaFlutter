import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final String? imgPath;
  final String? fileName;
  PreviewScreen({this.imgPath, this.fileName});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zdjęcie')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(widget.imgPath!)),
    );
  }
}
