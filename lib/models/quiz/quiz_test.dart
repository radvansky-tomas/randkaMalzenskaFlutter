import 'package:randka_malzenska/models/quiz/quiz_grade.dart';
import 'package:randka_malzenska/models/quiz/quiz_question.dart';

class QuizTest {
  final int id;
  final String name;
  final String description;
  final String? image;
  final int answersCount;
  final String type;
  final List<QuizQuestion> questions;
  final List<QuizGrade> grades;

  QuizTest({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.answersCount,
    required this.type,
    required this.questions,
    required this.grades,
  });

  factory QuizTest.fromJson(Map<String, dynamic> json) {
    List<dynamic> grades = json['grades'];
    List<QuizGrade> gradeList = [];
    grades.forEach((grade) {
      gradeList.add(QuizGrade.fromJson(grade));
    });
    List<dynamic> questions = json['questions'];
    List<QuizQuestion> questionList = [];
    questions.forEach((question) {
      questionList.add(QuizQuestion.fromJson(question));
    });
    return QuizTest(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        answersCount: json['answers_count'],
        type: json['type'],
        questions: questionList,
        grades: gradeList);
  }
}
