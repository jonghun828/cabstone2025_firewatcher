// lib/widgets/home_sensor_list_widget.dart (수정)

import 'package:flutter/material.dart';
import '../models/sensor.dart';
import '../pages/zone_detail_page.dart';

class HomeSensorListWidget extends StatelessWidget {
  final List<Sensor> sensorList;

  const HomeSensorListWidget({
    Key? key,
    required this.sensorList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Note: zoneMap은 이 위젯에서 필요 없지만, 이전 코드의 구조를 유지했습니다.
    // final Map<String, int> zoneMap = const {'A': 0, 'B': 1, 'C': 2, 'D': 3};

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: 390.0,
              child: Container( // 센서 현황 리스트
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                  itemCount: sensorList.length,
                  itemBuilder: (context, index) {
                    final sensor = sensorList[index];
                    // final zoneId = zoneMap[sensor.areaName] ?? 0;
                    // final zoneName = sensor.areaName;

                    return InkWell( // 카드 클릭 이벤트 처리
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZoneDetailPage(sensor: sensor),
                          ),
                        );
                      },
                      child: Card( // 각 센서 항목
                        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container( // 연결 상태
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: sensor.isConnected ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  sensor.areaName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${sensor.sensorNumber})',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}