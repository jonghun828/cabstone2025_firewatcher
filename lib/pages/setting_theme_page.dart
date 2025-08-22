// lib/pages/setting_theme_page.dart

import 'package:flutter/material.dart';

/// 앱의 테마(라이트/다크 모드)를 설정하는 페이지.
///
/// 사용자는 '라이트 모드' 또는 '다크 모드'를 선택할 수 있습니다.
class SettingThemePage extends StatefulWidget {
  const SettingThemePage({super.key});

  @override
  State<SettingThemePage> createState() => _SettingThemePageState();
}

class _SettingThemePageState extends State<SettingThemePage> {
  // TODO: 실제 앱에서는 현재 저장된 테마 모드 설정을 로드해야 합니다.
  // 임시로 현재 시스템 테마를 따르도록 초기화합니다.
  ThemeMode _selectedThemeMode = ThemeMode.system; // ThemeMode.system도 일반적인 옵션이라 포함했습니다. 필요 없으면 제거할 수 있습니다.

  @override
  void initState() {
    super.initState();
    // 실제 앱에서는 SharedPreferences 등에서 저장된 테마 모드를 로드하여 초기화해야 합니다.
    // 예시: _selectedThemeMode = (await SharedPreferences.getInstance()).getString('themeMode') == 'dark' ? ThemeMode.dark : ThemeMode.light;
    // 또는 현재 시스템 설정에 따라 초기화할 수 있습니다.
    // _selectedThemeMode = ThemeMode.system; // 기본값은 시스템 설정 따르기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 설정'),
      ),
      body: ListView(
        children: [
          // 시스템 설정 따르기 (선택 사항)
          RadioListTile<ThemeMode>(
            title: const Text('시스템 설정 따르기'),
            value: ThemeMode.system,
            groupValue: _selectedThemeMode,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedThemeMode = value!;
              });
            },
          ),
          // 라이트 모드 선택
          RadioListTile<ThemeMode>(
            title: const Text('라이트 모드'),
            value: ThemeMode.light,
            groupValue: _selectedThemeMode,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedThemeMode = value!;
              });
            },
          ),
          // 다크 모드 선택
          RadioListTile<ThemeMode>(
            title: const Text('다크 모드'),
            value: ThemeMode.dark,
            groupValue: _selectedThemeMode,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedThemeMode = value!;
              });
            },
          ),
          const Divider(),

          // 설정 저장 버튼
          Padding(
            padding: const EdgeInsets.all(20.0), // 통일성 있게 수평 패딩 20
            child: ElevatedButton(
              onPressed: () {
                print('테마 설정 저장됨: ${_selectedThemeMode.name}');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('테마 설정이 저장되었습니다.')),
                );
                // TODO: _selectedThemeMode 값을 로컬 저장소(shared_preferences)에 저장하는 로직 구현.
                // TODO: 앱 전체의 테마를 변경하기 위해서는 MaterialApp 위젯의 themeMode를 변경해야 합니다.
                //       이를 위해 provider, Riverpod, bloc 등 상태 관리 솔루션을 사용하여
                //       _selectedThemeMode 값을 main.dart의 MaterialApp에 전달해야 합니다.
                //       예시: Provider.of<ThemeNotifier>(context, listen: false).setTheme(_selectedThemeMode);
              },
              child: const Text('설정 저장'),
            ),
          ),
        ],
      ),
    );
  }
}