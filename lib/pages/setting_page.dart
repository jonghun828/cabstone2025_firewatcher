// lib/pages/setting_page.dart

import 'package:flutter/material.dart';
// 설정 상세 페이지들 (예시)
import 'setting_notification_page.dart';
import 'setting_video_page.dart';
import 'setting_theme_page.dart';
import 'setting_language_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          _buildSettingItem(
            context,
            icon: Icons.notifications,
            title: '알림 설정',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingNotificationPage()));
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.videocam,
            title: '영상 설정',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingVideoPage()));
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.color_lens,
            title: '테마 설정',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingThemePage()));
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.language,
            title: '언어 설정',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingLanguagePage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey, size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}