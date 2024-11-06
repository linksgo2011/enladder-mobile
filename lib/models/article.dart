class Article {
  final String id;
  final String title;
  final String cnTitle;
  final DateTime createAt;
  final String fileUrl;

  Article({
    required this.id,
    required this.title,
    required this.cnTitle,
    required this.createAt,
    required this.fileUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      cnTitle: json['cnTitle'],
      createAt: DateTime.parse(json['createAt']),
      fileUrl: json['fileUrl'],
    );
  }
}