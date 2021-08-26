import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';

class BlogScreen extends StatefulWidget {
  final User _user;
  BlogScreen(this._user);
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: StepDrawer(1, widget._user)),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Blog',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text(
          'Blog pojawi nie niebawem',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
