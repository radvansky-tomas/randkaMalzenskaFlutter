import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/auth_screen.dart';
import 'package:randka_malzenska/screens/registration/registry_gender_screen.dart';
import 'package:randka_malzenska/screens/step/step_course_screen.dart';
import 'package:randka_malzenska/screens/video/video_screen.dart';
import 'package:randka_malzenska/shared/SizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = Tween<Offset>(
      begin: Offset(-1.5, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    _initializePreferences().whenComplete(() {
      setState(() {});
    });

    Future<void>.delayed(Duration(milliseconds: 500), () {
      animationController.forward();
    });
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<User?> getUser() async {
    var authBloc = Provider.of<Auth>(context, listen: false);
    await Future.delayed(const Duration(seconds: 2));
    return authBloc.currentUser.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    Image.asset('assets/images/splashscreen2_bg.jpg'),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SlideTransition(
                        position: animation,
                        child: Image.asset('assets/images/splashscreen2.png'),
                      ),
                    )
                  ],
                )),
          );
        } else {
          // Loading is done, return the app:
          bool introWatched =
              prefs.getBool(PreferencesKey.introWatched) ?? false;
          User? user = snapshot.data;
          String relationShipStatus = prefs.getString(
                  user?.uid ?? '123' + PreferencesKey.userRelationshipStatus) ??
              '';
          return MaterialApp(
            home: user != null && relationShipStatus != ''
                ? StepCourseScreen(user)
                : introWatched
                    ? AuthScreen()
                    : VideoScreen(
                        'https://player.vimeo.com/external/490901113.hd.mp4?s=eb884fbcbeb5f5f751a2f1754d649a6b0b2f7628&profile_id=175',
                        RegistryUserDataScreen(prefs),
                        false,
                      ),
          );
        }
      },
    );
  }
}

// class Splash extends StatefulWidget {
//   @override
//   _SplashState createState() => _SplashState();
// }

// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  

//   @override
//   void initState() {
//     super.initState();
//     animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//     animation = Tween<Offset>(
//       begin: Offset(-1.5, 0.0),
//       end: Offset(0.0, 0.0),
//     ).animate(CurvedAnimation(
//       parent: animationController,
//       curve: Curves.fastLinearToSlowEaseIn,
//     ));

//     Future<void>.delayed(Duration(milliseconds: 500), () {
//       animationController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: [
//             Image.asset('assets/images/splashscreen2_bg.jpg'),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: SlideTransition(
//                 position: animation,
//                 child: Image.asset('assets/images/splashscreen2.png'),
//               ),
//             )
//           ],
//         ));
//   }
// }
