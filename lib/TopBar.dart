import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  TopBar({
    required this.title,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Color(0xFFE17C51),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: null, // 메뉴 아이템이 눌렸을 때 아무것도 실행되지 않도록 함
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}