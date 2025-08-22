// lib/pages/notice_write_page.dart

import 'package:flutter/material.dart';
import '../models/notice.dart'; // Notice 모델 import

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

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러를 해제하여 리소스 누수를 방지합니다.
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 새로운 공지사항을 생성하고 이전 페이지로 전달합니다.
  void _saveNotice() {
    if (_formKey.currentState!.validate()) {
      // 폼 유효성 검사
      final newNotice = Notice(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        // 임시 ID (실제로는 서버에서 부여)
        title: _titleController.text,
        // 입력된 제목
        content: _contentController.text,
        // 입력된 내용
        author: _author,
        // 설정된 작성자
        date: DateTime.now(), // 현재 작성 시간
      );

      // 이전 페이지(NoticeBoardPage)로 새로 생성된 공지사항 객체를 반환합니다.
      Navigator.pop(context, newNotice);
      ScaffoldMessenger.of(context).showSnackBar(
        // 저장 성공 메시지
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
          IconButton(
            icon: const Icon(Icons.save), // 저장 아이콘
            onPressed: _saveNotice, // 저장 버튼 클릭 시 _saveNotice 함수 호출
          ),
        ],
      ),
      body: Padding(
        // <--- SingleChildScrollView 제거하고 Padding을 body에 직접 할당
        padding: const EdgeInsets.all(20.0), // 통일된 수평 패딩 20.0
        child: Form(
          key: _formKey, // 폼 키 연결
          child: Column(
            // <--- Column의 부모는 이제 Bounded Constraint를 가짐 (Scaffold Body)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 입력 필드
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '제목', // 구체적인 힌트 텍스트
                  border: UnderlineInputBorder(), // OutlineInputBorder 유지
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // 제목과 내용 필드 사이 간격
              // 내용 입력 필드 (Expanded로 감싸 남은 공간을 채우고 자체 스크롤 가능하게 함)
              Expanded(
                // <--- Expanded 위젯이 이제 정상적으로 동작할 수 있습니다.
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  // 무제한 라인 허용
                  expands: true,
                  // 부모 Expanded가 제공하는 모든 공간을 채우도록 함
                  keyboardType: TextInputType.multiline,
                  // 멀티라인 키보드 활성화
                  textAlignVertical: TextAlignVertical.top,
                  // 텍스트를 상단에 정렬
                  decoration: const InputDecoration(
                    hintText: '내용', // 구체적인 힌트 텍스트
                    border: InputBorder.none, // OutlineInputBorder 유지
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
