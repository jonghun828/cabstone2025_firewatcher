import 'package:flutter/material.dart';

class VideoLogDataCell extends StatelessWidget {
  final Widget child; // 데이터 셀 내부에 표시될 실제 위젯
  final int flex;     // 공간의 flex 비율

  /// VideoLogDataCell 생성자.
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