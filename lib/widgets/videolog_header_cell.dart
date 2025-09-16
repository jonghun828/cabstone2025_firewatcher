import 'package:flutter/material.dart';

class VideoLogHeaderCell extends StatelessWidget {
  final String title; // 제목 텍스트
  final int flex;     // 공간의 flex 비율

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