import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 API 호출 메서드
  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('사용자 이름과 비밀번호를 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      // 응답 처리
      if (response.statusCode == 200) {
        _showSnackBar('로그인 성공', isError: false);

        // 토큰을 저장하는 로직 필요
        final String? accessToken = response.data?['accessToken'];
        if (accessToken != null) {
          print('로그인 성공! Access Token: $accessToken');
        } else {
          print('로그인 성공, 하지만 토큰이 없습니다.');
        }

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        _showSnackBar('로그인 실패: ${response.data?['message'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
      // API 호출 중 오류
      _showSnackBar('오류 발생: ${e.toString()}');
      print('Login Error: $e');
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이디 입력창
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),

            // 비밀번호 입력창
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // 로그인 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login, // 로딩 중에는 버튼 비활성화, _login 메서드 연결
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _isLoading // 로딩 중일 때 로딩 인디케이터 표시
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('로그인'),
              ),
            ),
            const SizedBox(height: 10),

            // 회원가입 버튼
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}