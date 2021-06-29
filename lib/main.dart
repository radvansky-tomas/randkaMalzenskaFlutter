import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/home.dart';
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
        providers: [ChangeNotifierProvider.value(value: Auth())],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            home: auth.isAuth != null ? Home(auth.isAuth!) : AuthScreen(),
          ),
        ));
  }
}
