import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/todo_app/bloc-observer/bloc-observer.dart';

import 'homae-layoutt.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigation(),
    );
  }
}
