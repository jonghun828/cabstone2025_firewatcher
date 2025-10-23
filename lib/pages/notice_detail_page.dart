// lib/pages/notice_detail_page.dart (수정된 코드)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notice.dart';
import '../models/comment.dart';
// ⭐ 추가: API 서비스 임포트
import '../services/api_service.dart';

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

  // ⭐ 추가: API 서비스 인스턴스 및 로딩 상태
  final ApiService _apiService = ApiService();
  bool _isCommentLoading = false;

  @override
  void initState() {
    super.initState();
    // 초기 공지사항 데이터는 부모 위젯에서 전달받은 것으로 설정
    _currentNotice = widget.notice;

    // ⭐ TODO: 필요하다면, 상세 페이지 진입 시 공지사항 상세 정보를 다시 API로 불러와 최신화하는 로직을 여기에 추가할 수 있습니다.
    // 현재는 목록 페이지에서 받은 데이터를 사용합니다.
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // ⭐ 수정: 댓글 작성 API 연동 로직
  Future<void> _addComment() async {
    if (_commentController.text.isEmpty || _isCommentLoading) {
      return;
    }

    final String commentContent = _commentController.text;

    setState(() {
      _isCommentLoading = true;
    });

    try {
      // 🚨 TODO: 댓글 작성 API 엔드포인트와 파라미터를 백엔드와 협의 후 여기에 적용해야 합니다.
      // 예시: await _apiService.createComment(
      //   noticeId: _currentNotice.id,
      //   content: commentContent
      // );

      // 현재는 API가 없으므로 임시로 지연 시간을 줍니다. (실제 구현 시 이 코드는 제거)
      await Future.delayed(const Duration(milliseconds: 500));

      // 🚨 주의: 댓글 작성 성공 시, 서버에서 받은 실제 댓글 데이터(ID, date, author 등)로 새로운 Comment 객체를 만들어 _currentNotice를 업데이트해야 합니다.
      // 현재는 임시 데이터로 업데이트합니다.
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch, // int 타입으로 변경
        author: '나의 이름', // 로그인 사용자 이름으로 변경 필요
        content: commentContent,
        date: DateTime.now(),
      );

      setState(() {
        _currentNotice = _currentNotice.copyWith(
          comments: List.from(_currentNotice.comments)..add(newComment),
        );
        _commentController.clear();
        _showSnackBar('댓글이 성공적으로 등록되었습니다.', isError: false);
      });

    } catch (e) {
      _showSnackBar('댓글 등록 중 오류가 발생했습니다. 다시 시도해 주세요.', isError: true);
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

            // ⭐ 수정된 부분: 게시일자로 modifiedAt 사용
            Text(
              '${_currentNotice.author} | ${DateFormat('yyyy.MM.dd HH:mm').format(_currentNotice.modifiedAt)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const Divider(height: 32, thickness: 1),

            //공지 내용
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150.0),
              child: Text(
                _currentNotice.content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const Divider(height: 32, thickness: 1),

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
                    minLines: 1,
                    maxLines: 1,
                    // ⭐ 추가: 로딩 중에는 입력 방지
                    enabled: !_isCommentLoading,
                  ),
                ),
                const SizedBox(width: 8),

                // 등록 버튼
                SizedBox(
                  height: desiredButtonHeight,
                  child: ElevatedButton(
                    // ⭐ 수정: 로딩 중이 아닐 때만 _addComment 호출
                    onPressed: _isCommentLoading ? null : _addComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // ⭐ 추가: 로딩 상태 표시
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