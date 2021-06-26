class Course {
  final String name;
  final int id;
  final String description;
  final String photo;
  final int totalSteps;
  final List conditions;

  Course({
    required this.name,
    required this.id,
    required this.description,
    required this.photo,
    required this.totalSteps,
    required this.conditions,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      id: json['id'],
      description: json['description'],
      photo: json['photo'],
      totalSteps: json['totalSteps'],
      conditions: json['conditions'],
    );
  }
}
