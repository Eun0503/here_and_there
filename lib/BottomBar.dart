import 'package:flutter/material.dart';
import 'List.dart'; // List.dart 파일을 import

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: '친구',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '방 설정',
        ),
      ],
    );
  }
}
