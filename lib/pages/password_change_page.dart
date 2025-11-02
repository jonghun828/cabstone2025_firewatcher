// lib/pages/password_change_page.dart

import 'package:flutter/material.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  // 비밀번호 변경 로직
  void _changePassword() {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      _showSnackBar('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
      return;
    }

    // TODO: 현재 비밀번호 확인 및 새 비밀번호를 서버에 저장하는 로직 구현
    // 예: apiService.changePassword(current: ..., new: ...);

    _showSnackBar('비밀번호가 성공적으로 변경되었습니다.', isError: false);

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
    // 💡 로그인 페이지에서 사용했던 보라색 계열 색상 (일관성 유지)
    const Color primaryColor = Color(0xFF673AB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 변경'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            '안전한 계정 관리를 위해 비밀번호를 주기적으로 변경해 주세요.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // 현재 비밀번호 입력
          TextFormField(
            controller: _currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '현재 비밀번호',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 새 비밀번호 입력
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '새 비밀번호',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 새 비밀번호 확인
          TextFormField(
            controller: _confirmNewPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '새 비밀번호 확인',
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
              onTap: _changePassword,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    '비밀번호 변경',
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