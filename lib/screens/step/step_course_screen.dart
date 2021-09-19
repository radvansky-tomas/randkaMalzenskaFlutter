import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/course.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
import 'package:randka_malzenska/screens/step/step_screen.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

class StepCourseScreen extends StatefulWidget {
  final User user;
  StepCourseScreen(this.user);
  @override
  _StepCourseScreenState createState() => _StepCourseScreenState();
}

class _StepCourseScreenState extends State<StepCourseScreen> {
  ConnectionService connectionService = new ConnectionService();
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
            Course course = snapshot.data!;
            if (course.ready == 1) {
              return StepScreen(widget.user);
            } else {
              return textWithAppBar(context, widget.user,
                  "Trwają prace nad aplikacją, zapraszamy później: )");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //BŁĄD
            return textWithAppBar(
                context, widget.user, "Coś poszło nie tak : (");
          }
        });
  }
}

Widget textWithAppBar(BuildContext context, User user, String text) {
  return Scaffold(
    backgroundColor: Colors.black,
    drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: StepDrawer(0, user)),
    appBar: AppBar(
      title: Text(
        "Randka małżeńska",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
    ),
    body: Center(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
