import 'package:flutter/material.dart';
import 'package:mylockeddiary/ui/mainpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'panforte_serif_regular',
        primarySwatch: Colors.blue
      ),
      home: MainPage(),
    );
  }
}
