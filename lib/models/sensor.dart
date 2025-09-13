class Sensor {
  final String areaName;      // 구역 이름
  final String sensorNumber;  // 연결된 카메라/센서 번호
  final bool isConnected;     // 연결 상태

  const Sensor({
    required this.areaName,
    required this.sensorNumber,
    required this.isConnected,
  });
}