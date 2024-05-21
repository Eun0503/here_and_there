import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationDataToDatabase {
  static Offset _location = Offset(0.0, 0.0); // 위치 정보 초기화

  // 위치 정보 설정
  void setLocation(Offset l) {
    _location = l;
    print("Location set: $_location");
  }


Future<void> saveLocationToFirestore(String document) async {
  try {
    // Firestore 인스턴스 가져오기
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Firestore에 위치 정보 저장 (문서 이름을 지정하여 추가)
    await firestore.collection(document).add({
      'x': _location!.dx,
      'y': _location!.dy,
    });
    print('Location saved to Firestore successfully.');
  } catch (e) {
    print('Error saving location to Firestore: $e');
  }
}}

// Future<void> saveRoomToFirestore(String document) async {
//   try {
//     // Firestore 인스턴스 가져오기
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//     // Firestore에 위치 정보 저장 (문서 이름을 지정하여 추가)
//     await firestore.collection(document).add({
//       'x': _location!.dx,
//       'y': _location!.dy,
//     });
//     print('Location saved to Firestore successfully.');
//   } catch (e) {
//     print('Error saving location to Firestore: $e');
//   }
// }}
