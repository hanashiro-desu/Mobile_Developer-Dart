import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    // Trả về Scaffold - widget cung cấp bố cục Material Design cơ bản
    // Màn hình
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        title: Text("App 02"),
      ), // AppBar
      backgroundColor: Colors.amberAccent,
      body: Center(child: Text("Nội dung chính")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ), // FloatingActionButton
    );
  }
}