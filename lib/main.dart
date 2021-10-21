import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/auth_screen.dart';
import 'package:randka_malzenska/services/notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
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
            theme: ThemeData(
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: AuthScreen()),
      ),
    );
  }
}
