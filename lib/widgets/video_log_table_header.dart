// lib/widgets/video_log_table_header.dart

import 'package:flutter/material.dart';
import 'video_log_header_cell.dart'; // 헤더 셀 위젯 import

class VideoLogTableHeader extends StatelessWidget {
  final Map<String, int> columnFlex;

  const VideoLogTableHeader({
    Key? key,
    required this.columnFlex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        children: [
          VideoLogHeaderCell(title: '날짜', flex: columnFlex['date']!),
          VideoLogHeaderCell(title: '구역', flex: columnFlex['detectedArea']!),
          VideoLogHeaderCell(title: '감지기', flex: columnFlex['detector']!),
          VideoLogHeaderCell(title: '담당자', flex: columnFlex['areaManager']!),
          VideoLogHeaderCell(title: '시간', flex: columnFlex['detectionTime']!),
          VideoLogHeaderCell(title: '상태', flex: columnFlex['status']!),
          VideoLogHeaderCell(title: '실화', flex: columnFlex['isRealFire']!),
        ],
      ),
    );
  }
}