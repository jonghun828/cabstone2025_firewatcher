// lib/pages/zone_page.dart

import 'package:flutter/material.dart';
import '../models/sensor.dart';
import '../widgets/sensor_card.dart';
import 'zone_detail_page.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  // 💡 SegmentedButton은 Set<T>를 선택 값으로 받으므로 타입을 변경합니다.
  Set<String> _selectedZone = {'A'}; // 기본 선택 구역 (단일 선택이므로 Set에 하나만 포함)

  // 임시 센서 데이터 (locationName 필드 포함, sensorType 추가)
  final List<Sensor> _allSensors = [
    Sensor(areaName: 'A', sensorNumber: 'C-001', locationName: '숲', sensorType: SensorType.camera, isConnected: true),
    Sensor(areaName: 'A', sensorNumber: 'S-002', locationName: '산책로', sensorType: SensorType.smokeSensor, isConnected: false), // 비정상
    Sensor(areaName: 'A', sensorNumber: 'H-003', locationName: '정문', sensorType: SensorType.temperatureSensor, isConnected: true),
    Sensor(areaName: 'B', sensorNumber: 'C-001', locationName: '주차장', sensorType: SensorType.camera, isConnected: true),
    Sensor(areaName: 'B', sensorNumber: 'H-002', locationName: '계곡', sensorType: SensorType.humiditySensor, isConnected: false), // 비정상
    Sensor(areaName: 'C', sensorNumber: 'S-001', locationName: '캠핑장', sensorType: SensorType.smokeSensor, isConnected: true),
    Sensor(areaName: 'C', sensorNumber: 'C-002', locationName: '야외무대', sensorType: SensorType.camera, isConnected: true),
    Sensor(areaName: 'D', sensorNumber: 'C-001', locationName: '후문', sensorType: SensorType.camera, isConnected: true),
    Sensor(areaName: 'D', sensorNumber: 'S-002', locationName: '놀이터', sensorType: SensorType.smokeSensor, isConnected: true),
    Sensor(areaName: 'D', sensorNumber: 'H-003', locationName: '자전거길', sensorType: SensorType.windSensor, isConnected: false), // 비정상
  ];

  List<Sensor> get _filteredSensors {
    // _selectedZone이 Set이므로, .first를 사용하여 현재 선택된 구역 이름을 가져옵니다.
    final currentZone = _selectedZone.isEmpty ? '' : _selectedZone.first;
    return _allSensors.where((sensor) => sensor.areaName == currentZone).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 사용 가능한 모든 구역 이름 가져오기 (예: 'A', 'B', 'C', 'D')
    final List<String> availableZones = _allSensors.map((s) => s.areaName).toSet().toList()..sort();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: SizedBox(
              width: double.infinity, // 부모 너비에 꽉 차도록
              child: SegmentedButton<String>(
                segments: availableZones.map((zone) => ButtonSegment<String>(
                  value: zone,
                  label: Text(zone),
                )).toList(),
                selected: _selectedZone,
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedZone = newSelection; // 단일 선택이므로 Set에 하나만 들어옵니다.
                  });
                },
                multiSelectionEnabled: false, // 👈 단일 선택만 허용
                emptySelectionAllowed: false,  // 👈 최소 하나는 항상 선택되어 있도록
                showSelectedIcon: false,       // 👈 선택된 항목의 체크 표시 제거
                style: SegmentedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700, // 기본 텍스트 색상
                  selectedForegroundColor: Colors.white,   // 선택 시 텍스트 색상
                  selectedBackgroundColor: Colors.blue,    // 선택 시 배경색
                  side: BorderSide(color: Colors.grey.shade300), // 테두리 색상
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 필터링된 센서 목록
          Expanded(
            child: _filteredSensors.isEmpty
                ? const Center(child: Text('선택된 구역에 센서가 없습니다.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredSensors.length,
                    itemBuilder: (context, index) {
                      final sensor = _filteredSensors[index];
                      return SensorCard(
                        sensor: sensor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZoneDetailPage(sensor: sensor),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}