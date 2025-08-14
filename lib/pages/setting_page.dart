// lib/pages/setting_page.dart

import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 설정 페이지 자체에 AppBar를 추가합니다.
        title: const Text('설정'),
        automaticallyImplyLeading: false, // BottomNavigationBar로 접근되므로 뒤로가기 버튼 숨김
      ),
      body: ListView( // 설정 항목이 많아지면 스크롤 가능하도록 ListView 사용
        padding: const EdgeInsets.all(16.0), // 전체적인 페이지 패딩
        children: [
          // 개인정보 설정
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('개인정보 설정'),
            onTap: () {
              print('개인정보 설정 메뉴 선택');
              // TODO: 개인정보 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          // 알림 설정
          ListTile(
            leading: Icon(Icons.notifications_none), // 알림 관련 아이콘
            title: Text('알림 설정'),
            onTap: () {
              print('알림 설정 메뉴 클릭 -> 알림 설정 상세 페이지로 이동');
              // TODO: 알림 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          // 기기 설정
          ListTile(
            leading: Icon(Icons.devices_other),
            title: Text('기기 설정'),
            onTap: () {
              print('기기 설정 메뉴 클릭 -> 기기 설정 상세 페이지로 이동');
              // TODO: 기기 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          // 영상 설정
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('영상 설정'),
            onTap: () {
              print('영상 설정 메뉴 클릭 -> 영상 설정 상세 페이지로 이동');
              // TODO: 영상 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          // 테마 설정
          ListTile(
            leading: Icon(Icons.brightness_6), // 밝기/테마 관련 아이콘
            title: Text('테마 설정'),
            onTap: () {
              print('테마 설정 메뉴 클릭 -> 테마 설정 상세 페이지로 이동');
              // TODO: 테마 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          // 언어 설정
          ListTile(
            leading: Icon(Icons.language), // 언어 관련 아이콘
            title: Text('언어 설정'),
            onTap: () {
              print('언어 설정 메뉴 클릭 -> 언어 설정 상세 페이지로 이동');
              // TODO: 언어 설정 상세 페이지로 이동
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}