import 'dart:isolate';
import 'package:jieba_flutter/analysis/jieba_segmenter.dart';

void jiebaIsolate(SendPort sendPort) async {
  // Port nhận message từ UI
  final port = ReceivePort();

  // Gửi ReceivePort sang UI để UI gửi message về isolate
  sendPort.send(port.sendPort);

  final seg = JiebaSegmenter(); // tạo 1 lần duy nhất

  await for (final text in port) {
    final list = seg.process(text as String, SegMode.SEARCH);
    final result = list.map((e) => e.word).join("\n");

    sendPort.send(result);
  }
}
