import 'package:randka_malzenska/models/sub_step.dart';

class CourseStep {
  final int stepNumber;
  final String stepName;
  final String? content;
  final List<SubStep> subSteps;

  CourseStep(
      {required this.stepNumber,
      required this.stepName,
      required this.subSteps,
      this.content});

  factory CourseStep.fromJson(Map<String, dynamic> json) {
    List<dynamic> subSteps = json['sub_steps'];
    List<SubStep> subStepList = [];
    subSteps.forEach((subStep) {
      subStepList.add(SubStep.fromJson(subStep));
    });
    return CourseStep(
      stepNumber: json['position'],
      stepName: json['name'],
      content: json['content'],
      subSteps: subStepList,
    );
  }
}
