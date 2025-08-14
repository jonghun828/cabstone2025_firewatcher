// lib/widgets/video_log_data_cell.dart

import 'package:flutter/material.dart';

class VideoLogDataCell extends StatelessWidget {
  final Widget child;
  final int flex;

  const VideoLogDataCell({
    Key? key,
    required this.child,
    required this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: child,
      ),
    );
  }
}