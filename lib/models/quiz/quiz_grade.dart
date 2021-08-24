class QuizGrade {
  final int id;
  final String description;
  final String gradeRange;
  final String url;

  QuizGrade({
    required this.id,
    required this.description,
    required this.gradeRange,
    required this.url,
  });

  factory QuizGrade.fromJson(Map<String, dynamic> json) {
    return QuizGrade(
      id: json['test'],
      description: json['description'],
      gradeRange: json['grade_range'],
      url: json['url'],
    );
  }
}
