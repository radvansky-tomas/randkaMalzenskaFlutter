import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/camera.dart';
import 'package:randka_malzenska/screens/photo/photo_presentation.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

class PhotoPresentationScreen extends StatefulWidget {
  final User _user;
  PhotoPresentationScreen(this._user);
  @override
  _PhotoPresentationScreenState createState() =>
      _PhotoPresentationScreenState();
}

class _PhotoPresentationScreenState extends State<PhotoPresentationScreen> {
  Future<List<Photo>?>? _localPhotos;
  Future<List<Camera>?>? _remotePhotos;
  ConnectionService service = new ConnectionService();

  @override
  void initState() {
    _localPhotos = _readLocalPhotos();
    _remotePhotos = _readRemotePhotos();
    super.initState();
  }

  Future<List<Photo>?> _readLocalPhotos() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    return await helper.queryPhoto();
  }

  Future<List<Camera>?> _readRemotePhotos() async {
    return service.getCameras(widget._user.uid);
  }

  @override
  Widget build(BuildContext context) {
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
                    return Scaffold(
                      backgroundColor: Colors.black,
                      body: Stack(
                        children: [
                          Center(
                            child: PhotoPresentation(joinedPhtos),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsetsDirectional.all(30),
                            child: IconButton(
                              onPressed: _onSkipPressed,
                              icon: (Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 50,
                              )),
                            ),
                          )
                        ],
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

  void _onSkipPressed() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
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
