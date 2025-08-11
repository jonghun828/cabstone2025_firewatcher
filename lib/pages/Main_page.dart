import 'package:flutter/material.dart';

// 센서 데이터를 위한 간단한 모델 정의
class SensorData {
  final String areaName;
  final String cameraNumber;
  final bool isConnected; // true: 양호(초록), false: 불안정/끊김(빨강)

  SensorData({
    required this.areaName,
    required this.cameraNumber,
    required this.isConnected,
  });
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // 하단 네비게이션 바 선택 인덱스

  // 임시 센서 데이터 (나중에는 실제 데이터를 받아와서 사용할 부분)
  final List<SensorData> _sensorList = [
    SensorData(areaName: '구역 A', cameraNumber: 'CAM-001', isConnected: true),
    SensorData(areaName: '구역 B', cameraNumber: 'CAM-002', isConnected: false), // 연결 끊김/불안정 예시
    SensorData(areaName: '구역 C', cameraNumber: 'CAM-003', isConnected: true),
    SensorData(areaName: '구역 D', cameraNumber: 'CAM-004', isConnected: true),
    SensorData(areaName: '구역 E', cameraNumber: 'CAM-005', isConnected: false), // 연결 끊김/불안정 예시
    SensorData(areaName: '구역 F', cameraNumber: 'CAM-006', isConnected: true),
    SensorData(areaName: '구역 G', cameraNumber: 'CAM-007', isConnected: true),
    SensorData(areaName: '구역 H', cameraNumber: 'CAM-008', isConnected: true),
    SensorData(areaName: '구역 I', cameraNumber: 'CAM-009', isConnected: false),
    SensorData(areaName: '구역 J', cameraNumber: 'CAM-010', isConnected: true),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // 실제 앱에서는 index에 따라 다른 페이지를 보여주거나 다른 기능을 수행합니다.
    // 예를 들어, 새로운 화면으로 전환하는 Navigator.push(context, MaterialPageRoute(builder: (context) => YourNewPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('산불 감지 시스템'),
        actions: [
          // 알림 아이콘
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 알림 페이지로 이동 또는 알림 기능 구현
              print('알림 아이콘 클릭');
            },
          ),
          // 프로필 아이콘
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: 프로필 페이지로 이동 또는 프로필 기능 구현
              print('프로필 아이콘 클릭');
            },
          ),
          // 로그아웃 아이콘
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/'); // 로그아웃 시 로그인 페이지로 이동
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // '구역별 센서 연결 현황' 제목은 삭제되었습니다.

          Spacer(), // 센서 박스와 상단(AppBar) 사이 공간 확보 (수직 중앙 정렬을 위해)

          // 센서 현황 박스: 좌우 여백 30, 높이 500, 수평 및 수직 중앙 정렬, 리스트 바 간격 증가
          Center( // 박스를 수평 중앙 정렬
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0), // 좌우 패딩을 30.0으로 설정
              child: SizedBox( // 박스의 높이 제한
                height: 400.0, // 고정 높이 500.0 (원하는 높이로 조절 가능)
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
                  padding: const EdgeInsets.symmetric(vertical: 9.0), // 박스 내부 상하 패딩
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _sensorList.length,
                    itemBuilder: (context, index) {
                      final sensor = _sensorList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 각 바(Card)끼리 수직 간격을 8.0으로 늘림
                        elevation: 0, // 컨테이너에 그림자를 주었으므로 카드의 그림자는 제거
                        shape: RoundedRectangleBorder( // 카드 모서리 둥글게
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0), // 카드 내부 패딩
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: sensor.isConnected ? Colors.green : Colors.red, // 연결 상태에 따라 색상 변경
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded( // 구역 이름은 남은 공간을 차지하도록
                                child: Text(
                                  sensor.areaName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${sensor.cameraNumber})',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          Spacer(), // 박스와 하단(BottomNavigationBar) 사이 공간 확보 (수직 중앙 정렬을 위해)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar( // 하단 메뉴바
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '메뉴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: '영상기록',
          ),
          BottomNavigationBarItem( // <-- '홈' 메뉴가 추가되었습니다.
            icon: Icon(Icons.home), // 홈 아이콘
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: '구역',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex, // 현재 선택된 아이템 인덱스
        selectedItemColor: Theme.of(context).primaryColor, // 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
        onTap: _onItemTapped, // 아이템 탭 시 호출될 함수
        type: BottomNavigationBarType.fixed, // 4개 이상 아이템 시 레이아웃 고정
      ),
    );
  }
}