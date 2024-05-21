import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserState.dart';

class Userpage extends StatefulWidget {
  @override
  _UserpageState createState() => _UserpageState();
}
class _UserpageState extends State<Userpage> {
  final TextEditingController _friendNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addFriend() async {
    final String friendName = _friendNameController.text.trim();
    final String currentUserId = UserState.of(context)!.currentUserId;

    if (friendName.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('name', isEqualTo: friendName)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot friendDoc = querySnapshot.docs.first;
          final String friendUserId = friendDoc.id;

          await _firestore.collection('users').doc(currentUserId).update({
            'friends': FieldValue.arrayUnion([friendUserId])
          });

          setState(() {
            _friendNameController.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('친구가 추가되었습니다: $friendName')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('친구를 찾을 수 없습니다.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('친구 추가에 실패했습니다: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력하세요')),
      );
    }
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('친구 추가'),
          content: TextField(
            controller: _friendNameController,
            decoration: InputDecoration(labelText: '친구 이름'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                _addFriend();
                Navigator.of(context).pop();
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = UserState.of(context)!.currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text('친구 목록'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(currentUserId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List friends = snapshot.data!['friends'] ?? [];
                  if (friends.isEmpty) {
                    return Center(child: Text('친구가 없습니다.'));
                  }

                  return ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore.collection('users').doc(friends[index]).get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return ListTile(title: Text('Loading...'));
                          }
                          return ListTile(
                            title: Text(snapshot.data!['name']),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFriendDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
