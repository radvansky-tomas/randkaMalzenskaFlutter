import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:randka_malzenska/blocs/auth_bloc.dart';
import 'package:randka_malzenska/providers/auth.dart';

import 'dart:convert';
import 'models/course.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          Provider(create: (context) => AuthBloc()),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            home: auth.isAuth ? MyHomePage() : AuthScreen(),
            routes: {
              MyHomePage.routeName: (ctx) => MyHomePage(),
            },
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/homePage';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(onPressed: fetchAlbum, child: const Text('Kliknij mie')),
        ],
      ),
    );
  }
}

void fetchAlbum() async {
  final response =
      await http.get(Uri.parse('http://168.119.117.111:8081/api/v1/courses'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var course = Course.fromJson(jsonDecode(response.body)[0]);
    List courses = jsonDecode(response.body);
    courses.forEach((element) {
      print(Course.fromJson(element).description);
    });
    print(course.description);
    // return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
