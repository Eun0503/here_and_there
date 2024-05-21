import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LocationDataToDatabase.dart';
import 'ListItem.dart';
import 'LocationsListPage.dart';
import 'BottomBar.dart';
import 'TopBar.dart';

class Mapview extends StatefulWidget {
  final String roomName;

  Mapview({required this.roomName});

  @override
  _MapviewState createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  int _currentIndex = 0;
  Offset? _pinOffset;
  List<Offset> _locations = [];
  late LocationDataToDatabase locationDataToDatabase;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _lists = [];
  List<String> selectedLists = [];
  final List<Color> _iconColors = [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple];
  List<Map<String, dynamic>> _allLocations = [];

  @override
  void initState() {
    super.initState();
    locationDataToDatabase = LocationDataToDatabase();
    _loadLists();
  }

  Future<void> _loadLists() async {
    final QuerySnapshot querySnapshot = await _firestore.collection(widget.roomName).get();
    setState(() {
      _lists = querySnapshot.docs
          .map((doc) => {'id': doc.id, 'name': doc.id, 'locations': doc['locations']})
          .toList();
      _allLocations = [];
      for (int i = 0; i < _lists.length; i++) {
        var list = _lists[i];
        var color = _iconColors[i % _iconColors.length];
        for (var loc in list['locations']) {
          _allLocations.add({'x': loc['x'], 'y': loc['y'], 'color': color});
        }
      }
    });
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onImageTap(TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      _pinOffset = localOffset;
    });

    locationDataToDatabase.setLocation(localOffset);

    _showBottomSheet(context);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 300,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("선택한 위치: $_pinOffset"),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _lists.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(_lists[index]['name']),
                          value: selectedLists.contains(_lists[index]['id']),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value!) {
                                selectedLists.add(_lists[index]['id']);
                              } else {
                                selectedLists.remove(_lists[index]['id']);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Text("리스트에 추가하기"),
                      onPressed: () async {
                        if (_pinOffset != null && selectedLists.isNotEmpty) {
                          for (String listId in selectedLists) {
                            final docRef = _firestore.collection(widget.roomName).doc(listId);

                            await docRef.update({
                              'locations': FieldValue.arrayUnion([
                                {'x': _pinOffset!.dx, 'y': _pinOffset!.dy}
                              ]),
                            }).catchError((error) async {
                              if (error.code == 'not-found') {
                                await docRef.set({
                                  'locations': [
                                    {'x': _pinOffset!.dx, 'y': _pinOffset!.dy}
                                  ],
                                });
                              }
                            });
                          }
                          _pinOffset = null;
                          selectedLists.clear();
                          _loadLists();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showListLocations(List locations) {
    setState(() {
      _locations = locations.map((loc) => Offset(loc['x'], loc['y'])).toList();
    });
  }

  void _showAllLocations() {
    setState(() {
      _locations = _allLocations.map((loc) => Offset(loc['x'], loc['y'])).toList();
    });
  }

  void _createList(BuildContext context) async {
    final TextEditingController _listNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('리스트 생성'),
          content: TextField(
            controller: _listNameController,
            decoration: InputDecoration(labelText: '리스트 이름'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                final String listName = _listNameController.text.trim();
                if (listName.isNotEmpty) {
                  await _firestore.collection(widget.roomName).doc(listName).set({'locations': []});
                  _loadLists();
                  Navigator.pop(context);
                }
              },
              child: Text('생성'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTapUp: _onImageTap,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/map.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (_pinOffset != null)
                    Positioned(
                      left: _pinOffset!.dx - 24,
                      top: _pinOffset!.dy - 100,
                      child: Icon(
                        Icons.location_on,
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                  ..._locations.map((offset) {
                    int index = _locations.indexOf(offset);
                    Color color = _allLocations[index]['color'];
                    return Positioned(
                      left: offset.dx - 12,
                      top: offset.dy - 50,
                      child: Icon(
                        Icons.location_on,
                        size: 24,
                        color: color,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: _showAllLocations,
                          child: Text('ALL'),
                        ),
                        ..._lists.map((list) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _showListLocations(list['locations']);
                              },
                              child: Text(list['name']),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _createList(context),
                  child: Text('리스트 추가'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
