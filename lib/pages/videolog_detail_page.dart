// lib/pages/videolog_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';

class VideoLogDetailPage extends StatelessWidget {
  final VideoLog log;

  const VideoLogDetailPage({super.key, required this.log});

  // 상태에 따른 색상 반환 헬퍼 함수 (오인도 완료와 동일하게 초록색 처리)
  Color _getStatusColor(String status) {
    switch (status) {
      case '감지':
        return Colors.orange;
      case '처리중':
        return Colors.blue;
      case '완료':
      case '오인':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  // 정보 표시를 위한 재사용 가능한 Row 위젯
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

  // 타임라인 단계 위젯
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

  // 타임라인 데이터 생성 함수 (2단계: 감지 -> 완료)
  List<Map<String, dynamic>> _generateTimeline() {
    final DateTime detectionTime = log.detectionTime;
    final String currentStatus = log.status;

    final List<Map<String, dynamic>> steps = [
      {'title': '감지', 'time': detectionTime, 'isComplete': true}, // 감지는 항상 완료
    ];

    // 완료 또는 오인 상태일 경우, 두 번째 단계를 '완료'로 완료 표시
    if (currentStatus == '완료' || currentStatus == '오인') {
      steps.add({
        'title': '완료',
        'time': detectionTime.add(const Duration(minutes: 15)), // 임의의 완료 시간
        'isComplete': true,
      });
    } else {
       // 처리중이거나 감지 상태일 경우, 완료는 미완료로 표시
       steps.add({
        'title': '완료',
        'time': detectionTime.add(const Duration(minutes: 15)),
        'isComplete': false,
      });
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> timelineSteps = _generateTimeline();

    return Scaffold(
      appBar: AppBar(
        title: const Text('영상 기록 상세'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 감지된 구역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  log.detectedArea,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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

            // 사건 처리 진행 상황 타임라인 섹션
            const Text(
              '사건 처리 진행 상황',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 타임라인 단계 렌더링
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: timelineSteps.map((step) {
                final int index = timelineSteps.indexOf(step);
                final bool isLast = index == timelineSteps.length - 1;
                final bool isStepComplete = step['isComplete'] as bool;

                return _buildTimelineStep(
                  title: step['title'] as String,
                  time: step['time'] as DateTime,
                  isComplete: isStepComplete,
                  isLast: isLast,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // 상세 정보
            _buildInfoRow('사건 번호', '#${log.incidentNumber}'),
            _buildInfoRow('감지기 유형', log.detectorType.toString().split('.').last),
            // 담당 관리자 정보는 현재 API에 없어 잠시 숨김
            // _buildInfoRow('담당 관리자', log.areaManager),
          ],
        ),
      ),
    );
  }
}