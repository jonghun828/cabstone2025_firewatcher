import 'package:flutter/material.dart';
import 'setting_notification_page.dart';
import 'setting_video_page.dart';
import 'setting_theme_page.dart';
import 'setting_language_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('알림 설정'),
            onTap: () {
              print('알림 설정 메뉴 클릭');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SettingNotificationPage(), // <--- 클래스 이름 변경!
                ),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.devices_other),
            title: Text('기기 설정'),
            onTap: () {
              print('기기 설정 메뉴 클릭');
              // TODO: 기기 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('영상 설정'),
            onTap: () {
              print('영상 설정 메뉴 클릭');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SettingVideoPage(), // <--- 클래스 이름 변경!
                ),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.brightness_6), // 밝기/테마 관련 아이콘
            title: Text('테마 설정'),
            onTap: () {
              print('테마 설정 메뉴 클릭');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SettingThemePage(), // <--- 클래스 이름 변경!
                ),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.language), // 언어 관련 아이콘
            title: Text('언어 설정'),
            onTap: () {
              print('언어 설정 메뉴 클릭');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SettingLanguagePage(), // <--- 클래스 이름 변경!
                ),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.help_outline), // 언어 관련 아이콘
            title: Text('도움말'),
            onTap: () {
              print('도움말 메뉴 클릭');
              // TODO: 언어 설정 상세 페이지로 이동
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('로그아웃'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
