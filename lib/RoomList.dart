import 'package:flutter/material.dart';

class RoomList extends StatelessWidget {
  final List<Map<String, String>> rooms;
  final List<String> checkedNames;
  final Function(String) onToggleCheck;

  const RoomList({
    Key? key,
    required this.rooms,
    required this.checkedNames,
    required this.onToggleCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rooms.map((room) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(room['name']![0]), // Displaying the first letter of the name as the profile picture
            ),
            title: Text(room['name'] ?? ''),
            subtitle: Text(room['description'] ?? ''),
            onTap: () {
              onToggleCheck(room['name'] ?? '');
            },
            trailing: checkedNames.contains(room['name'] ?? '')
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
          );
        }).toList(),
      ),
    );
  }
}
