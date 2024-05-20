import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onAddCommentPressed; // onAddCommentPressed 콜백을 추가
  final VoidCallback onAddPersonPressed; // onAddPersonPressed 콜백을 추가

  TopBar({required this.title, required this.onAddCommentPressed, required this.onAddPersonPressed});

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
          onPressed: onAddCommentPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
