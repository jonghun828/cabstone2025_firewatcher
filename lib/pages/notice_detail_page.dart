import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notice.dart';
import '../models/comment.dart';
import '../services/api_service.dart';

class NoticeDetailPage extends StatefulWidget {
  final Notice notice;

  const NoticeDetailPage({super.key, required this.notice});

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  late Notice _currentNotice;
  final TextEditingController _commentController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isCommentLoading = false;
  bool _hasCommentChanged = false;

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

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty || _isCommentLoading) return;

    final String commentContent = _commentController.text;

    setState(() {
      _isCommentLoading = true;
    });

    try {
      final response = await _apiService.createComment(
        noticeId: _currentNotice.id,
        content: commentContent,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final newComment = Comment.fromJson(response.data);

        setState(() {
          final List<Comment> updatedComments = List.from(_currentNotice.comments)..insert(0, newComment);
          updatedComments.sort((a, b) => b.date.compareTo(a.date));

          _currentNotice = _currentNotice.copyWith(comments: updatedComments);
          _commentController.clear();
          _showSnackBar('댓글이 성공적으로 등록되었습니다.', isError: false);

          _hasCommentChanged = true;
        });
      } else {
        _showSnackBar('댓글 등록 실패 (코드: ${response.statusCode})', isError: true);
      }
    } catch (e) {
      _showSnackBar('댓글 등록 중 오류 발생', isError: true);
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

  void _onPopInvoked(bool didPop) {
    if (didPop) return;

    if (_hasCommentChanged) {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }


  @override
  Widget build(BuildContext context) {
    const double desiredButtonHeight = 48.0;

    return PopScope(
      canPop: true,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(title: const Text('공지 상세')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_currentNotice.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${_currentNotice.author} | ${DateFormat('yyyy.MM.dd HH:mm').format(_currentNotice.modifiedAt)}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const Divider(height: 32, thickness: 1),
              ConstrainedBox(constraints: const BoxConstraints(minHeight: 150.0), child: Text(_currentNotice.content, style: const TextStyle(fontSize: 16, height: 1.5))),
              const Divider(height: 32, thickness: 1),

              // 댓글 섹션
              Text('댓글 (${_currentNotice.comments.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // 댓글 입력 필드
              Row(children: [
                Expanded(child: TextField(controller: _commentController, decoration: const InputDecoration(hintText: '댓글을 입력하세요...', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)), minLines: 1, maxLines: 1, enabled: !_isCommentLoading)),
                const SizedBox(width: 8),
                SizedBox(height: desiredButtonHeight, child: ElevatedButton(onPressed: _isCommentLoading ? null : _addComment,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: _isCommentLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('등록'))),
              ],
              ),
              const SizedBox(height: 16),

              // 댓글 리스트
              _currentNotice.comments.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child: Text('댓글을 작성해주세요')))
                  : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _currentNotice.comments.length,
                itemBuilder: (context, index) {
                  final comment = _currentNotice.comments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(comment.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(DateFormat('MM.dd HH:mm').format(comment.date), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ]),
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
      ),
    );
  }
}