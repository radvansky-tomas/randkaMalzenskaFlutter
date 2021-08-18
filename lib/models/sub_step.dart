class SubStep {
  final int step;
  final String name;
  final String label;
  final String photo;
  final bool? visibleContainer;
  final bool? horizontalOrientation;
  final bool? alwaysEnabled;
  final int position;
  final int id;

  SubStep({
    required this.step,
    required this.name,
    required this.label,
    required this.photo,
    required this.visibleContainer,
    required this.horizontalOrientation,
    required this.alwaysEnabled,
    required this.position,
    required this.id,
  });

  factory SubStep.fromJson(Map<String, dynamic> json) {
    return SubStep(
      step: json['step'],
      name: json['name'],
      label: json['label'],
      photo: json['photo'],
      visibleContainer: json['visibleContainer'],
      horizontalOrientation: json['horizontalOrientation'],
      alwaysEnabled: json['alwaysEnabled'],
      position: json['position'],
      id: json['id'],
    );
  }
}