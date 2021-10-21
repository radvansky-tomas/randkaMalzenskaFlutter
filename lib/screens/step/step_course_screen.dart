import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:randka_malzenska/models/course.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
import 'package:randka_malzenska/screens/step/step_screen.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCourseScreen extends StatefulWidget {
  final User user;
  StepCourseScreen(this.user);
  @override
  _StepCourseScreenState createState() => _StepCourseScreenState();
}

class _StepCourseScreenState extends State<StepCourseScreen> {
  ConnectionService connectionService = new ConnectionService();
  late SharedPreferences prefs;
  Future<Course?> getCourse() {
    return connectionService.getCourse();
  }

  @override
  void initState() {
    super.initState();
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
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
              prefs.setInt(PreferencesKey.numberOfSteps, course.totalSteps);
              return StepScreen(widget.user);
            } else {
              prefs.setInt(PreferencesKey.numberOfSteps, course.totalSteps);
              return textWithAppBar(context, widget.user,
                  "Trwają prace nad aplikacją, zapraszamy później: )");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
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
