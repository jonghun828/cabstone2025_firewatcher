import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  // 2. secure_storage 인스턴스 생성
  final _storage = const FlutterSecureStorage();

  // 토큰 저장을 위한 상수 키 정의
  static const String ACCESS_TOKEN_KEY = 'access_token';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 API 호출 메서드
  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('아이디와 비밀번호를 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // final response = await _apiService.login(
      //   username: _usernameController.text,
      //   password: _passwordController.text,
      // );

      // // 응답 처리
      // if (response.statusCode == 200) {
      //   // 응답 데이터에서 'accessToken' 키의 토큰 추출
      //   final String? accessToken = response.data?['accessToken'];
      //
      //   if (accessToken != null) {
      //     // 로그인 성공 시 토큰을 안전하게 저장
      //     await _storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
      //
      //     _showSnackBar('로그인 성공!', isError: false);
      //     print('로그인 성공! Access Token이 저장되었습니다.');
      //
      //     // 메인 페이지로 이동
      //     Navigator.pushReplacementNamed(context, '/main');
      //
      //   } else {
      //     _showSnackBar('로그인 성공, 하지만 서버 응답에 토큰이 없습니다.', isError: true);
      //   }
      // } else {
      //   // 로그인 실패
      //   _showSnackBar('로그인 실패: ${response.data?['message'] ?? '아이디 또는 비밀번호를 확인해주세요.'}');
      // }
      // await Future.delayed(const Duration(seconds: 2));

      // 임시 테스트
      _showSnackBar('로그인 성공! (UI 테스트용)', isError: false);
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      // API 호출 중 오류
      _showSnackBar('오류 발생: 서버 연결 또는 처리 중 문제가 발생했습니다.');
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
      appBar: AppBar(),
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
            Card(
              margin: EdgeInsets.zero,
              elevation: 5,
              // 그림자 유지
              color: Theme.of(context).primaryColor,
              // 💡 보라색 사용
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                // 크기 설정을 위해 SizedBox를 Card 안에 넣음
                width: double.infinity,
                height: 50,
                child: InkWell(
                  onTap: _isLoading ? null : _login,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            '로그인',
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
            const SizedBox(height: 10),

            // 회원가입 버튼
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
