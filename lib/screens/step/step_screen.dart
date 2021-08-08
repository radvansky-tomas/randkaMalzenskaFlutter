import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randka_malzenska/models/step.dart';
import 'package:randka_malzenska/models/sub_step.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

import 'package:randka_malzenska/shared/button/image_button_with_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefKey = 'selectedStep';

class StepScreen extends StatefulWidget {
  @override
  _StepScreenState createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<CourseStep>?>? steps;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    steps = connectionService.getStepsWithSubSteps();
    _initializePreferences().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseStep>?>(
      future: steps,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              title: AppBarStepList(snapshot.data!),
              leading: Icon(
                Icons.list,
                size: 35,
                color: Colors.white,
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.card_giftcard,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Icon(
                    Icons.favorite_outline,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black,
            body: Center(
              child: sampleBody(snapshot.data![0].subSteps),
            ),
          );
        } else
          return Scaffold(
            backgroundColor: Colors.black,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...(awaitedSubSteps!).map((subStep) {
          return ImageButtonWithText(
            _assetName(subStep.name),
            () => test(subStep),
            subStep.label,
            false,
          );
        }).toList()
      ],
    );
  }

  String _assetName(String stepName) {
    if (stepName == 'OSĄDZIĆ') {
      return 'osadzic';
    } else if (stepName == 'WIDZIEĆ') {
      return 'widziec';
    } else {
      return 'dzialac';
    }
  }

  void test(SubStep subStep) {
    final String krok = subStep.label;
    final snackBar = SnackBar(
      content: Text('Kliknięto $krok'),
      duration: Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // connectionService.getStepsWithSubSteps().then((value) => print(value![0]));
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}

class AppBarStepList extends StatelessWidget {
  final List<CourseStep> steps;

  AppBarStepList(this.steps);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 52,
      child: Theme(
        data: Theme.of(context).copyWith(
          cardColor: Colors.black,
        ),
        child: PopupMenuButton(
            icon: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  // color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: BoxConstraints.expand(),
                child: ExpandStepButton(steps),
              ),
            ),
            itemBuilder: (context) => [
                  ...steps.map((step) {
                    return PopupMenuItem(
                        child: Text(
                      step.stepName,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ));
                  }).toList()
                ]),
      ),
    );
  }
}

class ExpandStepButton extends StatelessWidget {
  final List<CourseStep> steps;
  ExpandStepButton(this.steps);

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 7, 2),
              child: Icon(
                Icons.calendar_today,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
          TextSpan(
            text: steps[0].stepName,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
