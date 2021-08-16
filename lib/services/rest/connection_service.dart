import 'dart:convert';

import 'package:randka_malzenska/models/content.dart';
import 'package:randka_malzenska/models/http_exception.dart';
import 'package:randka_malzenska/models/step.dart';
import 'package:randka_malzenska/models/sub_step.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

class ConnectionService {
  static const host = '162.55.217.235';
  static const port = '8081';
  static const suffix = 'api';
  static const baseAddress = 'http://$host:$port/$suffix';
  static const Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<List<SubStep>?> getSubstepsFromStep(int stepNumber) async {
    final response = await http.get(
      Uri.parse('$baseAddress/course-steps/'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<SubStep> substepList = [];
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> subSteps = map['results'][stepNumber]['sub_steps'];
      subSteps.forEach((subStep) {
        substepList.add(SubStep.fromJson(subStep));
      });

      return substepList;
    } else {
      throw Exception('Failed to load steps');
    }
  }

  Future<List<CourseStep>?> getStepsWithSubSteps() async {
    final response = await http.get(
      Uri.parse('$baseAddress/course-steps/'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<CourseStep> stepList = [];
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> steps = map['results'];
      steps.forEach((step) {
        stepList.add(CourseStep.fromJson(step));
      });

      return stepList;
    } else {
      throw Exception('Failed to load steps');
    }
  }

  Future<List<Content>?> getUserStepContent(
      int subStepId, String firebaseId) async {
    // http://162.55.217.235:8081/api/course-content/substeps/?firebase=fasga721412&substep=1
    final response = await http.get(
      Uri.parse(
          '$baseAddress/course-content/substeps/?firebase=$firebaseId&substep=$subStepId'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<Content> stepList = [];
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> contents = map['results'];
      contents.forEach((content) {
        stepList.add(Content.fromJson(content));
      });
      return stepList;
    } else {
      throw HttpException('Błąd poczas pobierania zawartości kroku');
    }
  }
}
