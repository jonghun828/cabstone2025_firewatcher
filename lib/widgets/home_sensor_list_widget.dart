// lib/widgets/home_sensor_list_widget.dart

import 'package:flutter/material.dart';
import '../models/sensor_data.dart'; // SensorData 모델 import
import '../pages/zone_detail_page.dart'; // ZoneDetailPage import

class HomeSensorListWidget extends StatelessWidget {
  final List<SensorData> sensorList; // 외부에서 받을 센서 데이터 리스트

  const HomeSensorListWidget({
    Key? key,
    required this.sensorList, // 생성자를 통해 sensorList를 필수로 받도록 합니다.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Column 내부의 위젯을 수직 중앙 정렬
      children: [
        Center( // 센서 박스를 수평 중앙 정렬
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0), // 박스의 좌우 패딩 설정
            child: SizedBox( // 박스의 높이 제한
              height: 390.0, // 고정 높이 400.0
              child: Container( // 실제 박스 (ListView를 포함)
                decoration: BoxDecoration(
                  color: Colors.white, // 배경색
                  borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                  boxShadow: [ // 그림자 효과
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15), // 그림자 색상 및 강도
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0), // 박스 내부 상하 패딩
                child: ListView.builder(
                  itemCount: sensorList.length, // 전달받은 sensorList 사용
                  itemBuilder: (context, index) {
                    final sensor = sensorList[index]; // 전달받은 sensorData 사용
                    return InkWell( // Card를 InkWell로 감싸서 클릭 가능하게 함
                      borderRadius: BorderRadius.circular(8), // InkWell의 ripple 효과가 Card의 모서리와 일치하도록
                      onTap: () { // InkWell의 onTap 속성
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZoneDetailPage(sensor: sensor), // 클릭된 sensor 객체를 넘겨줍니다.
                          ),
                        );
                      },
                      child: Card( // InkWell의 자식인 Card 위젯
                        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Card의 마진
                        elevation: 0, // Card 그림자 제거
                        shape: RoundedRectangleBorder( // Card 모서리 둥글게
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding( // Card 내부 콘텐츠 패딩
                          padding: const EdgeInsets.all(12.0),
                          child: Row( // 센서 정보를 가로로 배치
                            children: [
                              Container( // 연결 상태 원형 표시
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: sensor.isConnected ? Colors.green : Colors.red, // 연결 상태에 따라 색상 변경
                                ),
                              ),
                              const SizedBox(width: 12), // 간격
                              Expanded( // 구역 이름은 남은 공간을 차지하도록
                                child: Text(
                                  sensor.areaName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8), // 간격
                              Text( // 카메라 번호 표시
                                '${sensor.cameraNumber}',
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