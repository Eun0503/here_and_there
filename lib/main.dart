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
  Offset? _pinOffset;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onImageTap(TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      _pinOffset = localOffset;
    });
    print("Tapped position: $localOffset");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: '비둘기 모임'),
      body: Center(
        child: GestureDetector(
          onTapUp: _onImageTap,
          child: Stack(
            children: [
              Image.asset(
                'assets/map.png', // 지도 이미지 파일 경로
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              if (_pinOffset != null)
                Positioned(
                  left: _pinOffset!.dx - 24, // 핀의 중심을 클릭한 위치에 맞추기 위해 보정
                  top: _pinOffset!.dy - 48,  // 핀의 크기에 맞게 보정
                  child: Icon(
                    Icons.location_on,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
            ],
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

