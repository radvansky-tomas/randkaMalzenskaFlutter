import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final List<String> answers;
  final VoidCallback resetQuiz;
  Result(this.answers, this.resetQuiz);

  String get resultPhrase {
    return 'Przeszedles kurs i najwiecej odpowiedzi to:' + mostPopularValue;
  }

  String get mostPopularValue {
    var popular = Map();

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
          Text(
            resultPhrase,
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          TextButton(
            child: Text('Zrestartuj'),
            onPressed: resetQuiz,
            style: TextButton.styleFrom(primary: Colors.orange),
          )
        ],
      ),
    );
  }
}
