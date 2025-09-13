import 'package:flutter/material.dart';
import 'routes.dart'; // 라우트 정의 파일 import

void main() {
  runApp(MyApp()); // 앱 시작 지점
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wildfire watcher',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          // AppBar의 기본 테마를 설정할 수 있습니다.
          backgroundColor: Colors.white, // AppBar의 기본 배경색 (AppBar 자체의 색상)
          foregroundColor: Colors.black, // AppBar 아이콘 및 텍스트 색상
          elevation: 0, // AppBar 기본 그림자 제거
        ),
      ),
      initialRoute: '/',
      routes: appRoutes, // 라우트 맵 연결
    );
  }
}
