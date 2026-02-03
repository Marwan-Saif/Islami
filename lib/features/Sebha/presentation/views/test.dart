import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'local_sypha.dart'; // Import the LocalSypha class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<LocalSypha> syphaBox;
  String message = '';

  @override
  void initState() {
    super.initState();
    openBox();
  }

  // Open the Hive box
  Future<void> openBox() async {
    syphaBox = await Hive.openBox<LocalSypha>('syphaBox');
    setState(() {});
  }

  // Add data to the box
  void addData() async {
    final item = LocalSypha(name: 'Item 1', counter: '0', historyCounter: '0');
    await syphaBox.add(item);
    setState(() {
      message = 'Data added to box';
    });
  }

  // Read data from the box

  void readData() {
    log(syphaBox.values.toList().toString());

    final item = syphaBox.getAt(0); // Get data at index 0
    if (item != null) {
      log(item.name);
      setState(() {
        message =
            'Read: ${item.name}, Counter: ${item.counter}, HistoryCounter: ${item.historyCounter}';
      });
    } else {
      setState(() {
        message = 'No data found';
      });
    }
  }

  // Delete data from the box
  void deleteData() async {
    if (syphaBox.isNotEmpty) {
      await syphaBox.deleteAt(0); // Delete data at index 0
    } else
      setState(() {
        message = 'Data deleted from box';
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive CRUD Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: addData,
              child: Text('Add Data'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: readData,
              child: Text('Read Data'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: deleteData,
              child: Text('Delete Data'),
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
