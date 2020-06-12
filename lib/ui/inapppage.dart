import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mylockeddiary/ui/subinapppages.dart';

class InAppPage extends StatefulWidget {
  String userName;
  int userId;

  InAppPage(this.userName,this.userId);
  @override
  _InAppPageState createState() => _InAppPageState();
}

class _InAppPageState extends State<InAppPage> {

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
        child: SubInAppPages(widget.userName,widget.userId),
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