// lib/pages/setting_page.dart

import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.notifications_none), // 알림 관련 아이콘
            title: Text('알림 설정'),
            onTap: () {
              print('알림 설정 메뉴 클릭 -> 알림 설정 상세 페이지로 이동');
              // TODO: 알림 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.devices_other),
            title: Text('기기 설정'),
            onTap: () {
              print('기기 설정 메뉴 클릭 -> 기기 설정 상세 페이지로 이동');
              // TODO: 기기 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('영상 설정'),
            onTap: () {
              print('영상 설정 메뉴 클릭 -> 영상 설정 상세 페이지로 이동');
              // TODO: 영상 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.brightness_6), // 밝기/테마 관련 아이콘
            title: Text('테마 설정'),
            onTap: () {
              print('테마 설정 메뉴 클릭 -> 테마 설정 상세 페이지로 이동');
              // TODO: 테마 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.language), // 언어 관련 아이콘
            title: Text('언어 설정'),
            onTap: () {
              print('언어 설정 메뉴 클릭 -> 언어 설정 상세 페이지로 이동');
              // TODO: 언어 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.help_outline), // 언어 관련 아이콘
            title: Text('도움말'),
            onTap: () {
              print('도움말 메뉴 클릭 -> 도움말 상세 페이지 이동');
              // TODO: 언어 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('로그아웃'),
            onTap: (){
              Navigator.pushReplacementNamed(context, '/');
            }
          ),
        ],
      ),
    );
  }
}