import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	final TextEditingController _buf = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          Expanded(
						child: TextField(
							controller: _buf,
							decoration: InputDecoration(
								hintText: "Dán text vào đây",
								border: OutlineInputBorder(
									borderRadius: BorderRadius.all(10.0)
								)
							),
							keyboardType: TextInputType.multiline,
							textInputAction: TextInputAction.newline,
							maxLines: 10
						)
          ),
        )
      )
    );
  }
}
