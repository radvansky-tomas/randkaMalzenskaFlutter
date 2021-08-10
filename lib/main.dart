import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/registration/registry_gender_screen.dart';
import 'package:randka_malzenska/screens/video/video_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Future selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: Auth())],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            home: VideoScreen(
                'https://player.vimeo.com/external/490901113.hd.mp4?s=eb884fbcbeb5f5f751a2f1754d649a6b0b2f7628&profile_id=175',
                RegistryUserDataScreen(),
                false),
          ),
        ));
  }
}
