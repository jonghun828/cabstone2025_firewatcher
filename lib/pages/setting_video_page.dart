// lib/pages/setting_video_page.dart

import 'package:flutter/material.dart';
import '../models/video_setting.dart';

/// 영상 설정 정보를 관리하는 페이지.
///
/// 저장되는 영상의 길이(감지 전후 시간)와 화질을 설정할 수 있습니다.
class SettingVideoPage extends StatefulWidget {
  const SettingVideoPage({super.key});

  @override
  State<SettingVideoPage> createState() => _SettingVideoPageState();
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

  /// 영상 길이 선택 다이얼로그를 띄우고 선택된 값을 반환합니다.
  Future<int?> _showVideoLengthSelectionDialog() async {
    int? dialogSelectedLength = _currentSetting.detectionRecordingMinutes; // 다이얼로그 내부 상태 변수

    return showDialog<int>( // 정수형 타입으로 반환하도록 제네릭 변경
      context: context,
      builder: (BuildContext dialogContext) { // 다이얼로그 컨텍스트
        return AlertDialog(
          title: const Text('저장 영상 길이 선택'),
          content: StatefulBuilder( // 다이얼로그 내부의 상태 변화를 반영하기 위해 StatefulBuilder 사용
            builder: (BuildContext innerContext, StateSetter innerSetState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // 정수 값에 대한 라디오 버튼 리스트를 동적으로 생성
                  children: List.generate(_maxRecordingMinutes - _minRecordingMinutes + 1, (index) {
                    final length = _minRecordingMinutes + index;
                    return RadioListTile<int>(
                      title: Text('$length분'),
                      value: length,
                      groupValue: dialogSelectedLength,
                      onChanged: (int? value) {
                        innerSetState(() { // innerSetState를 사용하여 다이얼로그 내부 UI 업데이트
                          dialogSelectedLength = value;
                        });
                      },
                    );
                  }),
                ),
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
                Navigator.of(dialogContext).pop(dialogSelectedLength);
              },
            ),
          ],
        );
      },
    );
  }

  /// 영상 화질 선택 다이얼로그를 띄우고 선택된 값을 반환합니다.
  Future<VideoQuality?> _showVideoQualitySelectionDialog() async {
    VideoQuality? dialogSelectedQuality = _currentSetting.selectedVideoQuality; // 다이얼로그 내부 상태 변수

    return showDialog<VideoQuality>(
      context: context,
      builder: (BuildContext dialogContext) { // 다이얼로그 컨텍스트
        return AlertDialog(
          title: const Text('영상 화질 선택'),
          content: StatefulBuilder( // 다이얼로그 내부의 상태 변화를 반영하기 위해 StatefulBuilder 사용
            builder: (BuildContext innerContext, StateSetter innerSetState) {
              return SingleChildScrollView(
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
                      groupValue: dialogSelectedQuality, // 다이얼로그 내부 상태 변수 사용
                      onChanged: (VideoQuality? value) {
                        innerSetState(() { // innerSetState를 사용하여 다이얼로그 내부 UI 업데이트
                          dialogSelectedQuality = value;
                        });
                      },
                    );
                  }).toList(),
                ),
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
                Navigator.of(dialogContext).pop(dialogSelectedQuality);
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
          // 녹화본 길이 설정 (슬라이더 사용)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text( // 텍스트 수정: '저장 영상 길이'에서 '녹화본 길이 설정'으로
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
                  divisions: _maxRecordingMinutes - _minRecordingMinutes,
                  label: '${_currentSetting.detectionRecordingMinutes}분',
                  onChanged: (double newValue) {
                    setState(() {
                      _currentSetting.detectionRecordingMinutes = newValue.round();
                    });
                  },
                ),
                Row( // 최소/최대 값 텍스트 표시
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
            subtitle: Text(videoQualityText),
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