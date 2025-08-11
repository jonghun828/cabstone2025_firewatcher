import 'package:flutter/material.dart';

// StatefulWidget을 쓰는 이유: 나중에 입력값 상태 관리할 수 있게
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 입력 컨트롤러: 사용자가 입력한 텍스트 가져올 때 씀
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          children: [
            // 이메일 입력창
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20), // 간격
            // 비밀번호 입력창
            TextField(
              controller: _passwordController,
              obscureText: true, // 비밀번호 숨기기
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                // TODO: 로그인 기능 나중에 추가
                // 지금은 그냥 메인 페이지로 이동해보기
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('로그인'),
            ),
            const SizedBox(height: 10),
            // 회원가입 페이지 이동 버튼
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}