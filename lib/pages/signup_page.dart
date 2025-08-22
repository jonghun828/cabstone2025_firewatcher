import 'package:flutter/material.dart';

// 회원가입 페이지
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController(); // 관리자 정보용

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _adminCodeController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final adminCode = _adminCodeController.text;

    print('이메일: $email, 아이디: $username, 비밀번호: $password, 관리자정보: $adminCode');

    // 회원가입 성공 후 메인 화면으로 이동
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                hintText: 'example@email.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '아이디',
                hintText: '사용할 아이디 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                hintText: '비밀번호 입력',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _adminCodeController,
              decoration: InputDecoration(
                labelText: '관리자 정보',
                hintText: '관리자 코드 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onSignUpPressed,
                child: Text('회원가입'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}