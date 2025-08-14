import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/main_page.dart';

/// 앱의 모든 라우트를 여기에 정의
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginPage(),       // 초기 화면
  '/signup': (context) => SignupPage(),
  '/main': (context) => MainPage(),
};