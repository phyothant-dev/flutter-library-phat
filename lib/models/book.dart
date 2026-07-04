class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String fileUrl;
  final String description;
  final String category;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.fileUrl,
    required this.description,
    this.category = '',
    required this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      coverUrl: json['cover_url'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover_url': coverUrl,
      'file_url': fileUrl,
      'description': description,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
