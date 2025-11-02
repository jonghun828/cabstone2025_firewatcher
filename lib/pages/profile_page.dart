// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../services/api_service.dart';
import 'setting_notification_page.dart';
import 'setting_video_page.dart';
import 'profile_edit_page.dart'; // 프로필 수정 페이지
import 'password_change_page.dart'; // 비밀번호 변경 페이지
import 'email_change_page.dart'; // 이메일 변경 페이지
import 'delete_account_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  // 💡 상태 변수: 프로필 정보를 관리하여 수정 페이지에서 업데이트된 값을 반영합니다.
  Uint8List? _profileImageBytes;
  String _userName = '강동성';
  String _userPosition = '팀장';
  String _userArea = 'A 구역';

  // 임시 사용자 이메일 (이메일 변경 페이지로 전달용)
  final String _userEmail = 'user_id_123@example.com';

  ThemeMode _selectedThemeMode = ThemeMode.system;

  final TextStyle _sectionTitleStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // 다크 모드(테마) 선택 팝업 (로직 유지)
  Future<void> _showThemeSelectionDialog() async {
    ThemeMode? dialogSelectedTheme = _selectedThemeMode;

    final ThemeMode? result = await showDialog<ThemeMode>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('테마 설정 (다크 모드)'),
          content: StatefulBuilder(
            builder: (BuildContext innerContext, StateSetter innerSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<ThemeMode>(
                    title: const Text('시스템 설정 따르기'),
                    value: ThemeMode.system,
                    groupValue: dialogSelectedTheme,
                    onChanged: (ThemeMode? value) {
                      innerSetState(() {
                        dialogSelectedTheme = value!;
                      });
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('라이트 모드'),
                    value: ThemeMode.light,
                    groupValue: dialogSelectedTheme,
                    onChanged: (ThemeMode? value) {
                      innerSetState(() {
                        dialogSelectedTheme = value!;
                      });
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('다크 모드'),
                    value: ThemeMode.dark,
                    groupValue: dialogSelectedTheme,
                    onChanged: (ThemeMode? value) {
                      innerSetState(() {
                        dialogSelectedTheme = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(dialogContext).pop(dialogSelectedTheme);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedThemeMode = result;
      });
      // TODO: main.dart의 MaterialApp 테마를 변경하는 로직 추가 필요
    }
  }

  // 로그아웃 처리 함수 (로직 유지)
  Future<void> _logout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _storage.delete(key: ApiService.ACCESS_TOKEN_KEY);

      if (mounted) {
        // 루트 페이지로 이동
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  // 섹션 제목 위젯 (로직 유지)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(title, style: _sectionTitleStyle),
    );
  }

  // 기본 설정 항목 위젯 (로직 유지)
  Widget _buildSettingItem(
    String title, {
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  // 프로필 상단 정보 블록 위젯 (로직 유지)
  Widget _buildProfileBlock({
    required String name,
    required String position,
    required String area,
    VoidCallback? onTap, // 카드 전체 탭 이벤트
  }) {
    const double radius = 40;
    const Color defaultColor = Color(0xFFC3E0F1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        child: InkWell(
          onTap: onTap, // 💡 카드 전체 탭 -> 수정 페이지로 연결
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: radius,
                    backgroundColor: defaultColor,
                    child: _profileImageBytes != null
                        ? ClipOval(
                            child: Image.memory(
                              _profileImageBytes!,
                              fit: BoxFit.cover,
                              width: radius * 2,
                              height: radius * 2,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    position,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    area,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String getThemeModeText(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.light:
          return '라이트 모드';
        case ThemeMode.dark:
          return '다크 모드';
        case ThemeMode.system:
          return '시스템 설정';
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: ListView(
        children: [
          // ----------------------------------
          // 1. 내 프로필
          // ----------------------------------
          _buildSectionHeader('내 프로필'),
          _buildProfileBlock(
            name: _userName,
            position: _userPosition,
            area: _userArea,
            onTap: () async {
              // 💡 프로필 카드 전체 탭 시 ProfileEditPage로 이동하며 현재 정보 전달
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(
                    initialProfileImageBytes: _profileImageBytes,
                    initialName: _userName,
                    initialPosition: _userPosition,
                    initialArea: _userArea,
                  ),
                ),
              );

              // ProfileEditPage에서 데이터가 업데이트되어 돌아왔을 경우 상태 업데이트
              if (updatedData != null) {
                setState(() {
                  _profileImageBytes = updatedData['profileImageBytes'];
                  _userName = updatedData['name'];
                  _userPosition = updatedData['position'];
                  _userArea = updatedData['area'];
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('프로필이 업데이트되었습니다.')),
                  );
                }
              }
            },
          ),

          // ----------------------------------
          // 2. 계정
          // ----------------------------------
          _buildSectionHeader('계정'),
          _buildSettingItem(
            '아이디',
            trailing: const Text(
              'user_id_123',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          _buildSettingItem(
            '비밀번호 변경',
            onTap: () {
              // 💡 비밀번호 변경 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PasswordChangePage(),
                ),
              );
            },
          ),
          _buildSettingItem(
            '이메일 변경',
            onTap: () {
              // 💡 이메일 변경 페이지로 이동 (현재 이메일 정보를 전달)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmailChangePage(currentEmail: _userEmail),
                ),
              );
            },
          ),
          // 섹션 구분선
          const Divider(indent: 20, endIndent: 20, height: 1, thickness: 1),

          // ----------------------------------
          // 3. 앱 설정
          // ----------------------------------
          _buildSectionHeader('앱 설정'),
          _buildSettingItem(
            '다크 모드 (테마 설정)',
            onTap: _showThemeSelectionDialog,
            trailing: Text(
              getThemeModeText(_selectedThemeMode),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          _buildSettingItem(
            '알림 설정',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingNotificationPage(),
                ),
              );
            },
          ),
          _buildSettingItem(
            '영상 설정',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingVideoPage(),
                ),
              );
            },
          ),
          // 섹션 구분선
          const Divider(indent: 20, endIndent: 20, height: 1, thickness: 1),

          // ----------------------------------
          // 4. 이용 안내
          // ----------------------------------
          _buildSectionHeader('이용 안내'),
          _buildSettingItem(
            '앱 버전',
            trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),
          _buildSettingItem(
            '오픈소스 라이선스',
            onTap: () {
              showLicensePage(context: context);
            },
          ),
          // 섹션 구분선
          const Divider(indent: 20, endIndent: 20, height: 1, thickness: 1),

          // ----------------------------------
          // 5. 기타
          // ----------------------------------
          _buildSectionHeader('기타'),
          _buildSettingItem(
            '회원 탈퇴',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeleteAccountPage(),
                ),
              );
            },
          ),
          _buildSettingItem(
            '로그아웃',
            onTap: _logout,
            trailing: const SizedBox.shrink(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
