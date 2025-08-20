import 'comment.dart';

class Notice {
  final String id;              // 게시글 고유 ID
  final String title;           // 게시글 제목
  final String content;         // 게시글 내용
  final String author;          // 작성자
  final DateTime date;          // 작성일시
  final List<Comment> comments; // 해당 게시글에 달린 댓글 리스트

  const Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    this.comments = const [],
  });

  Notice copyWith({
    String? id,
    String? title,
    String? content,
    String? author,
    DateTime? date,
    List<Comment>? comments,
  }) {
    return Notice(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      date: date ?? this.date,
      comments: comments ?? this.comments,
    );
  }
}