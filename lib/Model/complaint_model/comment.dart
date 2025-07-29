import 'author.dart';

class Comment {
  String? id;
  String? content;
  String? type;
  DateTime? createdAt;
  Author? author;

  Comment({this.id, this.content, this.type, this.createdAt, this.author});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as String?,
        content: json['content'] as String?,
        type: json['type'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        author: json['author'] == null
            ? null
            : Author.fromJson(json['author'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'type': type,
        'createdAt': createdAt?.toIso8601String(),
        'author': author?.toJson(),
      };
}
