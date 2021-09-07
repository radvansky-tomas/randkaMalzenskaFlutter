import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/blog/blog_screen.dart';
import 'package:randka_malzenska/screens/info/info_screen.dart';
import 'package:randka_malzenska/screens/settings/settings_screen.dart';
import 'package:randka_malzenska/screens/step/drawer/drawer_element.dart';
import 'package:randka_malzenska/screens/step/step_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth_screen.dart';

class StepDrawer extends StatefulWidget {
  final int _index;
  final User _user;
  StepDrawer(this._index, this._user);
  @override
  _StepDrawerState createState() => _StepDrawerState();
}

class _StepDrawerState extends State<StepDrawer> {
  List<String> buttons = ['Start', 'Blog', 'Ustawienia', 'O aplikacji'];
  List<bool> highlited = [false, false, false, false];
  List<IconData> icons = [Icons.home, Icons.aod, Icons.settings, Icons.info];
  List<Widget> widgets = [];
  late StreamSubscription<User?> loginStateSubscription;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    highlited[widget._index] = true;
    widgets = [
      StepScreen(widget._user),
      BlogScreen(widget._user),
      SettingsScreen(widget._user),
      InfoScreen(widget._user)
    ];
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
    _verifyUserIsLogged();
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  void _verifyUserIsLogged() {
    var authBloc = Provider.of<Auth>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                'Witaj w menu bocznym',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: buttons.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DrawerElement(buttons[index], icons[index], () {
                      onClick(index, highlited, widgets);
                    }, highlited[index]),
                  );
                }),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: Text(
              'Wyloguj',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {
              prefs.setBool(PreferencesKey.introWatched, false),
              Provider.of<Auth>(context, listen: false).logout()
            },
          ),
        ],
      ),
    );
  }

  void onClick(int index, List<bool> highlited, List<Widget> widgets) {
    if (highlited[index] == true) {
      Navigator.pop(context);
      return;
    }
    for (int i = 0; i < highlited.length; i++) {
      setState(() {
        if (index == i) {
          highlited[index] = true;
        } else {
          //the condition to change the highlighted item
          highlited[i] = false;
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return widgets[index];
          },
        ),
      );
    }
  }
}
