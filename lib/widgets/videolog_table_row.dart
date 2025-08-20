import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';
import 'videolog_data_cell.dart';

class VideoLogTableRow extends StatelessWidget {
  final VideoLog log;
  final Map<String, int> columnFlex;
  final VoidCallback onTap;

  const VideoLogTableRow({
    Key? key,
    required this.log,
    required this.columnFlex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VideoLogDataCell(
              flex: columnFlex['date']!,
              child: Text(DateFormat('MM/dd').format(log.detectionTime)),
            ),
            VideoLogDataCell(
              flex: columnFlex['detectedArea']!,
              child: Text(log.detectedArea),
            ),
            VideoLogDataCell(
              flex: columnFlex['detector']!,
              child: Text(log.detectorName),
            ),
            VideoLogDataCell(
              flex: columnFlex['areaManager']!,
              child: Text(log.areaManager),
            ),
            VideoLogDataCell(
              flex: columnFlex['detectionTime']!,
              child: Text(DateFormat('HH:mm').format(log.detectionTime)),
            ),
            VideoLogDataCell(
              flex: columnFlex['status']!,
              child: Text(log.status),
            ),
            VideoLogDataCell(
              flex: columnFlex['isRealFire']!,
              child: Text(
                log.isRealFire ? 'O' : 'X',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: log.isRealFire ? Colors.red : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}