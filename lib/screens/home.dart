import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/widgets/fluid_nav_bar.dart';

import 'account.dart';
import 'grid.dart';
import 'home copy.dart';

class Home extends StatefulWidget {
  final UserCredential userCredential;

  Home(this.userCredential);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget? _child;

  @override
  Widget build(BuildContext context) {
    Future<void> _logoutFace() async {
      await Provider.of<Auth>(context, listen: false).logout(context: context);
    }

    var displeyName = widget.userCredential.user!.displayName;
    if (displeyName == null) {
      displeyName = widget.userCredential.user!.email;
    }

    var photoUrl = widget.userCredential.user!.photoURL;
    if (photoUrl == null) {
      photoUrl =
          'https://i.wpimg.pl/730x0/m.fitness.wp.pl/4-ea52435acc6cf488e05e75c209b2bd.jpg';
    }
    return Scaffold(
      body: _child,
      backgroundColor: Color(0xFF75B7E1),
      extendBody: true,
      bottomNavigationBar: FluidNavBar(onChange: _handleNavigationChange),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = HomeContent();
          break;
        case 1:
          _child = AccountContent();
          break;
        case 2:
          _child = GridContent();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}

// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Witaj $displeyName',
//               style: TextStyle(fontSize: 35.0),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             CircleAvatar(
//               backgroundImage: NetworkImage(photoUrl),
//               radius: 60.0,
//             ),
//             SizedBox(
//               height: 100.0,
//             ),
//             TextButton(
//               child: Text('Wyloguj'),
//               onPressed: _logoutFace,
//             ),
//           ],
//         ),
//       ),
