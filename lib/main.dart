import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'my_home_page.dart';
import 'people.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PeopleAdapter());
  await Hive.openBox('peopleBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
