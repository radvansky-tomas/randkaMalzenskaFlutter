class Camera {
  final int stepPosition;
  final int contentPosition;
  final String? value;
  final String? localPath;

  Camera(
      {required this.stepPosition,
      required this.contentPosition,
      this.value,
      this.localPath});

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      stepPosition: json['step_position'],
      contentPosition: json['content_position'],
      value: json['value'],
    );
  }
}
