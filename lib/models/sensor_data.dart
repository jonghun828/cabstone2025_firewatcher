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