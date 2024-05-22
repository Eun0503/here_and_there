import 'package:flutter/material.dart';

class UserState extends InheritedWidget {
  final String currentUserId;
  final Widget child;

  UserState({
    required this.currentUserId,
    required this.child,
  }) : super(child: child);

  static UserState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserState>();
  }

  @override
  bool updateShouldNotify(UserState oldWidget) {
    return currentUserId != oldWidget.currentUserId;
  }
}
