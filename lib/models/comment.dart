// lib/models/comment.dart

class Comment {
  final int id;
  final String author;
  final String content;
  final DateTime date; // modifiedAt을 파싱하여 사용

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.date,
  });

  // JSON 데이터를 Comment 객체로 변환
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      author: json['author'] as String,
      content: json['content'] as String,
      // 'modifiedAt' 필드를 사용하여 최종 수정일/작성일을 저장
      date: DateTime.parse(json['modifiedAt'] as String),
    );
  }

  // 객체 복사 (필요시 사용)
  Comment copyWith({
    int? id,
    String? author,
    String? content,
    DateTime? date,
  }) {
    return Comment(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}