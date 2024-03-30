class Quote {
  String quote;
  String author;
  String category;

  Quote({
    required this.quote,
    required this.author,
    required this.category,
  });

  factory Quote.fromMap(Map data) => Quote(
        quote: data["quote"],
        author: data["author"],
        category: data["category"],
      );

  Map<String, dynamic> toMap() => {
        "quote": quote,
        "author": author,
        "category": category,
      };
}
