// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// void addFriend(String userId, String friendId) async {
//   DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
//   DocumentReference friendRef = FirebaseFirestore.instance.collection('users').doc(friendId);
//
//   // Firestore 트랜잭션 사용 (옵션)
//   await FirebaseFirestore.instance.runTransaction((transaction) async {
//     // 사용자 문서 가져오기
//     DocumentSnapshot userDoc = await transaction.get(userRef);
//     if (userDoc.exists) {
//       List friends = userDoc.get('friends') ?? [];
//       if (!friends.contains(friendId)) {
//         // 친구 ID 추가
//         friends.add(friendId);
//         transaction.update(userRef, {'friends': friends});
//       }
//     }
//
//     // 친구 문서 가져오기
//     DocumentSnapshot friendDoc = await transaction.get(friendRef);
//     if (friendDoc.exists) {
//       List friends = friendDoc.get('friends') ?? [];
//       if (!friends.contains(userId)) {
//         // 친구 ID 추가
//         friends.add(userId);
//         transaction.update(friendRef, {'friends': friends});
//       }
//     }
//   });
// }
//
//
// class UserPage extends StatefulWidget {
//   @override
//   _UserPageState createState() => _UserPageState();
// }
//
// class _UserPageState extends State<UserPage> {
//   final TextEditingController _friendIdController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String currentUserId = "currentUserId";  // 현재 사용자 ID를 여기에 설정
//
//   void _addFriend() async {
//     final String friendId = _friendIdController.text.trim();
//     if (friendId.isNotEmpty) {
//       // 친구 이름으로 Firestore에서 쿼리하여 사용자 추가
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('users')
//           .where('name', isEqualTo: friendId)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         // 친구가 존재하면, 현재 사용자의 친구 목록에 추가
//         final DocumentSnapshot friendDoc = querySnapshot.docs.first;
//         final String friendUserId = friendDoc.id;
//
//         // 친구 추가
//         addFriend(currentUserId, friendUserId);
//         print('친구 추가됨: ${friendDoc.data()}');
//       } else {
//         // 친구가 존재하지 않는 경우
//         print('친구를 찾을 수 없습니다.');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('친구 추가'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _friendIdController,
//               decoration: InputDecoration(labelText: '친구 이름'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _addFriend,
//               child: Text('친구 추가'),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               '친구 목록:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: _firestore.collection('users').doc(currentUserId).snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//
//                   List friends = snapshot.data!['friends'] ?? [];
//                   return ListView.builder(
//                     itemCount: friends.length,
//                     itemBuilder: (context, index) {
//                       return FutureBuilder<DocumentSnapshot>(
//                         future: _firestore.collection('users').doc(friends[index]).get(),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return ListTile(title: Text('Loading...'));
//                           }
//                           return ListTile(
//                             title: Text(snapshot.data!['name']),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
