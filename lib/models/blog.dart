class Blog {
  final String title;
  final String subtitle;
  final String content;
  final String? author;
  final String image;
  final bool? active;
  final String? createdDate;

  Blog({
    required this.title,
    required this.subtitle,
    required this.content,
    this.author,
    required this.image,
    this.active,
    this.createdDate,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'],
      subtitle: json['subtitle'],
      content: json['content'],
      author: json['author'],
      image: json['image'],
      active: json['active'],
      createdDate: json['created_at'],
    );
  }
}
