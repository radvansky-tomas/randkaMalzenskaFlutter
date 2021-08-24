import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/quiz/quiz_test.dart';
import 'package:randka_malzenska/screens/quiz/quiz.dart';
import 'package:randka_malzenska/screens/quiz/result.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

class QuizScreen extends StatefulWidget {
  final int _quizId;
  QuizScreen(this._quizId);
  @override
  State<StatefulWidget> createState() {
    return _QuizScreenState();
  }
}

class _QuizScreenState extends State<QuizScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<QuizTest?>? _quizTest;
  var _questionIndex = 0;
  // var _totalScore = 0;
  List<String> _answers = [];

  @override
  void initState() {
    super.initState();
    _quizTest = connectionService.getQuizTest(widget._quizId);
  }

  void _answerQuestion(String answer, int questionsNumber) {
    _answers.add(answer);
    if (_questionIndex < questionsNumber) {
      setState(() {
        _questionIndex += 1;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _answers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuizTest?>(
        future: _quizTest,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  'Coś poszło nie tak :(',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.grey[900],
                  title: Text(
                    'Quiz',
                    style: TextStyle(color: Colors.white),
                  )),
              backgroundColor: Colors.black,
              body: _questionIndex < snapshot.data!.questions.length
                  ? Quiz(
                      quizTest: snapshot.data!,
                      answerQuestion: _answerQuestion,
                      questionIndex: _questionIndex)
                  : Result(_answers, _resetQuiz),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  'Zajrzyj później ;)',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
        });
  }
}
