class Camera {
  final int position;
  final String? value;
  final String? localPath;

  Camera({required this.position, this.value, this.localPath});

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      position: json['camera_position'],
      value: json['value'],
    );
  }
}
