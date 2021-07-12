import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/widgets/fluid_nav_bar.dart';

import 'account.dart';
import 'grid.dart';
import 'home_content.dart';

class Home extends StatefulWidget {
  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget? _child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _child == null ? HomeContent() : _child,
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
