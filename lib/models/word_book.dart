class WordBook {
  final String id;
  final String title;
  final String wordsUrl;
  final String author;

  WordBook({
    required this.id,
    required this.title,
    required this.wordsUrl,
    required this.author,
  });

  factory WordBook.fromJson(Map<String, dynamic> json) {
    return WordBook(
      id: json['id'],
      title: json['title'],
      wordsUrl: json['wordsUrl'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'wordsUrl': wordsUrl,
      'author': author,
    };
  }
}