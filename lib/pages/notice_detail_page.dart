// lib/pages/notice_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notice.dart';
import '../models/comment.dart';
import '../services/api_service.dart';

class NoticeDetailPage extends StatefulWidget {
  final Notice notice;

  const NoticeDetailPage({
    super.key,
    required this.notice,
  });

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  late Notice _currentNotice;
  final TextEditingController _commentController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isCommentLoading = false;

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

  // 댓글 작성 API 연동 로직
  Future<void> _addComment() async {
    if (_commentController.text.isEmpty || _isCommentLoading) return;

    final String commentContent = _commentController.text;

    setState(() {
      _isCommentLoading = true;
    });

    try {
      // 1. 댓글 작성 API 호출
      final response = await _apiService.createComment(
        noticeId: _currentNotice.id,
        content: commentContent,
      );

      // 2. 서버 응답 처리 및 모델 생성
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> commentJson = response.data;
        final newComment = Comment.fromJson(commentJson);

        // 3. 상태 업데이트 및 UI 반영 (최신 댓글을 맨 앞에 삽입)
        setState(() {
          _currentNotice = _currentNotice.copyWith(
            comments: List.from(_currentNotice.comments)..insert(0, newComment),
          );
          _commentController.clear();
          _showSnackBar('댓글이 성공적으로 등록되었습니다.', isError: false);
        });
      } else {
        _showSnackBar('댓글 등록 실패 (코드: ${response.statusCode})', isError: true);
      }
    } catch (e) {
      final String errorMessage = e.toString().contains('Exception:')
          ? e.toString().replaceFirst('Exception: ', '')
          : '알 수 없는 오류';
      _showSnackBar('댓글 등록 중 오류 발생: $errorMessage', isError: true);
      print('Comment API Error: $e');
    } finally {
      setState(() {
        _isCommentLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    const double desiredButtonHeight = 48.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지 상세'),
      ),
      body: SingleChildScrollView(
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

            // 작성자 및 최종 수정일 (modifiedAt 사용)
            Text(
              '${_currentNotice.author} | ${DateFormat('yyyy.MM.dd HH:mm').format(_currentNotice.modifiedAt)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const Divider(height: 32, thickness: 1),

            // 공지 내용
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150.0),
              child: Text(
                _currentNotice.content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const Divider(height: 32, thickness: 1),

            // 댓글 섹션 헤더
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
                    minLines: 1,
                    maxLines: 1,
                    enabled: !_isCommentLoading, // 로딩 중 입력 방지
                  ),
                ),
                const SizedBox(width: 8),

                // 등록 버튼
                SizedBox(
                  height: desiredButtonHeight,
                  child: ElevatedButton(
                    onPressed: _isCommentLoading ? null : _addComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // 로딩 상태 표시
                    child: _isCommentLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : const Text('등록'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 댓글 리스트
            _currentNotice.comments.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('댓글을 작성해주세요'),
              ),
            )
                : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _currentNotice.comments.length,
              itemBuilder: (context, index) {
                final comment = _currentNotice.comments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1.0),
                  ),
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