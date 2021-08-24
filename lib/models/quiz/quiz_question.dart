import 'package:randka_malzenska/models/quiz/quiz_answer.dart';

class QuizQuestion {
  final int id;
  final String content;
  final List<QuizAnswer> answers;

  QuizQuestion({
    required this.id,
    required this.content,
    required this.answers,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<dynamic> answers = json['answers'];
    List<QuizAnswer> answerList = [];
    answers.forEach((answer) {
      answerList.add(QuizAnswer.fromJson(answer));
    });
    return QuizQuestion(
      id: json['test'],
      content: json['content'],
      answers: answerList,
    );
  }
}
