// Room.dart
import 'package:flutter/material.dart';
import 'RoomList.dart';
import 'List.dart'; // List.dart 파일 import 추가

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  // 방 목록과 선택된 방 정보를 관리합니다.
  List<Map<String, String>> _rooms = [
    {'name': '금소현', 'description': '부산방, 시험 끝나고 놀러가자~!방 ··· +1'},
    {'name': '김에스더', 'description': '비둘기 모임, 천안방, study cafe방 ··· +4'},
    {'name': '남궁곽철', 'description': ''},
    {'name': '서효주', 'description': '비둘기 모임, 천안방'},
  ];

  // 친구 목록을 저장하는 리스트
  List<String> _friendList = [];

  // 선택된 방 정보를 저장하는 리스트
  List<String> _checkedNames = [];

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
                // 선택된 방 목록에 추가
                _addRoom('성채원', '');
                // 추가된 방을 친구 목록에도 추가
                _addFriend('성채원');
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 친구 목록에 이름을 추가하는 함수
  void _addFriend(String name) {
    setState(() {
      _friendList.add(name);
    });
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
                String roomName = nameController.text;
                if (roomName.isNotEmpty) {
                  _showRoomCreatedMessage(context, roomName);
                }
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

    // 변경된 부분: 방 생성 후 List.dart에도 새로운 방 정보 추가
    ListPage.addRoomToList(roomName, '새로운 방이 생성되었습니다.');

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _rooms.map((room) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(room['name']![0]), // Displaying the first letter of the name as the profile picture
              ),
              title: Text(room['name'] ?? ''),
              subtitle: Text(room['description'] ?? ''),
              onTap: () {
                _toggleCheck(room['name'] ?? '');
              },
              trailing: _checkedNames.contains(room['name'] ?? '')
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : null,
            );
          }).toList(),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showCheckedNames,
            child: Icon(Icons.add_comment),
            heroTag: null, // FloatingActionButton을 여러 개 사용할 때 오류를 방지하기 위해 heroTag 설정
          ),
          SizedBox(height: 10), // 버튼 사이의 간격
          FloatingActionButton(
            onPressed: _showAddPersonDialog,
            child: Icon(Icons.person_add),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
