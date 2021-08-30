import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/photo/photo_presentation_screen.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';

class InfoScreen extends StatefulWidget {
  final User _user;
  InfoScreen(this._user);
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
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
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PhotoPresentationScreen(widget._user);
                },
              ),
            );
          },
          child: Text('Przejdz do prezentacji',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
