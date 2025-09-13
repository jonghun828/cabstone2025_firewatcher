class Comment {
  final String id;        // 댓글  ID
  final String author;    // 댓글 작성자
  final String content;   // 댓글 내용
  final DateTime date;    // 댓글 작성일시

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.date,
  });
}