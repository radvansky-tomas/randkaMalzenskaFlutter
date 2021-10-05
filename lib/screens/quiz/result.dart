import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/quiz/quiz_grade.dart';
import 'package:randka_malzenska/shared/html/white_html.dart';

class Result extends StatelessWidget {
  final List<String> answers;
  final List<QuizGrade> grades;
  final VoidCallback resetQuiz;
  Result(this.answers, this.resetQuiz, this.grades);

  String get gradeDescription {
    if (int.tryParse(mostPopularValue) != null) {
      return grades
          .firstWhere((element) =>
              isInRange(element.gradeRange, int.parse(mostPopularValue)))
          .description;
    } else {
      return grades
          .firstWhere((element) => element.gradeRange == mostPopularValue)
          .description;
    }
  }

  bool isInRange(String gradeRange, int value) {
    List<String> range = gradeRange.split('-');
    if (value >= int.parse(range[0]) && value <= int.parse(range[1])) {
      return true;
    } else {
      return false;
    }
  }

  String get mostPopularValue {
    var popular = Map();

    if (int.tryParse(answers.first) != null) {
      int sum = 0;
      answers.forEach((element) {
        sum = sum + int.parse(element);
      });
      return sum.toString();
    }

    answers.forEach((answer) {
      if (!popular.containsKey(answer)) {
        popular[answer] = 1;
      } else {
        popular[answer] += 1;
      }
    });
    List sortedValues = popular.values.toList()..sort();
    int popularValue = sortedValues.last;
    String answer = answers.first;
    popular.forEach((key, value) {
      if (value == popularValue) {
        answer = key;
      }
    });
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 15,
            child: WhiteHtml(gradeDescription),
          ),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 21, 74, 118),
                  minimumSize: Size(double.infinity,
                      30), // double.infinity is the width and 30 is the height
                ),
                onPressed: resetQuiz,
                child: Text(
                  'JESZCZE RAZ',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
