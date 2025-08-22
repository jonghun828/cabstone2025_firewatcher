import 'package:flutter/material.dart';
import '../models/sensor.dart';

class ZoneDetailPage extends StatelessWidget {
  final Sensor sensor;

  const ZoneDetailPage({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${sensor.areaName} (${sensor.sensorNumber})'), // AppBar 타이틀에 구역 정보 표시
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                '연결 상태: ${sensor.isConnected ? '양호' : '불안정'}',
                style: TextStyle(
                  fontSize: 18,
                  color: sensor.isConnected ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '센서 번호: ${sensor.sensorNumber}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              // TODO: 여기에 구역별 센서 상세 현황 (온도, 연기 농도 등) 및 실시간 영상 스트리밍 위젯 추가
              const Text(
                '실시간 영상 및 센서 데이터',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}