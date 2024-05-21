import 'package:flutter/material.dart';
import 'package:here_and_there/ListItem.dart';
import 'package:here_and_there/TopBar.dart';

import 'LocationDataToDatabase.dart'; // TopBar를 정의한 파일의 경로에 따라 수정하세요

class LocationsListPage extends StatefulWidget {
  final List<ListItem> items;
  final Offset selectedLocation;

  const LocationsListPage({
    Key? key,
    required this.items,
    required this.selectedLocation,
  }) : super(key: key);

  @override
  _LocationsListPageState createState() => _LocationsListPageState();
}

class _LocationsListPageState extends State<LocationsListPage> {
  List<bool> _selectedItems = [];
  List<String> _selectedNames = []; // 선택된 아이템의 이름을 저장하는 리스트

  @override
  void initState() {
    super.initState();
    _selectedItems = List<bool>.filled(widget.items.length, false);
  }

  void _toggleSelectAll(bool? newValue) {
    setState(() {
      for (int i = 0; i < _selectedItems.length; i++) {
        _selectedItems[i] = newValue!;
        if (newValue) {
          _selectedNames.add(widget.items[i].name); // 전체 선택 시 모든 아이템의 이름 추가
        } else {
          _selectedNames.clear(); // 전체 선택 해제 시 선택된 이름들을 모두 제거
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: TopBar(title: "비둘기 모임"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Center(
            child: Text(
              "나의 리스트",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Text("전체 선택"),
                Checkbox(
                  checkColor: Colors.orange,
                  activeColor: Colors.grey,
                  value: _selectedItems.every((isSelected) => isSelected),
                  onChanged: _toggleSelectAll,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(widget.items[index].name),
                    trailing: Checkbox(
                      checkColor: Colors.orange,
                      activeColor: Colors.grey,
                      value: _selectedItems[index],
                      onChanged: (bool? newValue) {
                        setState(() {
                          _selectedItems[index] = newValue!;
                          if (newValue!) {
                            _selectedNames.add(widget.items[index].name); // 선택 시 이름 추가
                            widget.items[index].locations.add(widget.selectedLocation);
                          } else {
                            _selectedNames.remove(widget.items[index].name); // 해제 시 이름 제거
                            widget.items[index].locations.remove(widget.selectedLocation);
                          }
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _selectedItems[index] = !_selectedItems[index];
                        if (_selectedItems[index]) {
                          _selectedNames.add(widget.items[index].name); // 선택 시 이름 추가
                          widget.items[index].locations.add(widget.selectedLocation);
                        } else {
                          _selectedNames.remove(widget.items[index].name); // 해제 시 이름 제거
                          widget.items[index].locations.remove(widget.selectedLocation);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            // 현재 페이지를 닫고 이전 페이지로 이동합니다.
            Navigator.pop(context);

            print("선택된 아이템들: $_selectedNames");

            // 위치 데이터를 생성하고 설정합니다.
            // 예시 위치 데이터
            LocationDataToDatabase locationDataToDatabase = LocationDataToDatabase();


            // Firestore에 위치 정보를 저장합니다.
            for (String name in _selectedNames) {
              locationDataToDatabase.saveLocationToFirestore(name);}
          },
          child: Icon(Icons.check),
          backgroundColor: Colors.grey,
          foregroundColor: Colors.orange,
        ),
      ),
    );
  }
}