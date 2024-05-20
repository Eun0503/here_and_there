import 'package:flutter/material.dart';
import 'Mapview.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 표시 제거
      home: MapView(),
    );
  }
}
