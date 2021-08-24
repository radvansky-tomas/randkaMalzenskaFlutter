import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/quiz/quiz_test.dart';
import 'package:randka_malzenska/screens/quiz/answer.dart';
import 'package:randka_malzenska/screens/quiz/question.dart';

class Quiz extends StatelessWidget {
  final QuizTest quizTest;
  final int questionIndex;
  final Function answerQuestion;

  Quiz(
      {required this.quizTest,
      required this.answerQuestion,
      required this.questionIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          quizTest.questions[questionIndex].content,
        ),
        ...(quizTest.questions[questionIndex].answers).map((answer) {
          return Answer(answer.content,
              () => answerQuestion(answer.weight, quizTest.questions.length));
        }).toList()
      ],
    );
  }
}
