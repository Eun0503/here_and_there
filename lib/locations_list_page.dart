import 'package:flutter/material.dart';
import 'list_item.dart';

class LocationsListPage extends StatelessWidget {
  final List<ListItem> items;
  final Offset selectedLocation;

  LocationsListPage({required this.items, required this.selectedLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location List')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text('Selected location: $selectedLocation'),
          );
        },
      ),
    );
  }
}
