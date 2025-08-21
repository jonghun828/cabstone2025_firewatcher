// lib/pages/setting_notification_page.dart

import 'package:flutter/material.dart';
import '../models/notification_setting.dart';

/// 알림 모드 (소리, 진동, 무음) 및 세부 설정을 관리하는 페이지.
///
/// 소리/진동 스위치로 활성화 여부를 설정하고,
/// 각각의 상세 설정(알림음, 진동 패턴)은 별도의 팝업을 통해 선택합니다.
class SettingNotificationPage extends StatefulWidget {
  const SettingNotificationPage({super.key});

  @override
  State<SettingNotificationPage> createState() => _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  // 알림음 목록 (임시 데이터)
  final List<Ringtone> _ringtones = const [
    Ringtone(id: 'ring_1', name: '기본 알림음'),
    Ringtone(id: 'ring_2', name: '클래식 벨'),
    Ringtone(id: 'ring_3', name: '별똥별'),
    Ringtone(id: 'ring_4', name: '맑은 종소리'),
    Ringtone(id: 'ring_5', name: '고요한 새벽'),
  ];

  // 진동 패턴 목록 (임시 데이터)
  final List<VibrationPattern> _vibrationPatterns = const [
    VibrationPattern(id: 'vib_1', name: '기본 진동'),
    VibrationPattern(id: 'vib_2', name: '짧게 두 번'),
    VibrationPattern(id: 'vib_3', name: '길게 한 번'),
    VibrationPattern(id: 'vib_4', name: '강하게 한번'),
    VibrationPattern(id: 'vib_5', name: '잔잔한 파동'),
  ];

  // TODO: 실제 앱에서는 사용자 설정(로컬 저장소 또는 서버)을 로드하여 초기화해야 합니다.
  // 임시 알림 설정 데이터
  late NotificationSetting _currentSetting;

  @override
  void initState() {
    super.initState();
    // 초기 설정 시, 기본 알림음과 진동 패턴을 미리 선택해 둡니다.
    _currentSetting = NotificationSetting(
      enableSound: true, // 초기값: 소리 활성화
      enableVibration: true, // 초기값: 진동 활성화
      selectedRingtone: _ringtones.first, // 첫 번째 알림음을 기본으로
      selectedVibrationPattern: _vibrationPatterns.first, // 첫 번째 진동 패턴을 기본으로
    );
  }

  /// 알림음 선택 다이얼로그를 띄우고 선택된 알림음을 반환합니다.
  Future<Ringtone?> _showRingtoneSelectionDialog() async {
    return showDialog<Ringtone>(
      context: context,
      builder: (BuildContext context) {
        Ringtone? selectedRingtone = _currentSetting.selectedRingtone; // 현재 선택된 알림음
        return AlertDialog(
          title: const Text('알림음 선택'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _ringtones.map((ringtone) {
                return RadioListTile<Ringtone>(
                  title: Text(ringtone.name),
                  value: ringtone,
                  groupValue: selectedRingtone,
                  onChanged: (Ringtone? value) {
                    setState(() {
                      selectedRingtone = value; // 다이얼로그 내에서 선택 값 업데이트
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기 (null 반환)
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(selectedRingtone); // 선택된 알림음 반환
              },
            ),
          ],
        );
      },
    );
  }

  /// 진동 패턴 선택 다이얼로그를 띄우고 선택된 진동 패턴을 반환합니다.
  Future<VibrationPattern?> _showVibrationPatternSelectionDialog() async {
    return showDialog<VibrationPattern>(
      context: context,
      builder: (BuildContext context) {
        VibrationPattern? selectedPattern = _currentSetting.selectedVibrationPattern; // 현재 선택된 패턴
        return AlertDialog(
          title: const Text('진동 패턴 선택'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _vibrationPatterns.map((pattern) {
                return RadioListTile<VibrationPattern>(
                  title: Text(pattern.name),
                  value: pattern,
                  groupValue: selectedPattern,
                  onChanged: (VibrationPattern? value) {
                    setState(() {
                      selectedPattern = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(selectedPattern);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
      ),
      body: ListView(
        children: [
          // 1. 소리 알림 스위치
          SwitchListTile(
            title: const Text('소리'),
            value: _currentSetting.enableSound,
            onChanged: (bool value) {
              setState(() {
                _currentSetting.enableSound = value;
              });
            },
          ),
          // 소리 활성화 시에만 '알림음' 설정 섹션 표시
          if (_currentSetting.enableSound)
            ListTile(
              title: const Text('알림음'),
              subtitle: Text( // <--- 선택된 알림음 이름을 subtitle로 표시
                _currentSetting.selectedRingtone.name,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final selected = await _showRingtoneSelectionDialog();
                if (selected != null) {
                  setState(() {
                    _currentSetting.selectedRingtone = selected;
                  });
                }
              },
            ),
          const Divider(),

          // 2. 진동 알림 스위치
          SwitchListTile(
            title: const Text('진동'),
            value: _currentSetting.enableVibration,
            onChanged: (bool value) {
              setState(() {
                _currentSetting.enableVibration = value;
              });
            },
          ),
          // 진동 활성화 시에만 '진동 패턴' 설정 섹션 표시
          if (_currentSetting.enableVibration)
            ListTile(
              title: const Text('진동 패턴'),
              subtitle: Text( // <--- 선택된 진동 패턴 이름을 subtitle로 표시
                _currentSetting.selectedVibrationPattern.name,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final selected = await _showVibrationPatternSelectionDialog();
                if (selected != null) {
                  setState(() {
                    _currentSetting.selectedVibrationPattern = selected;
                  });
                }
              },
            ),
          const Divider(),

          // 설정 저장 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('설정 저장됨:');
                print('  소리 활성화: ${_currentSetting.enableSound}');
                if (_currentSetting.enableSound) print('  알림음: ${_currentSetting.selectedRingtone.name}');
                print('  진동 활성화: ${_currentSetting.enableVibration}');
                if (_currentSetting.enableVibration) print('  진동 패턴: ${_currentSetting.selectedVibrationPattern.name}');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('알림 설정이 저장되었습니다.')),
                );
                // TODO: 실제 설정 값을 로컬 저장소(shared_preferences 등) 또는 서버에 저장하는 로직 구현
              },
              child: const Text('설정 저장'),
            ),
          ),
        ],
      ),
    );
  }
}