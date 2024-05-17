import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Color(0xFFE17C51),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // 뒤로가기 버튼을 눌렀을 때의 동작을 추가할 수 있습니다.
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // 메뉴 버튼을 눌렀을 때의 동작을 추가할 수 있습니다.
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.0);
}
