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
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: appRoutes, // 라우트 맵 연결
    );
  }
}