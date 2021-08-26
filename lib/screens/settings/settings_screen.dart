import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class SettingsScreen extends StatefulWidget {
  final User _user;
  SettingsScreen(this._user);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late SharedPreferences prefs;
  String? _dateTimeFormatted;

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

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    _dateTimeFormatted = prefs.getString(PreferencesKey.notificationDate);
  }

  @override
  void initState() {
    super.initState();
    _initializeNotification();
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
    _configureLocalTimeZone();
  }

  Widget notification() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _dateTimeFormatted == null ? 'ustaw godzinę' : _dateTimeFormatted!,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextButton(
              onPressed: () {
                DatePicker.showTimePicker(context, showTitleActions: true,
                    onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  _scheduleDailyNotification(date.hour, date.minute);
                  prefs.setString(PreferencesKey.notificationDate,
                      DateFormat('kk:mm').format(date));
                  setState(() {
                    _dateTimeFormatted = DateFormat('kk:mm').format(date);
                  });
                }, currentTime: DateTime.now());
              },
              child: Text(
                'ustaw przypomnienie',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )),
        ],
      ),
    );
  }

  Future<void> _scheduleDailyNotification(int hour, int minute) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'hej tutaj randka malzenska',
        'zerknij na nowe ficzery, notyfikacji poki co nie da sie wylaczyc jak sie ustawi raz',
        _nextInstanceOfDate(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id2',
              'daily notification channel name2',
              'daily notification description2'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  tz.TZDateTime _nextInstanceOfDate(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: StepDrawer(2, widget._user)),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Ustawienia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: notification(),
      ),
    );
  }
}
