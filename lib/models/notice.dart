import 'comment.dart';

class Notice {
  final int id;
  final String author;
  final String title;
  final String content;
  final bool isMajor;
  final DateTime modifiedAt;
  final List<Comment> comments;

  Notice({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.isMajor,
    required this.modifiedAt,
    required this.comments,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    final List<dynamic> commentList = json['comments'] ?? [];
    final List<Comment> parsedComments = commentList
        .map((commentJson) => Comment.fromJson(commentJson))
        .toList();

    parsedComments.sort((a, b) => b.date.compareTo(a.date));

    return Notice(
      id: json['id'] as int,
      author: json['author'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      isMajor: json['important'] as bool,
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      comments: parsedComments,
    );
  }

  Notice copyWith({
    List<Comment>? comments,
  }) {
    return Notice(
      id: id,
      author: author,
      title: title,
      content: content,
      isMajor: isMajor,
      modifiedAt: modifiedAt,
      comments: comments ?? this.comments,
    );
  }
}