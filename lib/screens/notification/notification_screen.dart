import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

const String _prefKey = 'notificationDate';

class NotificationScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationScreen(this.flutterLocalNotificationsPlugin);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late SharedPreferences prefs;
  String? _dateTimeFormatted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: test(),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
    _configureLocalTimeZone();
  }

  Widget test() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _dateTimeFormatted == null ? 'ustaw godizna' : _dateTimeFormatted!,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextButton(
              onPressed: () {
                DatePicker.showTimePicker(
                  context,
                  showTitleActions: true,
                  onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  },
                  onConfirm: (date) {
                    _scheduleDailyNotification(date.hour, date.minute);
                    prefs.setString(_prefKey, DateFormat('kk:mm').format(date));
                    setState(() {
                      _dateTimeFormatted = DateFormat('kk:mm').format(date);
                    });
                  },
                  currentTime: DateTime.now(),
                );
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
    await widget.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'hej tutaj randka malzenska',
        'zerknij na nowe ficzery, notyfikacji poki co nie da sie wylaczyc jak sie ustawi raz',
        _nextInstanceOfDate(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
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

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    _dateTimeFormatted = prefs.getString(_prefKey);
  }
}
