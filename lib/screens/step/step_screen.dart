import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randka_malzenska/models/course.dart';
import 'package:randka_malzenska/models/step.dart';
import 'package:randka_malzenska/models/sub_step.dart';
import 'package:randka_malzenska/screens/content/content_screen.dart';
import 'package:randka_malzenska/screens/info/course_description.dart';
import 'package:randka_malzenska/screens/photo/photo_presentation_screen.dart';
import 'package:randka_malzenska/screens/quiz/intro.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
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
  bool _introWatched = false;
  late int stepNumber;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    courseSteps = connectionService.getUserSteps(widget.user.uid);
    courseSteps?.then((awaitedCourseSteps) => {
          stepNumber = awaitedCourseSteps?.last.stepNumber ?? 1,
          subSteps = connectionService.getUserSubSteps(
              awaitedCourseSteps?.last.stepNumber ?? 1, widget.user.uid)
        });

    _initializePreferences().whenComplete(() {
      setState(() {});
    });
  }

  Future<Course?> getCourse() {
    return connectionService.getCourse();
  }

  String? getStepContent(List<CourseStep> courseSteps) {
    return courseSteps.firstWhere(
        (courseStep) => courseStep.stepNumber == stepNumber, orElse: () {
      return courseSteps.first;
    }).content;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseStep>?>(
      future: courseSteps,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data!.length == 0) {
          return Scaffold(
            backgroundColor: Colors.black,
            drawer: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: StepDrawer(0, widget.user)),
            appBar: AppBar(
              title: Text(
                "Randka małżeńska",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey[900],
            ),
            body: Center(
              child: Text(
                "Brak danych dla dni kursu :(",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<CourseStep> courseSteps = snapshot.data!;
          String? content = getStepContent(courseSteps);
          return !_introWatched && content != null
              ? Intro(content, _setIntroWatched, 'Zaczynamy')
              : Scaffold(
                  drawer: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.black,
                      ),
                      child: StepDrawer(0, widget.user)),
                  appBar: AppBar(
                    backgroundColor: Colors.grey[900],
                    title: AppBarStepList(
                        courseSteps.reversed.toList(), _changeStep, stepNumber),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PhotoPresentationScreen(widget.user);
                                },
                              ),
                            );
                          },
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CourseDescriptionScreen();
                                },
                              ),
                            );
                          },
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
                  body: Center(
                      child: stepBody(subSteps, widget.user.uid, stepNumber)));
        } else if (snapshot.hasError) {
          log(snapshot.error.toString());
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

  Widget stepBody(Future<List<SubStep>?>? futureSubSteps, String firebaseId,
      int stepPosition) {
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
            } else if (snapshot.data!.length == 1) {
              return ContentScreen(
                  snapshot.data![0], firebaseId, true, _refresh, stepPosition);
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
                                      firebaseId,
                                      stepPosition,
                                    )
                                  : () {}
                            },
                        subStep.label,
                        subStep.done ?? false,
                        _isAvailable(subStep.position, snapshot.data!));
                  }).toList()
                ],
              );
            }
          } else if (snapshot.hasError) {
            log('error ${snapshot.error.toString()}');
            return Text('wystąpił błąd : (',
                style: TextStyle(color: Colors.white));
          } else {
            return Text('ładowanie', style: TextStyle(color: Colors.white));
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

  void loadContent(
      SubStep subStep, bool isLast, String firebaseId, int stepPosition) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ContentScreen(
              subStep, firebaseId, isLast, _refresh, stepPosition);
        },
      ),
    );
  }

  _refresh() async {
    setState(() {
      subSteps = connectionService.getUserSubSteps(stepNumber, widget.user.uid);
    });
  }

  _setIntroWatched() {
    setState(() {
      _introWatched = true;
    });
  }

  _changeStep(int changedStepNumber) async {
    setState(() {
      _introWatched = false;
      stepNumber = changedStepNumber;
      subSteps =
          connectionService.getUserSubSteps(changedStepNumber, widget.user.uid);
    });
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}

class AppBarStepList extends StatefulWidget {
  final List<CourseStep> steps;
  final Function _changeStep;
  final int _stepNumber;

  AppBarStepList(this.steps, this._changeStep, this._stepNumber);

  @override
  _AppBarStepListState createState() => _AppBarStepListState();
}

class _AppBarStepListState extends State<AppBarStepList> {
  @override
  Widget build(BuildContext context) {
    final String stepTitle = widget.steps.firstWhere(
        (element) => element.stepNumber == widget._stepNumber, orElse: () {
      return CourseStep(stepNumber: 0, stepName: 'Dzień', subSteps: []);
    }).stepName;
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
                child: ExpandStepButton(stepTitle),
              ),
            ),
            itemBuilder: (context) => [
              ...widget.steps.map((step) {
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
                widget._changeStep(step.stepNumber);
              }
            },
          )),
    );
  }
}

class ExpandStepButton extends StatelessWidget {
  final String stepName;
  ExpandStepButton(this.stepName);

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
            text: stepName,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
