// lib/pages/profile_edit_page.dart

import 'package:flutter/material.dart';

// 클래스 이름을 ProfileEditPage로 변경
class ProfileEditPage extends StatefulWidget {
  final String title;        // AppBar 제목 및 TextField의 Label
  final String currentValue; // 현재 값
  final String fieldKey;     // 어떤 필드인지 구분하기 위한 키 (예: 'name', 'email')

  const ProfileEditPage({ // 생성자 이름도 ProfileEditPage로 변경
    Key? key,
    required this.title,
    required this.currentValue,
    required this.fieldKey,
  }) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState(); // createState 반환 타입도 변경
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 변경사항 저장 및 이전 페이지로 돌아가는 함수
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _controller.text); // 새로운 값을 이전 페이지로 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: widget.title,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${widget.title}을(를) 입력해주세요.';
                  }
                  // 이메일 필드에 대한 간단한 유효성 검사 (선택 사항)
                  if (widget.fieldKey == 'email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return '유효한 이메일 주소를 입력해주세요.';
                  }
                  return null;
                },
                // 필드 키에 따라 키보드 타입 변경 (편의성)
                keyboardType: widget.fieldKey == 'phonenumber' ? TextInputType.phone :
                             (widget.fieldKey == 'email' ? TextInputType.emailAddress : TextInputType.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}