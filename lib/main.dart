import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'isolate_worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final status = await Permission.manageExternalStorage.request();
  if (status.isPermanentlyDenied) {
    await openAppSettings();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JiebaPage(),
    );
  }
}

class JiebaPage extends StatefulWidget {
  const JiebaPage({super.key});

  @override
  State<JiebaPage> createState() => _JiebaPageState();
}

class _JiebaPageState extends State<JiebaPage> {
  final TextEditingController ctrl = TextEditingController();

  SendPort? isolateSend; // gửi text sang isolate
  late ReceivePort mainPort; // nhận kết quả
  String output = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    initIsolate();
  }

  Future<void> initIsolate() async {
    mainPort = ReceivePort();

    // Tạo isolate
    final isolate = await Isolate.spawn(jiebaIsolate, mainPort.sendPort);

    // Chờ isolate phản hồi sendPort
    isolateSend = await mainPort.first as SendPort;

    // Lắng nghe kết quả từ isolate
    mainPort.listen((msg) {
      setState(() {
        loading = false;
        output = msg;
      });
    });
  }

  void runSegmentation() {
    if (isolateSend == null) return;

    setState(() {
      loading = true;
      output = "Đang xử lý...";
    });

    isolateSend!.send(ctrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jieba Isolate Engine")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: ctrl,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nhập tiếng Trung...",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: loading ? null : runSegmentation,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Phân tách"),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: SelectionArea(
                child: SingleChildScrollView(
                  child: Text(output),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
