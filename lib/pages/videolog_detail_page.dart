// lib/pages/videolog_detail_page.dart (타임라인 기능 복원)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';

class VideoLogDetailPage extends StatelessWidget {
  final VideoLog log;

  const VideoLogDetailPage({super.key, required this.log});

  // 심각도에 따른 색상 반환 헬퍼 함수 (이전 코드 유지)
  Color _getSeverityColor(Severity severity) {
    switch (severity) {
      case Severity.low:
        return Colors.green;
      case Severity.medium:
        return Colors.orange;
      case Severity.high:
        return Colors.red;
    }
  }

  // 상태에 따른 색상 반환 헬퍼 함수 (이전 코드 유지)
  Color _getStatusColor(String status) {
    switch (status) {
      case '감지':
        return Colors.orange;
      case '처리중':
        return Colors.blue;
      case '완료':
        return Colors.green;
      case '오인':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  // 정보 표시를 위한 재사용 가능한 Row 위젯 (이전 코드 유지)
  Widget _buildInfoRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$title:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: valueColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // 🚨 타임라인 단계 위젯 (파란색 선, 체크 아이콘, 시간 표기)
  Widget _buildTimelineStep({
    required String title,
    required DateTime time,
    required bool isComplete,
    required bool isLast,
  }) {
    final Color primaryColor = isComplete ? Colors.blue : Colors.grey.shade400;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // 아이콘 (체크 또는 원)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: isComplete
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Icon(Icons.circle, size: 10, color: Colors.white),
            ),
            // 파란색 연결선
            if (!isLast)
              Container(
                width: 2,
                height: 50, // 선의 길이
                color: primaryColor,
              ),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 단계 제목
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            // 시간 표기
            Text(
              DateFormat('HH:mm:ss').format(time),
              style: TextStyle(
                fontSize: 14,
                color: isComplete ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 🚨 가상 타임라인 데이터 생성 함수
  List<Map<String, dynamic>> _generateTimeline() {
    // 실제 데이터가 없으므로, 현재 상태를 기준으로 가상의 시간차를 적용합니다.
    final DateTime detectionTime = log.detectionTime;
    final String currentStatus = log.status;

    final List<Map<String, dynamic>> steps = [
      {'title': '감지', 'time': detectionTime},
      {'title': '처리중', 'time': detectionTime.add(const Duration(minutes: 5))},
    ];

    if (currentStatus == '완료' || currentStatus == '오인') {
      steps.add({
        'title': currentStatus,
        'time': detectionTime.add(const Duration(minutes: 15))
      });
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> timelineSteps = _generateTimeline();
    final String currentStatus = log.status;

    return Scaffold(
      appBar: AppBar(
        title: const Text('영상 기록 상세'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (기존 정보 표시 부분 유지)
            // 감지된 구역 및 심각도 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  log.detectedArea,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(log.severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getSeverityColor(log.severity)),
                  ),
                  child: Text(
                    log.severity.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: _getSeverityColor(log.severity),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 감지 시간 및 상태
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy년 MM월 dd일 HH:mm').format(log.detectionTime),
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(log.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    log.status,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // TODO: 여기에 실제 영상 스트리밍 위젯 또는 캡처 이미지 표시
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Center(
                child: Text(
                  '영상 스트림 또는 캡처 이미지',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🚨 진행 상황 타임라인 섹션
            const Text(
              '사건 처리 진행 상황',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 타임라인 단계들을 렌더링
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: timelineSteps.map((step) {
                final int index = timelineSteps.indexOf(step);
                final bool isLast = index == timelineSteps.length - 1;

                // 현재 상태와 타임라인 단계를 비교하여 완료 여부 결정
                bool isComplete;
                if (currentStatus == '완료' || currentStatus == '오인') {
                    isComplete = true; // 최종 상태가 '완료'나 '오인'이면 모든 이전 단계는 완료
                } else if (currentStatus == '처리중') {
                    isComplete = (step['title'] != '처리중' && step['title'] != '감지'); // '감지'만 완료
                    if (step['title'] == '감지') isComplete = true; // '감지'는 완료
                } else { // '감지' 상태일 경우
                    isComplete = step['title'] == '감지';
                }

                return _buildTimelineStep(
                  title: step['title'] as String,
                  time: step['time'] as DateTime,
                  isComplete: isComplete,
                  isLast: isLast,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // 상세 정보 (이전 코드 유지)
            _buildInfoRow('사건 번호', '#${log.incidentNumber}'),
            _buildInfoRow('감지기 유형', log.detectorType.toString().split('.').last),
            _buildInfoRow('감지기 번호', log.detectorNumber.toString()),
            _buildInfoRow('담당 관리자', log.areaManager),
            _buildInfoRow(
              '실제 화재 여부',
              log.isRealFire ? '실제 화재' : '오인 감지',
              valueColor: log.isRealFire ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}