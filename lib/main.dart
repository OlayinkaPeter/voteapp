import 'package:vote_idea/screens/dashboard.dart';
import 'package:vote_idea/screens/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Vote Idea',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {
        '/landing' : (BuildContext context) => new MyApp(),
        '/dashboard' : (BuildContext context) => new DashBoardScreen(),
      },
    );
  }
}