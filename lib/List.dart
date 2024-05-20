import 'package:flutter/material.dart';
import 'CreateRoom.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();

  // 정적 메서드로 addRoomToList 정의
  static void addRoomToList(String name, String description) {
    _ListPageState()._addRoom(name, description);
  }
}

class _ListPageState extends State<ListPage> {
  // 변경된 부분: 새로운 방 목록을 저장하는 리스트
  static List<Map<String, String>> _newRooms = [];

  List<Map<String, String>> _rooms = [
    {
      'name': '금공강 4',
      'description': '라랄라',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Createroom(
        // 변경된 부분: _rooms와 _newRooms 리스트를 합침
        rooms: [..._rooms, ..._newRooms],
        checkedNames: [],
        onToggleCheck: (name) {
          // Toggle check logic here
        },
      ),
    );
  }

  // _addRoom 메서드 정의
  void _addRoom(String name, String description) {
    setState(() {
      // 변경된 부분: 새로운 방 정보는 _newRooms 리스트에 추가
      _newRooms.add({'name': name, 'description': description});
    });
  }
}
