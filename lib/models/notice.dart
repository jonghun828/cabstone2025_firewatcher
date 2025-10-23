// lib/models/notice.dart

import 'comment.dart';

class Notice {
  final int id;               // 게시글 고유 ID
  final String userName;      // 작성자 사용자 이름 (user_name)
  final String author;        // 작성자 (author)
  final String title;         // 게시글 제목
  final String content;       // 게시글 내용
  final DateTime createdAt;    // 게시글 최초 작성일시
  final DateTime modifiedAt;   // ⭐ 게시글 최종 수정일시 (화면 표시 기준)
  final List<Comment> comments; // 해당 게시글에 달린 댓글 리스트
  final bool isMajor;         // 주요 공지 여부 (important)

  const Notice({
    required this.id,
    required this.userName,
    required this.author,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
    this.comments = const [],
    required this.isMajor,
  });

  // JSON 응답을 Notice 객체로 변환하는 팩토리 메서드
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as int,
      userName: json['user_name'] as String,
      author: json['author'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String), // ⭐ modifiedAt 파싱
      isMajor: json['important'] as bool,
      // 댓글 JSON 리스트를 Comment 모델 리스트로 변환
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
    );
  }

  Notice copyWith({
    int? id,
    String? userName,
    String? title,
    String? content,
    String? author,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<Comment>? comments,
    bool? isMajor,
  }) {
    return Notice(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      author: author ?? this.author,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      comments: comments ?? this.comments,
      isMajor: isMajor ?? this.isMajor,
    );
  }
}