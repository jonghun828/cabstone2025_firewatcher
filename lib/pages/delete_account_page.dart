// lib/pages/delete_account_page.dart

import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // 회원 탈퇴 로직
  void _confirmWithdrawal() async {
    if (_passwordController.text.isEmpty) {
      _showSnackBar('본인 확인을 위해 비밀번호를 입력해주세요.');
      return;
    }

    // 1. 최종 확인 다이얼로그
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('⚠️ 최종 확인'),
          content: const Text('회원 탈퇴 시 모든 이용 기록과 정보가 영구 삭제되며 복구할 수 없습니다. 정말로 탈퇴하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red), // 강조
              child: const Text('탈퇴 진행'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // 2. 서버 통신 로직 (TODO)
      // TODO: 입력된 비밀번호를 서버로 전송하여 본인 확인 및 탈퇴 처리 요청 구현

      // 예시 성공 처리
      _showSnackBar('회원 탈퇴가 성공적으로 처리되었습니다.', isError: false);
      // TODO: 모든 토큰 삭제 후 로그인 또는 시작 화면으로 이동하는 로직 구현 필요
      // 예: Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else {
      _showSnackBar('회원 탈퇴가 취소되었습니다.');
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
    // 비밀번호/이메일 변경 페이지와 동일한 보라색 계열 색상 사용
    const Color primaryColor = Color(0xFF673AB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 탈퇴'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ⚠️ 경고 문구 박스
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade400),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Text(
                      '잠깐! 회원 탈퇴 전에 꼭 확인해주세요.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '회원 탈퇴 시, 회원님의 모든 이용 기록과 작성한 게시물, 댓글 등의 정보는 영구적으로 삭제되며 복구가 불가능합니다.',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 5),
                const Text(
                  '정말로 탈퇴를 진행하시겠습니까?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 비밀번호 입력 필드
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '본인 확인을 위해 비밀번호를 입력해주세요',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '* 입력하신 비밀번호가 일치해야 탈퇴 처리가 진행됩니다.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // 탈퇴 버튼 (카드 스타일 - 빨간색으로 변경하여 위험 행위 강조)
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: Colors.red.shade600, // 💡 탈퇴는 빨간색으로 경고성 강조
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: _confirmWithdrawal,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    '회원 탈퇴하기',
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
