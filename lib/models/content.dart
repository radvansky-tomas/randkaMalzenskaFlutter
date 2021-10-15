class Content {
  final int subStep;
  final String label;
  final String title;
  final String? image;
  final String value;
  final int position;
  final String type;
  final String? videoSubtitle;

  Content(
      {required this.subStep,
      required this.label,
      required this.title,
      this.image,
      required this.value,
      required this.position,
      required this.type,
      this.videoSubtitle});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
        subStep: json['sub_step'],
        label: json['label'],
        title: json['title'],
        image: json['image'],
        value: json['value'],
        position: json['position'],
        type: json['type'],
        videoSubtitle: json['video_subtitle']);
  }
}
