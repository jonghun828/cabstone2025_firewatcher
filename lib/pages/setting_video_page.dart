// lib/pages/setting_video_page.dart

import 'package:flutter/material.dart';
import '../models/video_setting.dart'; // 기존 알림 설정 모델 import

/// 영상 설정 정보를 관리하는 페이지.
///
/// 저장되는 영상의 길이(감지 전후 시간)와 화질을 설정할 수 있습니다.
class SettingVideoPage extends StatefulWidget { // <--- 클래스 이름 변경
  const SettingVideoPage({super.key});

  @override
  State<SettingVideoPage> createState() => _SettingVideoPageState(); // <--- State 클래스 이름도 변경
}

class _SettingVideoPageState extends State<SettingVideoPage> {
  // TODO: 실제 앱에서는 사용자 설정(로컬 저장소 또는 서버)을 로드하여 초기화해야 합니다.
  // 임시 영상 설정 데이터
  late VideoSetting _currentSetting;

  // 슬라이더의 최소/최대 값 정의
  static const int _minRecordingMinutes = 1; // 최소 감지 전후 시간 (1분)
  static const int _maxRecordingMinutes = 15; // 최대 감지 전후 시간 (15분)

  @override
  void initState() {
    super.initState();
    _currentSetting = VideoSetting(); // 기본값으로 초기화
  }

  /// 영상 화질 선택 다이얼로그를 띄우고 선택된 값을 반환합니다.
  Future<VideoQuality?> _showVideoQualitySelectionDialog() async {
    return showDialog<VideoQuality>(
      context: context,
      builder: (BuildContext context) {
        VideoQuality? selectedQuality = _currentSetting.selectedVideoQuality; // 현재 선택된 값
        return AlertDialog(
          title: const Text('영상 화질 선택'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: VideoQuality.values.map((quality) {
                String qualityText;
                switch (quality) {
                  case VideoQuality.low: qualityText = '저화질 (480p)'; break;
                  case VideoQuality.medium: qualityText = '중화질 (720p)'; break;
                  case VideoQuality.high: qualityText = '고화질 (1080p)'; break;
                }
                return RadioListTile<VideoQuality>(
                  title: Text(qualityText),
                  value: quality,
                  groupValue: selectedQuality,
                  onChanged: (VideoQuality? value) {
                    setState(() {
                      selectedQuality = value;
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
                Navigator.of(context).pop(selectedQuality);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String videoQualityText;
    switch (_currentSetting.selectedVideoQuality) {
      case VideoQuality.low: videoQualityText = '저화질 (480p)'; break;
      case VideoQuality.medium: videoQualityText = '중화질 (720p)'; break;
      case VideoQuality.high: videoQualityText = '고화질 (1080p)'; break;
    }

    // 감지 전후 시간(X분)에 따른 총 녹화 시간(Z분) 계산
    int totalRecordingMinutes = _currentSetting.detectionRecordingMinutes * 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('영상 설정'),
      ),
      body: ListView(
        children: [
          // 저장 영상 길이 설정 (슬라이더 사용)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // 좌우 패딩 20
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '녹화본 길이 설정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '감지 전후 ${_currentSetting.detectionRecordingMinutes}분'
                      ' (총 ${totalRecordingMinutes}분)',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
                Slider(
                  value: _currentSetting.detectionRecordingMinutes.toDouble(),
                  min: _minRecordingMinutes.toDouble(),
                  max: _maxRecordingMinutes.toDouble(),
                  divisions: _maxRecordingMinutes - _minRecordingMinutes, // 1분 단위로 조절
                  label: '${_currentSetting.detectionRecordingMinutes}분', // 슬라이더 조절 시 표시되는 라벨
                  onChanged: (double newValue) {
                    setState(() {
                      _currentSetting.detectionRecordingMinutes = newValue.round();
                    });
                  },
                ),
                Row( // 최소/최대 값 텍스트 표시 (선택 사항)
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('최소 ${_minRecordingMinutes}분', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    Text('최대 ${_maxRecordingMinutes}분', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          // 영상 화질 설정
          ListTile(
            title: const Text('영상 화질'),
            subtitle: Text(videoQualityText), // 선택된 화질 표시
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final selected = await _showVideoQualitySelectionDialog();
              if (selected != null) {
                setState(() {
                  _currentSetting.selectedVideoQuality = selected;
                });
              }
            },
          ),
          const Divider(),

          // 설정 저장 버튼
          Padding(
            padding: const EdgeInsets.all(20.0), // 통일성 있게 수평 패딩 20
            child: ElevatedButton(
              onPressed: () {
                print('영상 설정 저장됨:');
                print('  저장 길이: ${_currentSetting.detectionRecordingMinutes}분 (총 ${totalRecordingMinutes}분)');
                print('  영상 화질: $videoQualityText');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('영상 설정이 저장되었습니다.')),
                );
                // TODO: 실제 설정 값 저장 로직 구현 (shared_preferences 등)
              },
              child: const Text('설정 저장'),
            ),
          ),
        ],
      ),
    );
  }
}