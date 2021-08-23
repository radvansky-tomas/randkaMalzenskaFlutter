import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:randka_malzenska/models/content.dart';
import 'package:randka_malzenska/screens/audio/audio_content.dart';
import 'package:randka_malzenska/screens/camera_screen.dart';
import 'package:randka_malzenska/screens/photo/photo_content.dart';
import 'package:randka_malzenska/screens/video/video_content.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

class ContentScreen extends StatefulWidget {
  final int _subStepId;
  final int _stepPosition;
  final String _subStepLabel;
  final String _firebaseId;
  final bool _isLast;
  final bool _isDone;
  final VoidCallback _refreshStep;

  ContentScreen(this._subStepId, this._firebaseId, this._subStepLabel,
      this._isLast, this._stepPosition, this._isDone, this._refreshStep);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<Content>?>? contents;
  Future<List<Photo>?>? photos;

  @override
  void initState() {
    super.initState();
    contents = connectionService.getUserStepContent(
        widget._subStepId, widget._firebaseId);
    photos = _readPhotos();
  }

  refresh() {
    setState(() {
      photos = _readPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Content>?>(
        future: contents,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  'Coś poszło nie tak :(',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return sampleBody(
                snapshot.data,
                widget._subStepLabel,
                photos,
                refresh,
                widget._isLast,
                widget._stepPosition,
                widget._firebaseId,
                widget._isDone,
                widget._refreshStep);
          } else if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  'Zajrzyj później ;)',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
        });
  }
}

Widget sampleBody(
  List<Content>? awaitedContents,
  String title,
  Future<List<Photo>?>? photos,
  VoidCallback refreshContent,
  bool isLast,
  int stepPosition,
  String firebaseId,
  bool isDone,
  VoidCallback refreshStep,
) {
  Content buttonContent = new Content(
      subStep: 0,
      label: 'label',
      title: 'title',
      image: 'image',
      value: 'value',
      position: 997,
      type: 'PROGRESS_BUTTON');
  if (awaitedContents!.length == 0) {
    awaitedContents.add(buttonContent);
  } else if (awaitedContents.last.position != buttonContent.position) {
    awaitedContents.add(buttonContent);
  }

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.grey[900],
      title: Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
    backgroundColor: Colors.black,
    body: Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      child: ListView.builder(
        addAutomaticKeepAlives: true,
        itemCount: awaitedContents.length,
        itemBuilder: (context, index) {
          Content content = awaitedContents[index];
          if (content.type == 'HTML') {
            return Container(
              child: Html(data: content.value),
            );
          } else if (content.type == 'VIDEO') {
            return Container(
              height: 300,
              child: VideoContent(content.value),
            );
          } else if (content.type == 'AUDIO') {
            return Container(
              height: 200,
              child: AudioContent(content.value),
            );
          } else if (content.type == 'CAMERA') {
            return photoPreview(
              photos,
              content,
              refreshContent,
            );
          } else if (content.type == 'PROGRESS_BUTTON') {
            String text = isLast ? 'Przejdź ostatni' : 'Przejdź dalej';
            return TextButton(
              onPressed: () {
                ConnectionService service = new ConnectionService();
                if (isDone) {
                  Navigator.pop(context);
                } else {
                  if (!isLast) {
                    service
                        .increaseSubStepProgress(stepPosition, firebaseId)
                        .whenComplete(() => {
                              refreshStep(),
                              Navigator.pop(context),
                            });
                  } else {
                    service
                        .increaseStepProgress(stepPosition, firebaseId)
                        .whenComplete(() => {
                              refreshStep(),
                              Navigator.pop(context),
                            });
                  }
                }
              },
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                content.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          }
        },
      ),
    ),
  );
}

Widget photoPreview(
    Future<List<Photo>?>? photos, Content content, VoidCallback callback) {
  return FutureBuilder<List<Photo>?>(
    future: photos,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              'Coś poszło nie tak :(',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.done) {
        Photo? photo;
        if (snapshot.hasData) {
          photo = snapshot.data?.firstWhere(
              (element) =>
                  element.primaryOrder == content.subStep &&
                  element.secondaryOrder == content.position,
              orElse: () => new Photo());
        }
        if (photo?.id == null) {
          photo = null;
        }
        return CameraContent(
          content.value,
          photo,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CameraScreen(
                      content.subStep, content.position, callback);
                },
              ),
            );
          },
        );
      } else {
        return Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }
    },
  );
}

Future<List<Photo>?> _readPhotos() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  return await helper.queryPhoto();
}
