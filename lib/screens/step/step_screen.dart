import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/models/step.dart';
import 'package:randka_malzenska/models/sub_step.dart';
import 'package:randka_malzenska/screens/content/content_screen.dart';
import 'package:randka_malzenska/screens/home.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

import 'package:randka_malzenska/shared/button/image_button_with_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepScreen extends StatefulWidget {
  final User user;

  StepScreen(this.user);

  @override
  _StepScreenState createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<CourseStep>?>? courseSteps;
  Future<List<SubStep>?>? subSteps;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    courseSteps = connectionService.getUserSteps(widget.user.uid);

    _initializePreferences().whenComplete(() {
      setState(() {
        int stepNumber = prefs.getInt(PreferencesKey.userStepNumber) ?? 1;
        subSteps =
            connectionService.getUserSubSteps(stepNumber, widget.user.uid);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseStep>?>(
      future: courseSteps,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                title: AppBarStepList(snapshot.data, _changeStep, prefs,
                    prefs.getInt(PreferencesKey.userStepNumber) ?? 1),
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Home();
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.list,
                      size: 35,
                      color: Colors.white,
                    )),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.card_giftcard,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_outline,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.black,
              body: Center(child: stepBody(subSteps, widget.user.uid)));
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "Zapraszamy później :)",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
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

  Widget stepBody(Future<List<SubStep>?>? futureSubSteps, String firebaseId) {
    return FutureBuilder<List<SubStep>?>(
        future: futureSubSteps,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Text(
                'Brak zawartości dla dnia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              );
            } else {
              List<SubStep> awaitedSubSteps = snapshot.data!;
              List<int>? positions =
                  awaitedSubSteps.map((e) => e.position).toList();
              positions.sort();
              int lastPosition = positions.last;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...(snapshot.data!).map((subStep) {
                    return ImageButtonWithText(
                        _assetName(subStep.name),
                        () => {
                              _isAvailable(subStep.position, snapshot.data!)
                                  ? loadContent(
                                      subStep,
                                      subStep.position == lastPosition,
                                      firebaseId)
                                  : () {}
                            },
                        subStep.label,
                        subStep.done ?? false,
                        _isAvailable(subStep.position, snapshot.data!));
                  }).toList()
                ],
              );
            }
          } else {
            return Text('waiting');
          }
        });
  }

  bool _isAvailable(int position, List<SubStep> substeps) {
    if (position == 0) {
      return true;
    }
    SubStep previousSubstep =
        substeps.firstWhere((element) => element.position == position - 1);
    if (previousSubstep.done!) {
      return true;
    } else {
      return false;
    }
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

  void loadContent(SubStep subStep, bool isLast, String firebaseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ContentScreen(subStep.id, firebaseId, subStep.label, isLast,
              subStep.step, subStep.done!, _refresh);
        },
      ),
    );
  }

  _refresh() async {
    setState(() {
      subSteps = connectionService.getUserSubSteps(
          prefs.getInt(PreferencesKey.userStepNumber) ?? 1, widget.user.uid);
    });
  }

  _changeStep() async {
    setState(() {
      int stepNumber = prefs.getInt(PreferencesKey.userStepNumber) ?? 1;
      subSteps = connectionService.getUserSubSteps(stepNumber, widget.user.uid);
    });
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}

class AppBarStepList extends StatefulWidget {
  final List<CourseStep>? steps;
  final VoidCallback _changeStep;
  final SharedPreferences _prefs;
  final int _stepNumber;

  AppBarStepList(this.steps, this._changeStep, this._prefs, this._stepNumber);

  @override
  _AppBarStepListState createState() => _AppBarStepListState();
}

class _AppBarStepListState extends State<AppBarStepList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 52,
      child: Theme(
        data: Theme.of(context).copyWith(
          cardColor: Colors.black,
        ),
        child: widget.steps != null
            ? PopupMenuButton(
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
                    child: ExpandStepButton(widget.steps!, widget._prefs),
                  ),
                ),
                itemBuilder: (context) => [
                  ...widget.steps!.map((step) {
                    return PopupMenuItem(
                      child: Text(
                        step.stepName,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      value: step,
                    );
                  }).toList()
                ],
                onSelected: (value) {
                  CourseStep step = value as CourseStep;
                  if (widget._stepNumber != step.stepNumber) {
                    widget._prefs
                        .setInt(PreferencesKey.userStepNumber, step.stepNumber);
                    widget._changeStep();
                  }
                },
              )
            : SizedBox(),
      ),
    );
  }
}

class ExpandStepButton extends StatelessWidget {
  final List<CourseStep> steps;
  final SharedPreferences prefs;
  ExpandStepButton(this.steps, this.prefs);

  @override
  Widget build(BuildContext context) {
    int stepNumber = prefs.getInt(PreferencesKey.userStepNumber) ?? 1;
    CourseStep currentStep =
        steps.firstWhere((element) => element.stepNumber == stepNumber);
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
            text: currentStep.stepName,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
