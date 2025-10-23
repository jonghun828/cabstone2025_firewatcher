// lib/models/comment.dart

class Comment {
  final int id;        // 댓글 ID
  final String author;    // 댓글 작성자
  final String content;   // 댓글 내용
  final DateTime date;    // 댓글 작성일시

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.date,
  });

  // JSON 데이터를 Comment 객체로 변환하는 팩토리 메서드
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      // ID는 백엔드 응답에 따라 int로 파싱
      id: json['id'] as int,
      author: json['author'] as String,
      content: json['content'] as String,
      // 'createdAt' 필드를 DateTime으로 파싱
      date: DateTime.parse(json['createdAt'] as String),
    );
  }
}