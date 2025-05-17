 import 'package:flutter/material.dart';
import 'pages/scan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rótulo Acessível',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScanPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}