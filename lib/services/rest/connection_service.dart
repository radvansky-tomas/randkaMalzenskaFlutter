import 'dart:convert';

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
      Uri.parse('$baseAddress/CourseStep/'),
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
      throw Exception('Failed to load album');
    }
  }
}
