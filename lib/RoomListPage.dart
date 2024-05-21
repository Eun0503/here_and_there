import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Mapview.dart';
import 'UserState.dart';

class RoomListPage extends StatefulWidget {
  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _roomNameController = TextEditingController();
  List<String> selectedFriends = [];

  void _createRoom(BuildContext context) async {
    final String currentUserId = UserState.of(context)!.currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('users').doc(currentUserId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List friends = snapshot.data!['friends'] ?? [];
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _roomNameController,
                        decoration: InputDecoration(labelText: '방 이름'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: _firestore.collection('users').doc(friends[index]).get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return ListTile(title: Text('Loading...'));
                                }
                                final friendName = snapshot.data!['name'];
                                final friendId = friends[index];
                                return CheckboxListTile(
                                  title: Text(friendName),
                                  value: selectedFriends.contains(friendId),
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      if (value!) {
                                        selectedFriends.add(friendId);
                                      } else {
                                        selectedFriends.remove(friendId);
                                      }
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final roomName = _roomNameController.text.trim();
                          if (roomName.isNotEmpty && selectedFriends.isNotEmpty) {
                            await _firestore.collection('rooms').doc(roomName).set({
                              'name': roomName,
                              'description': 'Description', // Add actual description if needed
                              'members': [currentUserId, ...selectedFriends],
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('방 이름과 친구를 선택하세요')),
                            );
                          }
                        },
                        child: Text('방 생성'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<String> _getMemberNames(List members) async {
    List<String> memberNames = [];
    for (String memberId in members) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(memberId).get();
      memberNames.add(userDoc['name']);
    }
    return memberNames.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('방 목록'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _createRoom(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('rooms').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final rooms = snapshot.data!.docs;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return FutureBuilder<String>(
                future: _getMemberNames(room['members']),
                builder: (context, memberSnapshot) {
                  if (!memberSnapshot.hasData) {
                    return ListTile(title: Text('Loading...'));
                  }
                  return ListTile(
                    title: Text(room['name']),
                    subtitle: Text(memberSnapshot.data!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Mapview(roomName: room['name']),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
