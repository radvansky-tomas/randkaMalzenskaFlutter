import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/content.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/models/sub_step.dart';
import 'package:randka_malzenska/screens/audio/audio_content.dart';
import 'package:randka_malzenska/screens/camera_screen.dart';
import 'package:randka_malzenska/screens/photo/photo_content.dart';
import 'package:randka_malzenska/screens/video/video_content.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/button/slide_progress_button.dart';
import 'package:randka_malzenska/shared/button/slide_quiz_button.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';
import 'package:randka_malzenska/shared/html/white_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentScreen extends StatefulWidget {
  final SubStep _subStep;
  final String _firebaseId;
  final bool _isLast;
  final VoidCallback _refreshStep;
  final int _stepPosition;
  final User user;

  ContentScreen(this._subStep, this._firebaseId, this._isLast,
      this._refreshStep, this._stepPosition, this.user);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<Content>?>? contents;
  Future<List<Photo>?>? photos;
  bool _showContent = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    contents = connectionService.getUserStepContent(
        widget._subStep.id, widget._firebaseId);
    photos = _readPhotos();
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  htmlReady() {
    setState(() {
      _showContent = true;
    });
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
            log(snapshot.error.toString());
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
            return contentBody(
                snapshot.data,
                widget._subStep,
                photos,
                refresh,
                htmlReady,
                widget._isLast,
                widget._stepPosition,
                widget._firebaseId,
                widget._refreshStep,
                prefs,
                widget.user);
          } else if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData &&
              _showContent) {
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

Widget contentBody(
  List<Content>? awaitedContents,
  SubStep subStep,
  Future<List<Photo>?>? photos,
  VoidCallback refreshContent,
  VoidCallback htmlReady,
  bool isLastSubStep,
  int stepPosition,
  String firebaseId,
  VoidCallback refreshStep,
  SharedPreferences prefs,
  User user,
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
    // subStep.visibleContainer == 0 means content is loaded directly in step screen, then appbar from content,
    // shouldnt be visible
    appBar: subStep.visibleContainer != 0
        ? AppBar(
            backgroundColor: Colors.grey[900],
            title: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                subStep.label,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        : null,
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: WhiteHtml(content.value),
              ),
            );
          } else if (content.type == 'VIDEO') {
            return Container(
              height: 300,
              child: VideoContent(content.value, content.image),
            );
          } else if (content.type == 'AUDIO') {
            return Container(
              height: 200,
              child: AudioContent(content.value),
            );
          } else if (content.type == 'CAMERA2') {
            return SizedBox();
          } else if (content.type == 'CAMERA') {
            return photoPreview(
              photos,
              content,
              stepPosition,
              subStep.position,
              refreshContent,
            );
          } else if (content.type == 'TEST') {
            return SlideQuizButton(int.parse(content.value));
          } else if (content.type == 'PROGRESS_BUTTON') {
            int numberOfSteps =
                prefs.getInt(PreferencesKey.numberOfSteps) ?? 26;
            bool isLastStep = numberOfSteps == stepPosition;
            String text = getButtonText(isLastStep, isLastSubStep);
            //subStep.visibleContainer==0 means it is only substep in step
            return SlideProgressButton(
                subStep.done!,
                isLastSubStep,
                isLastStep,
                text,
                refreshStep,
                firebaseId,
                subStep.step,
                subStep.visibleContainer == 0,
                user);
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

String getButtonText(bool isLastStep, bool isLastSubStep) {
  String text = '';
  if (isLastStep) {
    text = 'ODBIERZ NAGRODE';
  } else {
    text = isLastSubStep ? 'ZAKOŃCZ DZIEŃ' : 'DALEJ';
  }
  return text;
}

Widget photoPreview(Future<List<Photo>?>? photos, Content content,
    int stepPosition, int subStepPosition, VoidCallback callback) {
  return FutureBuilder<List<Photo>?>(
    future: photos,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        log(snapshot.error.toString());
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
        String concatedPos = stepPosition.toString() +
            subStepPosition.toString() +
            content.position.toString();
        if (snapshot.hasData) {
          photo = snapshot.data?.firstWhere(
              (element) => element.position == int.parse(concatedPos),
              orElse: () {
            return new Photo();
          });
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
                  return CameraScreen(int.parse(concatedPos), callback);
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
