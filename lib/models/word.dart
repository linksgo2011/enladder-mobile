class Word {
  final String word;
  final String definition;
  final String phonetic;
  final String mnemonic;

  Word({
    required this.word,
    required this.definition,
    required this.phonetic,
    required this.mnemonic,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      definition: json['definition'],
      phonetic: json['phonetic'],
      mnemonic: json['mnemonic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'definition': definition,
      'phonetic': phonetic,
      'mnemonic': mnemonic,
    };
  }
}
