import 'package:flutter/material.dart';
import 'comment.dart';

class Notice {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime date;
  final List<Comment> comments;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    this.comments = const [],
  });

  // comments 리스트를 업데이트할 때 사용할 copyWith 메서드 (불변성 유지)
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