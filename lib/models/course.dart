class Course {
  final String name;
  final String contentDescription;
  final String videoCourse;
  final String intro;
  final String videoIntro;
  final String photo;
  final String? videoHelp;
  final String? contentNotReadydescription;
  final int ready;
  final int totalSteps;

  Course(
      {required this.name,
      required this.contentDescription,
      required this.photo,
      required this.totalSteps,
      required this.intro,
      required this.videoCourse,
      required this.videoIntro,
      this.videoHelp,
      this.contentNotReadydescription,
      required this.ready});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      contentDescription: json['content_description'],
      photo: json['photo'],
      totalSteps: json['total_steps'],
      intro: json['intro'],
      videoIntro: json['video_intro'],
      videoCourse: json['video_course'],
      videoHelp: json['video_help'],
      contentNotReadydescription: json['content_no_ready_description'],
      ready: json['ready'],
    );
  }
}
