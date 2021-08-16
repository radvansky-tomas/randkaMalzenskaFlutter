import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:randka_malzenska/models/content.dart';
import 'package:randka_malzenska/screens/audio/audio_content.dart';
import 'package:randka_malzenska/screens/video/video_content.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

class ContentScreen extends StatefulWidget {
  final int _subStepId;
  final String _firebaseId;

  ContentScreen(this._subStepId, this._firebaseId);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<Content>?>? contents;

  @override
  void initState() {
    super.initState();
    contents = connectionService.getUserStepContent(
        widget._subStepId, widget._firebaseId);
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
        } else if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data);
          return sampleBody(snapshot.data);
        } else
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
      },
    );
  }
}

Widget sampleBody(List<Content>? awaitedContents) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      child: ListView.builder(
          itemCount: awaitedContents!.length,
          itemBuilder: (context, index) {
            Content content = awaitedContents[index];
            if (content.type == 'HTML') {
              return Container(
                child: Html(data: content.value),
              );
            } else if (content.type == 'VIDEO') {
              return Container(height: 300, child: VideoContent(content.value));
            } else if (content.type == 'AUDIO') {
              return Container(height: 200, child: AudioContent(content.value));
            } else if (content.type == 'CAMERA') {
              return TextButton(
                onPressed: () {},
                child: Text(
                  content.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(content.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
              );
            }
          }),
    ),
  );
}
