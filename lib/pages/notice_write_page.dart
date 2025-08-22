// lib/pages/notice_write_page.dart

import 'package:flutter/material.dart';
import '../models/notice.dart';

/// 새로운 공지사항을 작성하는 페이지.
///
/// 관리자 권한을 가진 사용자가 제목과 내용을 입력하여 공지사항을 생성할 수 있습니다.
class NoticeWritePage extends StatefulWidget {
  const NoticeWritePage({super.key});

  @override
  State<NoticeWritePage> createState() => _NoticeWritePageState();
}

class _NoticeWritePageState extends State<NoticeWritePage> {
  final _formKey = GlobalKey<FormState>(); // 폼 유효성 검사를 위한 Key
  final TextEditingController _titleController =
      TextEditingController(); // 제목 입력 컨트롤러
  final TextEditingController _contentController =
      TextEditingController(); // 내용 입력 컨트롤러

  // TODO: 실제 앱에서는 로그인된 사용자 정보를 기반으로 작성자를 설정해야 합니다.
  final String _author = '관리자'; // 임시 작성자

  bool _isFormValid = false; // 폼 유효성(활성화 여부) 상태

  @override
  void initState() {
    super.initState();
    // 컨트롤러에 리스너를 추가하여 텍스트 변경 시마다 폼 유효성 검사를 수행합니다.
    _titleController.addListener(_updateFormValidity);
    _contentController.addListener(_updateFormValidity);
    // 초기 상태에서 한 번 유효성 검사를 실행합니다.
    _updateFormValidity();
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러와 리스너를 해제하여 리소스 누수를 방지합니다.
    _titleController.removeListener(_updateFormValidity);
    _contentController.removeListener(_updateFormValidity);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 제목과 내용 필드의 내용을 확인하여 폼 유효성 상태를 업데이트합니다.
  void _updateFormValidity() {
    final bool currentValidity = _titleController.text.isNotEmpty && _contentController.text.isNotEmpty;
    if (_isFormValid != currentValidity) {
      setState(() {
        _isFormValid = currentValidity;
      });
    }
  }

  /// '주요 공지' 여부를 선택하는 다이얼로그를 표시합니다.
  /// 선택된 결과를 bool 값(주요 공지면 true, 일반 공지면 false)으로 반환합니다.
  Future<bool?> _showMajorNoticeSelectionDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // 다이얼로그 바깥을 탭해도 닫히지 않도록 설정
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('공지 종류 선택'),
          content: const Text('이 공지를 주요 공지로 등록하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('일반 공지'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // false (일반 공지) 반환
              },
            ),
            TextButton(
              child: const Text('주요 공지'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // true (주요 공지) 반환
              },
            ),
          ],
        );
      },
    );
  }

  /// 새로운 공지사항을 생성하고 이전 페이지로 전달합니다.
  Future<void> _saveNotice() async {
    if (_formKey.currentState!.validate()) {
      final bool? isMajorConfirmed = await _showMajorNoticeSelectionDialog();

      if (isMajorConfirmed == null) {
        return; // 공지 저장을 취소하고 함수 종료
      }

      final newNotice = Notice(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        author: _author,
        date: DateTime.now(),
        isMajor: isMajorConfirmed,
      );

      Navigator.pop(context, newNotice);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새로운 공지사항이 등록되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 공지 작성'),
        actions: [
          // '등록' 버튼 (활성화/비활성화 상태 제어)
          TextButton(
            onPressed: _isFormValid ? _saveNotice : null,
            style: TextButton.styleFrom(
              // backgroundColor 제거 (배경 없음)
              foregroundColor: _isFormValid ? Colors.black : Colors.grey[400], // <--- 필드가 채워지면 검은색, 아니면 회색
              // shape 제거 (배경 없으므로 둥근 모서리 불필요)
              // elevation 제거 (배경 없으므로 그림자 불필요)
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
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
              // 제목 입력 필드
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '제목',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 내용 입력 필드 (Expanded로 감싸 남은 공간을 채우고 자체 스크롤 가능하게 함)
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
                      return '내용';
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