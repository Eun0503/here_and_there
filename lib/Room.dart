import 'package:flutter/material.dart';
import 'RoomList.dart'; // 새로 만든 RoomList 위젯 import
import 'TopBar.dart';
import 'BottomBar.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<String> _checkedNames = [];
  List<Map<String, String>> _rooms = [
    {'name': '금소현', 'description': '부산방, 시험 끝나고 놀러가자~!방 ··· +1'},
    {'name': '김에스더', 'description': '비둘기 모임, 천안방, study cafe방 ··· +4'},
    {'name': '남궁곽철', 'description': ''},
    {'name': '서효주', 'description': '비둘기 모임, 천안방'},
  ];

  void _showAddPersonDialog() {
    TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFE17C51),
          title: Text('아이디 입력', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: idController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "아이디를 입력하세요",
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                String id = idController.text;
                print('Entered ID: $id');
                _addRoom('성채원', ' ');
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _toggleCheck(String name) {
    setState(() {
      if (_checkedNames.contains(name)) {
        _checkedNames.remove(name);
      } else {
        _checkedNames.add(name);
      }
    });
  }

  void _showCheckedNames() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFE17C51),
          title: Text('방 생성', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _checkedNames.map((name) => Text(name, style: TextStyle(color: Colors.white))).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showNameSettingDialog(context);
              },
              child: const Text('Next', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showNameSettingDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFE17C51),
          title: Text('방 이름 입력', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "방 이름을 입력하세요",
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showRoomCreatedMessage(context, nameController.text);
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showRoomCreatedMessage(BuildContext context, String roomName) {
    // 추가된 부분: 방 생성 후 rooms 리스트에 새로운 방 정보 추가
    _addRoom(roomName, '새로운 방이 생성되었습니다.');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFE17C51),
          title: Text('방 생성 완료', style: TextStyle(color: Colors.white)),
          content: Text('$roomName 방이 생성되었습니다.', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _addRoom(String name, String description) {
    setState(() {
      // 추가된 부분: 방 생성 후 rooms 리스트에 새로운 방 정보 추가
      _rooms.add({'name': name, 'description': description});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: _showCheckedNames,
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: _showAddPersonDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RoomList(
          rooms: _rooms,
          checkedNames: _checkedNames,
          onToggleCheck: _toggleCheck,
        ),
      ),
    );
  }
}
