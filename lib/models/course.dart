class Course {
  final String name;
  final String contentDescription;
  final String intro;
  final String photo;
  final int totalSteps;

  Course({
    required this.name,
    required this.contentDescription,
    required this.photo,
    required this.totalSteps,
    required this.intro,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        name: json['name'],
        contentDescription: json['content_description'],
        photo: json['photo'],
        totalSteps: json['total_steps'],
        intro: json['intro']);
  }
}
