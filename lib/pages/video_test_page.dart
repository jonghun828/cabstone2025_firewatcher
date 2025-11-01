import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/html.dart';

class VideoStreamPage extends StatefulWidget {
  const VideoStreamPage({
    Key? key,
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
    final url = 'ws://localhost:8764/cam1';
    channel = kIsWeb
        ? HtmlWebSocketChannel.connect(url)
        : IOWebSocketChannel.connect(url);
    channel.stream.listen((data) {
      final decoded = base64Decode(data);
      frameNotifier.value = decoded; // ✅ 여기서만 변경
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ValueListenableBuilder<Uint8List?>(
          valueListenable: frameNotifier,
          builder: (context, frame, _) {
            if (frame == null) {
              return const CircularProgressIndicator();
            }
            return Image.memory(
              frame,
              gaplessPlayback: true, // 👈 깜빡임 방지
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
