import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mylockeddiary/ui/submainpages.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SubMainPages(),
        decoration: BoxDecoration(
          image: DecorationImage(image: randomBGImage(), fit: BoxFit.cover),
        ),
      ),
    );
  }

  

  randomBGImage() {
    Random rnd;
    int min = 1;
    int max = 6;
    rnd = new Random();
    int randNumber = min + rnd.nextInt(max - min);

    return AssetImage('assets/img/background$randNumber.jpg');
  }

  
}
