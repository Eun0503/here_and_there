import 'package:flutter/material.dart';
import 'package:here_and_there/bottom_bar.dart';
import 'package:here_and_there/topbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: '비둘기 모임'),
    body: Center(
    child: Container(
    width: double.infinity,
    height: double.infinity,
    child: Image.asset(
    'assets/map.png', // 지도 이미지 파일 경로
    fit: BoxFit.cover,


        ),
      ),
    ),

      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
