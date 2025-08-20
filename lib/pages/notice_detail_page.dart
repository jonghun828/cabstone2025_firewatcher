// lib/pages/notice_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notice.dart';
import '../models/comment.dart';

class NoticeDetailPage extends StatefulWidget {
  final Notice notice;

  const NoticeDetailPage({
    Key? key,
    required this.notice,
  }) : super(key: key);

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  late Notice _currentNotice;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentNotice = widget.notice;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        author: '사용자_${DateTime.now().second}',
        content: _commentController.text,
        date: DateTime.now(),
      );

      setState(() {
        _currentNotice = _currentNotice.copyWith(
          comments: List.from(_currentNotice.comments)..add(newComment),
        );
        _commentController.clear();
      });
      print('댓글 추가됨: ${newComment.content}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지 상세'),
      ),
      body: SingleChildScrollView( // 전체 페이지가 스크롤 가능하도록 SingleChildScrollView로 감쌉니다.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 공지 제목
            Text(
              _currentNotice.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 작성자 및 날짜
            Text(
              '${_currentNotice.author} | ${DateFormat('yyyy.MM.dd HH:mm').format(_currentNotice.date)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const Divider(height: 32, thickness: 1), // 공지 기본 정보와 내용 사이의 구분선

            // 공지 내용에 해당하는 공간을 고정으로 키우기 (minHeight 사용)
            // 내용은 Text(_currentNotice.content)가 자연스럽게 확장되고,
            // 이 ConstrainedBox가 최소한의 높이를 보장하여 화면을 채웁니다.
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150.0), // <-- 최소 높이 설정 (조정 가능)
              child: Text(
                _currentNotice.content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const Divider(height: 32, thickness: 1), // 공지 내용과 댓글 섹션 사이의 구분선

            // 댓글 섹션
            Text(
              '댓글 (${_currentNotice.comments.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 댓글 입력 필드
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 48),
                  ),
                  child: const Text('등록'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 댓글 리스트
            _currentNotice.comments.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text('첫 댓글을 남겨주세요!'),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // SingleChildScrollView와 함께 사용
                    shrinkWrap: true, // 자식들의 크기만큼만 공간 차지
                    itemCount: _currentNotice.comments.length,
                    itemBuilder: (context, index) {
                      final comment = _currentNotice.comments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment.author,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('MM.dd HH:mm').format(comment.date),
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(comment.content),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}