import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'AuthSelectionPage.dart';
import 'SignupPage.dart';
import 'TopBar.dart';
import 'BottomBar.dart';
import 'Userpage.dart'; // Userpage.dart 파일을 import
import 'RoomListPage.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Firebase 초기화


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, //디버그 배너 X
      home: AuthSelectionPage(), // AuthSelectionPage로 설정
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? RoomListPage() // Display the RoomListPage when index is 0 (Home tab)
          : Userpage(), // Display the RoomPage when index is 1 (Friends tab)
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}