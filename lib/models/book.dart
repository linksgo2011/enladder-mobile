class Book {
  final String title;
  final String cnTitle;
  final String author;
  final String cover;
  final String difficulty;
  final String epubUrl;
  final String description;

  Book({
    required this.title,
    required this.cnTitle,
    required this.author,
    required this.cover,
    required this.difficulty,
    required this.epubUrl,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      cnTitle: json['cnTitle'],
      author: json['author'],
      cover: json['cover'],
      difficulty: json['difficulty'],
      epubUrl: json['epubUrl'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'cnTitle': cnTitle,
      'author': author,
      'cover': cover,
      'difficulty': difficulty,
      'epubUrl': epubUrl,
      'description': description,
    };
  }
}