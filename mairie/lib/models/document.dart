// lib/models/document.dart

class Document {
  final int id;
  final String title;
  final String content;

  Document({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}