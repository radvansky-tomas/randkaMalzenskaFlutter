import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/course.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
import 'package:randka_malzenska/screens/video/video_content.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/html/white_html.dart';

class InfoScreen extends StatefulWidget {
  final User _user;
  InfoScreen(this._user);
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  ConnectionService connectionService = new ConnectionService();

  @override
  void initState() {
    super.initState();
  }

  Future<Course?> getCourse() {
    return connectionService.getCourse();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Course?>(
        future: getCourse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.black,
              drawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.black,
                  ),
                  child: StepDrawer(3, widget._user)),
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                title: Text(
                  'O aplikacji',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    WhiteHtml(snapshot.data!.intro),
                    Container(
                      height: 300,
                      child: VideoContent(snapshot.data!.videoIntro, null),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.black,
                drawer: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.black,
                    ),
                    child: StepDrawer(3, widget._user)),
                appBar: AppBar(
                  backgroundColor: Colors.grey[900],
                  title: Text(
                    'O aplikacji',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ));
          } else {
            return Container();
          }
        });
  }
}
