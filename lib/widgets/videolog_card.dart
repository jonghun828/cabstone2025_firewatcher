// lib/widgets/videolog_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';

class VideoLogCard extends StatelessWidget {
  final VideoLog log;
  final VoidCallback onTap;

  const VideoLogCard({
    Key? key,
    required this.log,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (log.status) {
      case '감지':
        statusColor = Colors.orange;
        break;
      case '처리중':
        statusColor = Colors.blue;
        break;
      case '완료':
        statusColor = Colors.green;
        break;
      case '오인':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.black;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // 카드에 테두리 스타일 추가된 부분
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy.MM.dd').format(log.detectionTime),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    log.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _buildInfoRow('구역', log.detectedArea),
            _buildInfoRow('담당자', log.areaManager),
            _buildInfoRow('시간', DateFormat('HH:mm').format(log.detectionTime)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}