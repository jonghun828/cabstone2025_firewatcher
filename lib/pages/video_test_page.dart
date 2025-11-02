import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/html.dart';

import '../models/sensor.dart';

class VideoStreamPage extends StatefulWidget {
  final Sensor sensor;
  const VideoStreamPage({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  @override
  _VideoStreamPageState createState() => _VideoStreamPageState();
}

class _VideoStreamPageState extends State<VideoStreamPage> {
  late WebSocketChannel channel;
  final ValueNotifier<Uint8List?> frameNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    final url = widget.sensor.areaIpAddress;
    channel = kIsWeb
        ? HtmlWebSocketChannel.connect(url)
        : IOWebSocketChannel.connect(url);

    channel.stream.listen((data) {
      try {
        // JSON으로 파싱 시도
        final msg = jsonDecode(data);

        if (msg['type'] == 'alert' && msg['event'] == 'fire_detected') {
          _showFireAlert(context);
          return;
        }

        // frame 데이터 처리
        if (msg['type'] == 'frame' && msg['data'] != null) {
          final decoded = base64Decode(msg['data']);
          frameNotifier.value = decoded;
        }
      } catch (e) {
        print('⚠️ WebSocket data parse error: $e');
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _showFireAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🔥 화재 감지'),
        content: const Text('불이 10초 이상 감지되었습니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text('${widget.sensor.areaName} (${widget.sensor.sensorNumber})'),
      ),
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<Uint8List?>(
        valueListenable: frameNotifier,
        builder: (context, frame, _) {
          if (frame == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.memory(
                  frame,
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
