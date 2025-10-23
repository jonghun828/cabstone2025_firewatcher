// lib/widgets/sensor_card.dart

import 'package:flutter/material.dart';
import '../models/sensor.dart'; // Sensor 모델 import

class SensorCard extends StatelessWidget {
  final Sensor sensor;
  final VoidCallback onTap;

  const SensorCard({
    super.key,
    required this.sensor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusDot = Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: sensor.isConnected ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                statusDot,
                const SizedBox(width: 12),
                Text(
                  // 'A-숲'과 같이 표시하기 위해 fullDisplayName 사용
                  sensor.fullDisplayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}