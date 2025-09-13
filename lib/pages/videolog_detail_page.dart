// lib/pages/videolog_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart'; // VideoLog 모델 import

class VideoLogDetailPage extends StatelessWidget {
  final VideoLog log;

  const VideoLogDetailPage({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 기록'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 진행도 현황 섹션
            const Text(
              '진행 현황',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildProgressStatus(),
            const SizedBox(height: 30),

            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 30),

            // 2. 상세 정보 섹션
            const Text(
              '상세 정보',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('감지된 구역', log.detectedArea),
            _buildInfoRow('감지한 기기', '${log.detectorType.koreanName} ${log.detectorNumber}번'),
            _buildInfoRow('심각도', log.severity.koreanName),
            _buildInfoRow('담당자', log.areaManager),
            _buildInfoRow('최초 감지 시간', DateFormat('yyyy.MM.dd HH:mm:ss').format(log.detectionTime)),
          ],
        ),
      ),
    );
  }

  // 진행도 위젯을 구성하는 함수
  Widget _buildProgressStatus() {
    final List<String> statusList = ['감지', '처리중', '완료/오인'];
    // log.status에 따라 현재 진행 단계를 찾음
    // '완료'나 '오인'인 경우 마지막 단계로 간주
    final int currentStatusIndex = statusList.indexOf(log.status);
    final isCompleted = log.status == '완료' || log.status == '오인';


    return Column(
      children: List.generate(statusList.length, (index) {
        final String statusText = statusList[index];
        final bool isCurrent = (index == currentStatusIndex && !isCompleted) || (index == statusList.length -1 && isCompleted);
        final bool isPast = index < currentStatusIndex || (index < statusList.length -1 && isCompleted) || (index == statusList.length -1 && isCompleted);


        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isPast ? Colors.blue : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                  child: isPast
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : isCurrent
                          ? const Icon(Icons.access_time, size: 16, color: Colors.white)
                          : null,
                ),
                if (index < statusList.length - 1)
                  Container(
                    width: 2,
                    height: 50,
                    color: isPast ? Colors.blue : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPast ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    if (isCurrent && !isCompleted) // 현재 진행중인 단계에만 '현재 진행중' 표시
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '현재 진행중',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ),
                    if (index == 0 && (isPast || isCurrent)) // '감지' 단계에만 감지 시간 표시
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          DateFormat('yyyy년 M월 d일 H시 m분').format(log.detectionTime),
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ),
                    if (isCompleted && index == statusList.length - 1) // 마지막 단계 완료 시 완료 시간 (예시)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '${log.status}됨', // 실제 완료/오인 시간은 모델에 없으므로 임시 텍스트
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // 상세 정보 항목을 구성하는 함수
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}