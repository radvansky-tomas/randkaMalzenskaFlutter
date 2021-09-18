import 'dart:convert';

import 'package:randka_malzenska/models/blog.dart';
import 'package:randka_malzenska/models/camera.dart';
import 'package:randka_malzenska/models/content.dart';
import 'package:randka_malzenska/models/course.dart';
import 'package:randka_malzenska/models/http_exception.dart';
import 'package:randka_malzenska/models/quiz/quiz_test.dart';
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

  Future<List<CourseStep>?> getUserSteps(String firebaseId) async {
    final response = await http.get(
      Uri.parse('$baseAddress/course_steps/step_list/?firebase_id=$firebaseId'),
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
    } else if (response.statusCode == 500 &&
        response.body.contains('User matching query does not exist')) {
      //user does not exists, should be created
      return [];
    } else {
      throw Exception('Failed to load steps: ' + response.body);
    }
  }

  Future<List<Content>?> getUserStepContent(
      int subStepId, String firebaseId) async {
    // http://162.55.217.235:8081/api/course-content/substeps/?firebase_id=fasga721412&substep=1
    final response = await http.get(
      Uri.parse(
          '$baseAddress/course_content/substeps/?firebase_id=$firebaseId&substep_id=$subStepId'),
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

  Future increaseSubStepProgress(int stepPosition, String firebaseId) async {
    final response = await http.put(
      Uri.parse(
          '$baseAddress/user/progress_substep/?firebase_id=$firebaseId&step_number=$stepPosition'),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw HttpException('Błąd: ' + response.body);
    }
  }

  Future<bool> registerUser(
      String email, String firebaseId, List<String> attributes) async {
    Map data = {
      "attribute": {"value": attributes},
      "user": {"email": email, "firebase_id": firebaseId}
    };

    String body = json.encode(data);
    final response = await http.post(Uri.parse('$baseAddress/user_attribute/'),
        headers: requestHeaders, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw HttpException('Błąd: ' + response.body);
    }
  }

  Future<List<SubStep>?> getUserSubSteps(
      int stepNumber, String firebaseId) async {
    final response = await http.get(
      Uri.parse(
          '$baseAddress/course_step/user_substeps/?firebase_id=$firebaseId&step_number=$stepNumber'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<SubStep> stepList = [];
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> contents = map['results'];
      contents.forEach((content) {
        stepList.add(SubStep.fromJson(content));
      });
      return stepList;
    } else {
      throw HttpException('Błąd poczas pobierania zawartości substepow');
    }
  }

  Future increaseStepProgress(int stepPosition, String firebaseId) async {
    final response = await http.put(
      Uri.parse(
          '$baseAddress/user/progress_step/?firebase_id=$firebaseId&step_number=$stepPosition'),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw HttpException('Błąd: ' + response.body);
    }
  }

  Future<QuizTest?> getQuizTest(int quizId) async {
    final response = await http.get(
      Uri.parse('$baseAddress/tests/$quizId/'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      return QuizTest.fromJson(map['results']);
    } else {
      throw HttpException('Błąd poczas pobierania zawartości quizu');
    }
  }

  Future<List<Blog>?> getBlogs() async {
    final response = await http.get(
      Uri.parse('$baseAddress/blogs'),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      List<Blog> blogList = [];
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> blogs = map['results'];
      blogs.forEach((blog) {
        blogList.add(Blog.fromJson(blog));
      });
      return blogList;
    } else {
      throw HttpException('Failed to load blogs');
    }
  }

  Future<List<Camera>?> getCameras(String firebaseId) async {
    final response = await http.get(
      Uri.parse('$baseAddress/course_content/camera/?firebase_id=$firebaseId'),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      List<Camera> cameraList = [];
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> cameras = map['results'];
      cameras.forEach((camera) {
        cameraList.add(Camera.fromJson(camera));
      });
      return cameraList;
    } else {
      throw HttpException('Failed to load cameras');
    }
  }

  Future<Course?> getCourse() async {
    final response = await http.get(
      Uri.parse('$baseAddress/course/'),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
      return Course.fromJson(map['results'][0]);
    } else {
      throw HttpException('Failed to load course');
    }
  }
}
