import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/course.dart';
import 'package:randka_malzenska/screens/video/video_content.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/html/white_html.dart';

class CourseDescriptionScreen extends StatefulWidget {
  @override
  _CourseDescriptionScreenState createState() =>
      _CourseDescriptionScreenState();
}

class _CourseDescriptionScreenState extends State<CourseDescriptionScreen> {
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
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                title: Text(
                  'Prezentacja warsztatu',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    WhiteHtml(snapshot.data!.contentDescription),
                    Container(
                      height: 300,
                      child:
                          VideoContent(snapshot.data!.videoCourse, null, null),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.grey[900],
                  title: Text(
                    'Prezentacja warsztatu',
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
