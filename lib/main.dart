import 'package:flutter/material.dart';
import 'package:stop_watch_app/screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
            brightness: Brightness.dark
      ),
      home: HomePage(),
      title: 'MyApp',
    );
  }
}
