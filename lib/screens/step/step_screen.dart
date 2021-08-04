import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/sub_step.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/button/custom_image_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefKey = 'selectedStep';

class StepScreen extends StatefulWidget {
  @override
  _StepScreenState createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<SubStep>?>? subSteps;
  late SharedPreferences prefs;
  int? _index;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    subSteps = connectionService.getSubstepsFromStep(0);
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubStep>?>(
      future: connectionService.getSubstepsFromStep(0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  leadingWidth: 150,
                  leading: PopupMenuButton(
                      icon: Text('Dzień 1'),
                      itemBuilder: (context) => [
                            ...snapshot.data!.map((e) {
                              return PopupMenuItem(
                                  child: Text(
                                e.label,
                                style: TextStyle(color: Colors.black),
                              ));
                            }).toList()
                          ]),
                  actions: <Widget>[],
                ),
                backgroundColor: Colors.blue,
                body: Center(
                  child: sampleBody(snapshot.data),
                ),
              ),
              Visibility(
                visible: _visible,
                child: new Container(
                  height: 100.0,
                  width: 100.0,
                  alignment: Alignment.center,
                  color: Colors.redAccent,
                  child: Text('Hello'),
                ),
              ),
            ],
          );
        } else
          return Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
      },
    );
  }

  Widget sampleBody(List<SubStep>? awaitedSubSteps) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...(awaitedSubSteps!).map((subStep) {
          return CustomImageButton(subStep, () => test(subStep));
        }).toList()
      ],
    );
  }

  void showContainer() {
    setState(() {
      if (_visible) {
        _visible = false;
      } else {
        _visible = true;
      }
    });
  }

  void test(SubStep subStep) {
    print(subStep.label);
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    _index = prefs.getInt(_prefKey);
  }
}
