// lib/pages/email_change_page.dart

import 'package:flutter/material.dart';

class EmailChangePage extends StatefulWidget {
  // 현재 이메일 정보를 받아올 수 있도록 생성자 수정
  final String currentEmail;

  const EmailChangePage({super.key, required this.currentEmail});

  @override
  State<EmailChangePage> createState() => _EmailChangePageState();
}

class _EmailChangePageState extends State<EmailChangePage> {
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 현재 이메일 표시를 위한 변수
  late String _displayCurrentEmail;

  @override
  void initState() {
    super.initState();
    _displayCurrentEmail = widget.currentEmail;
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 이메일 변경 로직
  void _changeEmail() {
    // TODO: 비밀번호 확인 및 새 이메일을 서버에 저장하는 로직 구현 (이메일 인증 포함)
    // 예: apiService.changeEmail(newEmail: ..., password: ...);

    _showSnackBar('이메일 변경을 위한 인증 메일이 전송되었습니다.', isError: false);

    // 성공 시 이전 페이지로 돌아가기
    Navigator.pop(context);
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
    // 💡 로그인 페이지에서 사용했던 보라색 계열 색상
    const Color primaryColor = Color(0xFF673AB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('이메일 변경'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 현재 이메일 정보 표시
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.email, color: primaryColor),
            title: const Text('현재 이메일'),
            subtitle: Text(
              _displayCurrentEmail,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          const SizedBox(height: 16),

          // 새 이메일 입력
          TextFormField(
            controller: _newEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: '새 이메일 주소',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 비밀번호 확인
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '비밀번호 확인',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),

          // 저장하기 버튼 (카드 스타일)
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: _changeEmail,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    '이메일 변경 요청',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}