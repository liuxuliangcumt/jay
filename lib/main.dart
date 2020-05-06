import 'package:bot_toast/bot_toast.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:flutter/material.dart';
import 'package:jay/pages/flash/FlashPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Bmob.init("https://api2.bmob.cn", "c466b99b14560c101ae642914539625a",
        "ccb029f4b6b9c803f9979257bc7b111e");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: BotToastInit(), //BotToastInit移动到此处,
      home: Scaffold(
        body: FlashPage(),
      ),
    );
  }
}
