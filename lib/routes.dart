// lib/routes.dart

import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/main_page.dart';
import 'pages/setting_page.dart'; // SettingPage 라우트 추가 (프로필 페이지에서 이동 가능)
import 'pages/notification_page.dart'; // NotificationPage 라우트 추가 (필요시)
import 'pages/profile_page.dart'; // ProfilePage 라우트 추가 (필요시)
import 'pages/videolog_detail_page.dart'; // VideoLogDetailPage 라우트 추가 (필요시)
import 'pages/zone_detail_page.dart'; // ZoneDetailPage 라우트 추가 (필요시)

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginPage(),          // 로그인 페이지
  '/signup': (context) => const SignupPage(),    // 회원가입 페이지
  '/main': (context) => const MainPage(),        // 메인 페이지
  '/settings': (context) => const SettingPage(), // 설정 페이지
  // 필요하다면 다른 페이지들도 라우트로 등록할 수 있습니다.
  '/notifications': (context) => const NotificationPage(),
  '/profile': (context) => const ProfilePage(),
  // '/videolog_detail': (context) => const VideoLogDetailPage(log: /* VideoLog 객체 */), // 인자가 필요한 페이지는 Named Route가 복잡할 수 있음
  // '/zone_detail': (context) => const ZoneDetailPage(sensor: /* Sensor 객체 */), // 인자가 필요한 페이지는 Named Route가 복잡할 수 있음
};