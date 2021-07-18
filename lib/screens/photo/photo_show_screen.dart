import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

class PhotoShowScreen extends StatefulWidget {
  final List<Photo> _photos;

  PhotoShowScreen(this._photos);

  @override
  _PhotoShowScreenState createState() => _PhotoShowScreenState();
}

class _PhotoShowScreenState extends State<PhotoShowScreen> {
  int _pos = 0;
  Timer? _timer;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    _timer = Timer.periodic(new Duration(seconds: 5), (timer) {
      setState(() {
        _pos = (_pos + 1) % widget._photos.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer
        .play('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    return Image.file(File(widget._photos[_pos].path!));
  }

  @override
  void dispose() {
    _timer!.cancel();
    audioPlayer.stop();
    _timer = null;
    super.dispose();
  }
}
