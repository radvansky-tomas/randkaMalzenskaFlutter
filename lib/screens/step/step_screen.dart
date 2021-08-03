import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/sub_step.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/button/custom_image_button.dart';

class StepScreen extends StatefulWidget {
  @override
  _StepScreenState createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  ConnectionService connectionService = new ConnectionService();
  late List<SubStep>? subSteps = [];

  @override
  void initState() {
    super.initState();
    connectionService
        .getSubstepsFromStep(0)
        .then((value) => subSteps = value)
        .whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: subSteps != null && subSteps!.length == 3
          ? Center(child: sampleBody())
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget sampleBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...(subSteps!).map((subStep) {
          return CustomImageButton(subStep, () => test(subStep));
        }).toList()
      ],
    );
  }

  void test(SubStep subStep) {
    print(subStep.label);
  }
}
