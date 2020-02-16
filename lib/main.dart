import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ezar/ui/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return new MaterialApp(
      title: 'U of C AR Tour',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}
