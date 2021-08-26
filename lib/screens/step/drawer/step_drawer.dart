import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/blog/blog_screen.dart';
import 'package:randka_malzenska/screens/info/info_screen.dart';
import 'package:randka_malzenska/screens/settings/settings_screen.dart';
import 'package:randka_malzenska/screens/step/drawer/drawer_element.dart';
import 'package:randka_malzenska/screens/step/step_screen.dart';

class StepDrawer extends StatefulWidget {
  final int _index;
  final User _user;
  StepDrawer(this._index, this._user);
  @override
  _StepDrawerState createState() => _StepDrawerState();
}

class _StepDrawerState extends State<StepDrawer> {
  List<String> buttons = ['Start', 'Blogasdas', 'Ustawienia', 'O aplikacji'];
  List<bool> highlited = [false, false, false, false];
  List<IconData> icons = [Icons.home, Icons.aod, Icons.settings, Icons.info];
  List<Widget> widgets = [];

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
