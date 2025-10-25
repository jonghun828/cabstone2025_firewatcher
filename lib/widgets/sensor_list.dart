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
    // 💡 ZonePage에서 사용한 ID 매핑 로직을 재사용 (실제로는 API 응답에서 ID를 직접 받아야 함)
    final Map<String, int> zoneMap = const {'A': 0, 'B': 1, 'C': 2, 'D': 3};

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: 390.0,
              child: Container(
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
                    final zoneId = zoneMap[sensor.areaName] ?? 0;
                    final zoneName = sensor.areaName;

                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // 💡 ZoneDetailPage로 이동 시 ID와 Name을 전달하도록 수정
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZoneDetailPage(zoneId: zoneId, zoneName: zoneName),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
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