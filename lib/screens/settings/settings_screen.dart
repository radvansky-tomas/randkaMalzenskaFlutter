import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
import 'package:randka_malzenska/services/notification/notification_service.dart';
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
  late SharedPreferences prefs;
  String? _dateTimeFormatted;
  bool? _switchValue;
  String defaultHour = '10:00';

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    _dateTimeFormatted = prefs.getString(PreferencesKey.notificationDate);
    _switchValue = prefs.getBool(PreferencesKey.notificationEnabled);
  }

  @override
  void initState() {
    super.initState();
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
    _configureLocalTimeZone();
  }

  Widget notification() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Codzienne powiadomienia',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Włączone',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  CupertinoSwitch(
                    value: _switchValue ?? false,
                    onChanged: (value) {
                      if (value == true) {
                        int hour = int.parse(
                            _dateTimeFormatted?.split(":")[0] ?? '10');
                        int minutes =
                            int.parse(_dateTimeFormatted?.split(":")[1] ?? '0');
                        NotificationService()
                            .scheduleDailyNotification(hour, minutes);
                      } else {
                        NotificationService().cancelAllNotifications();
                      }
                      setState(() {
                        _switchValue = value;
                        prefs.setBool(
                            PreferencesKey.notificationEnabled, value);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Przypomnij o godzinie:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      DatePicker.showTimePicker(context, showTitleActions: true,
                          onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        NotificationService()
                            .scheduleDailyNotification(date.hour, date.minute);
                        prefs.setString(PreferencesKey.notificationDate,
                            DateFormat('kk:mm').format(date));
                        setState(() {
                          _dateTimeFormatted = DateFormat('kk:mm').format(date);
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Text(
                      _dateTimeFormatted == null
                          ? defaultHour
                          : _dateTimeFormatted!,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: Colors.white,
          thickness: 2.0,
        )
      ],
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
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
      body: notification(),
    );
  }
}
