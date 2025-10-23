// lib/pages/notice_write_page.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NoticeWritePage extends StatefulWidget {
  const NoticeWritePage({super.key});

  @override
  State<NoticeWritePage> createState() => _NoticeWritePageState();
}

class _NoticeWritePageState extends State<NoticeWritePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateFormValidity);
    _contentController.addListener(_updateFormValidity);
    _updateFormValidity();
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateFormValidity);
    _contentController.removeListener(_updateFormValidity);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final bool currentValidity = _titleController.text.isNotEmpty && _contentController.text.isNotEmpty;
    if (_isFormValid != currentValidity) {
      setState(() {
        _isFormValid = currentValidity;
      });
    }
  }

  // 주요 공지
  Future<bool?> _showMajorNoticeSelectionDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('공지 종류 선택'),
          content: const Text('이 공지를 주요 공지로 등록하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('일반 공지'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: const Text('주요 공지'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  // 새로운 공지사항을 생성
  Future<void> _saveNotice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool? isMajorConfirmed = await _showMajorNoticeSelectionDialog();

    if (isMajorConfirmed == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.createNotice(
        title: _titleController.text,
        content: _contentController.text,
        important: isMajorConfirmed,
      );

      if (response.statusCode == 201) {
        _showSnackBar('새 공지사항이 성공적으로 등록되었습니다.', isError: false);
        Navigator.pop(context);
      } else {
        final String errorMessage = response.data?['message'] ?? '공지 등록에 실패했습니다. (응답 코드: ${response.statusCode})';
        _showSnackBar(errorMessage, isError: true);
      }

    } catch (e) {
      final String errorMessage = e.toString().contains('Exception:')
          ? e.toString().replaceFirst('Exception: ', '')
          : '오류 발생: 서버 연결에 실패했습니다.';
      _showSnackBar(errorMessage, isError: true);
      print('Notice Save API Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 공지 작성'),
        actions: [
          TextButton(
            onPressed: (_isFormValid && !_isLoading) ? _saveNotice : null,
            style: TextButton.styleFrom(
              foregroundColor: (_isFormValid && !_isLoading) ? Colors.black : Colors.grey[400],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: _isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.grey,
                strokeWidth: 2,
              ),
            )
                : const Text(
              '등록',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '제목',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: '내용',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력해주세요.';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}