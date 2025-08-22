// lib/pages/setting_language_page.dart

import 'package:flutter/material.dart';
import '../models/language.dart'; // 기존 모델 import 유지

/// 앱의 언어 설정을 관리하는 페이지.
///
/// 한국어, 영어, 중국어, 일본어 중 선택할 수 있습니다.
class SettingLanguagePage extends StatefulWidget {
  const SettingLanguagePage({super.key});

  @override
  State<SettingLanguagePage> createState() => _SettingLanguagePageState();
}

class _SettingLanguagePageState extends State<SettingLanguagePage> {
  // TODO: 실제 앱에서는 현재 저장된 언어 설정을 로드해야 합니다.
  // 임시 언어 설정 데이터
  late LanguageSetting _currentSetting; // <--- AppLanguageSetting -> LanguageSetting

  @override
  void initState() {
    super.initState();
    // 실제 앱에서는 SharedPreferences 등에서 저장된 언어 설정을 로드하여 초기화해야 합니다.
    _currentSetting = LanguageSetting(); // <--- AppLanguageSetting -> LanguageSetting (기본값: 한국어)으로 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('언어 설정'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // 통일성 있게 수평 패딩 20
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '언어 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // 지원하는 모든 언어 코드를 순회하며 RadioListTile 생성
                // LanguageCode.values를 사용하고, displayName은 LanguageName 확장 기능입니다.
                ...LanguageCode.values.map((languageCode) { // <--- AppLanguageCode -> LanguageCode
                  return RadioListTile<LanguageCode>( // <--- AppLanguageCode -> LanguageCode
                    title: Text(languageCode.displayName), // LanguageName 확장 사용
                    value: languageCode,
                    groupValue: _currentSetting.selectedLanguage,
                    onChanged: (LanguageCode? value) { // <--- AppLanguageCode -> LanguageCode
                      setState(() {
                        if (value != null) {
                          _currentSetting.selectedLanguage = value;
                        }
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          const Divider(),

          // 설정 저장 버튼
          Padding(
            padding: const EdgeInsets.all(20.0), // 통일성 있게 수평 패딩 20
            child: ElevatedButton(
              onPressed: () {
                print('언어 설정 저장됨: ${_currentSetting.selectedLanguage.displayName}'); // LanguageName 확장 사용
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('언어 설정이 저장되었습니다.')),
                );
                // TODO: _currentSetting.selectedLanguage 값을 로컬 저장소(shared_preferences)에 저장하는 로직 구현.
                // TODO: 앱 전체의 언어를 변경하기 위해서는 MaterialApp 위젯의 locale을 변경해야 합니다.
                //       이를 위해 다국어(i18n) 패키지(예: flutter_localizations)와 상태 관리 솔루션을 사용하여
                //       main.dart의 MaterialApp에 전달해야 합니다.
              },
              child: const Text('설정 저장'),
            ),
          ),
        ],
      ),
    );
  }
}