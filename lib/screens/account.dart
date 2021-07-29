import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/audio/audio_screen.dart';
import 'package:randka_malzenska/screens/auth_screen.dart';
import 'package:randka_malzenska/screens/camera_screen.dart';
import 'package:randka_malzenska/screens/html/html_screen.dart';
import 'package:randka_malzenska/screens/notification/notification_screen.dart';
import 'package:randka_malzenska/screens/video/video_screen.dart';

class AccountContent extends StatefulWidget {
  @override
  _AccountContentState createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent> {
  late StreamSubscription<User?> loginStateSubscription;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _verifyUserIsLogged();
    _initializeNotification();
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
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<Auth>(context);

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: StreamBuilder<User?>(
        stream: authBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!.email!,
                  style: TextStyle(fontSize: 35.0),
                ),
                SizedBox(
                  height: 120.0,
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.amber[700])),
                  child: Text(
                    'Wyloguj',
                    style: TextStyle(fontSize: 35),
                  ),
                  onPressed: () => authBloc.logout(),
                ),
                screenButton(
                  context,
                  'Przejdz do aparatu',
                  Colors.amber[700],
                  CameraScreen(),
                ),
                notificationButton(
                  context,
                  flutterLocalNotificationsPlugin,
                ),
                screenButton(
                  context,
                  'Przejdz do odtwarzacza video',
                  Colors.purple[300],
                  VideoScreen(),
                ),
                screenButton(
                  context,
                  'Przejdz do odtwarzacza audio',
                  Colors.green[200],
                  AudioScreen(),
                ),
                screenButton(
                  context,
                  'Przejdz do podglądu html',
                  Colors.orange[700],
                  HtmlScreen(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget notificationButton(BuildContext context,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  return TextButton(
    style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.amber[700])),
    child: Text(
      'Wyslij powiadomienie',
      style: TextStyle(
        fontSize: 25,
        color: Colors.green,
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NotificationScreen(flutterLocalNotificationsPlugin);
          },
        ),
      );
    },
  );
}

Widget screenButton(
    BuildContext context, String text, Color? color, Widget widget) {
  return TextButton(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(color),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return widget;
          },
        ),
      );
    },
  );
}
