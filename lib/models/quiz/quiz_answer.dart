class QuizAnswer {
  final int id;
  final String content;
  final String weight;

  QuizAnswer({
    required this.id,
    required this.content,
    required this.weight,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      id: json['question'],
      content: json['content'],
      weight: json['weight'],
    );
  }
}
