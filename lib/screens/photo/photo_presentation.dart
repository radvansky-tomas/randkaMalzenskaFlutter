import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/camera.dart';

class PhotoPresentation extends StatefulWidget {
  final List<Camera> photos;
  PhotoPresentation(this.photos);

  @override
  _PhotoPresentationState createState() => _PhotoPresentationState();
}

class _PhotoPresentationState extends State<PhotoPresentation> {
  int _pos = 0;
  Timer? _timer;
  List<Image> images = [];

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    _timer = Timer.periodic(new Duration(seconds: 4), (timer) {
      setState(() {
        _pos = (_pos + 1) % widget.photos.length;
      });
    });
    widget.photos.forEach((element) {
      if (element.value != null) {
        images.add(Image.network(element.value!));
      } else {
        images.add(Image.file(File(element.localPath!)));
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    images.forEach((element) {
      precacheImage(element.image, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer
        .play('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    return images[_pos];
  }

  @override
  void dispose() {
    _timer!.cancel();
    audioPlayer.stop();
    _timer = null;
    super.dispose();
  }
}
