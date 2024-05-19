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
    return Column(
      children: rooms.map((room) {
        bool isChecked = checkedNames.contains(room['name']);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(
              room['name']![0],
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(room['name']!),
              ),
              IconButton(
                icon: isChecked
                    ? Icon(Icons.check_circle)
                    : Icon(Icons.radio_button_unchecked),
                onPressed: () => onToggleCheck(room['name']!),
              ),
            ],
          ),
          subtitle: Text(room['description']!),
        );
      }).toList(),
    );
  }
}
