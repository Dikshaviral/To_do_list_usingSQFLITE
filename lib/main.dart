import 'package:flutter/material.dart';
import 'package:todo_list/screens/ToDoScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
       theme: ThemeData.dark(

       ),
      home: ToDoScreen(),
    );
  }
}
