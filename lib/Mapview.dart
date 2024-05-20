import 'package:flutter/material.dart';
import 'BottomBar.dart';
import 'TopBar.dart';
import 'locations_list_page.dart';
import 'list_item.dart';
import 'location_data_to_database.dart';

class MapView extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapView> {
  int _currentIndex = 0;
  Offset? _pinOffset;
  List<Offset> _locations = [];
  late LocationDataToDatabase locationDataToDatabase; // 수정된 부분

  @override
  void initState() {
    super.initState();
    locationDataToDatabase = LocationDataToDatabase(); // 인스턴스 생성
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

    // 클릭한 위치 정보를 LocationDataToDatabase에 전달
    locationDataToDatabase.setLocation(localOffset);

    _showBottomSheet(context);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("선택한 위치: $_pinOffset"),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  child: Text("리스트에 추가하기"),
                  onPressed: () {
                    if (_pinOffset != null) {
                      Navigator.pop(context); // 하단 시트를 닫습니다.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationsListPage(
                            items: [
                              ListItem(name: "분좋카", locations: []),
                              ListItem(name: "치킨(닭)먹는 날", locations: []),
                              ListItem(name: "은똥이의 텃밭 가꾸기~", locations: []),
                              ListItem(name: "달력에서 선택하기", locations: [])
                            ],
                            selectedLocation: _pinOffset!,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: '비둘기 모임',
      ),
      body: Center(
        child: GestureDetector(
          onTapUp: _onImageTap,
          child: Stack(
            children: [
              Image.asset(
                'assets/map.png', // 지도 이미지 파일 경로
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              if (_pinOffset != null)
                Positioned(
                  left: _pinOffset!.dx - 24, // 핀의 중심을 클릭한 위치에 맞추기 위해 보정
                  top: _pinOffset!.dy - 120,  // 핀의 크기에 맞게 보정
                  child: Icon(
                    Icons.location_on,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
