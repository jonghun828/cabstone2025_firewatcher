// lib/widgets/video_log_header_cell.dart

import 'package:flutter/material.dart';

class VideoLogHeaderCell extends StatelessWidget {
  final String title;
  final int flex;

  const VideoLogHeaderCell({
    Key? key,
    required this.title,
    required this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}