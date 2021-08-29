import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/camera.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

class PhotoPresentation extends StatefulWidget {
  @override
  _PhotoPresentationState createState() => _PhotoPresentationState();
}

class _PhotoPresentationState extends State<PhotoPresentation> {
  Future<List<Photo>?>? _localPhotos;
  Future<List<Camera>?>? _remotePhotos;
  int _pos = 0;
  Timer? _timer;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    _localPhotos = _readLocalPhotos();
    _remotePhotos = _readRemotePhotos();
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        _pos = (_pos + 1) % 3;
      });
    });
    super.initState();
  }

  Future<List<Photo>?> _readLocalPhotos() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    return await helper.queryPhoto();
  }

  Future<List<Camera>?> _readRemotePhotos() async {
    List<Camera> cameras = [];
    cameras.add(Camera(
        position: 121,
        value:
            'https://www.sgs.pl/-/media/global/images/structural-website-images/hero-images/hero-agri-forestry.jpg'));
    return cameras;
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer
        .play('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    return FutureBuilder<List<Camera>?>(
        future: _remotePhotos,
        builder: (context, remotePhotos) {
          if (remotePhotos.connectionState == ConnectionState.done &&
              remotePhotos.hasData) {
            return FutureBuilder<List<Photo>?>(
                future: _localPhotos,
                builder: (context, localPhotos) {
                  if (localPhotos.connectionState == ConnectionState.done &&
                      localPhotos.hasData) {
                    List<Photo> localPhotoList = localPhotos.data!;
                    List<Camera> remotePhotoList = remotePhotos.data!;
                    List<Camera> joinedPhtos =
                        joinPhotos(remotePhotoList, localPhotoList);
                    return joinedPhtos[_pos].localPath != null
                        ? Image.file(File(joinedPhtos[_pos].localPath!))
                        : CachedNetworkImage(
                            imageUrl: joinedPhtos[_pos].value!,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          );
                  } else {
                    return Container();
                  }
                });
          } else {
            return Container();
          }
        });
  }

  @override
  void dispose() {
    _timer!.cancel();
    audioPlayer.stop();
    _timer = null;
    super.dispose();
  }
}

List<Camera> joinPhotos(List<Camera> remote, List<Photo> local) {
  List<Camera> sortedList = [];
  sortedList.addAll(remote);
  local.forEach((element) {
    sortedList
        .add(Camera(position: element.position!, localPath: element.path));
  });
  // return remote;
  return sortedList..sort((a, b) => a.position.compareTo(b.position));
}
