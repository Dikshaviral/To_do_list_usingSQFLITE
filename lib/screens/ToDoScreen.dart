import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo_list/helpers/database_helper.dart';
import 'package:todo_list/models/Task_model.dart';
import 'package:todo_list/screens/AddTasks.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late Future<List<Task>> _taskList;

  final DateFormat _dateFormatter = DateFormat('dd, MM, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
      print("debiu");
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              _dateFormatter.format(task.date),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                task.status = value!?1:0;
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList();
              },
              activeColor: Colors.red,
              value: true,

            ),
            onTap: ()=>
            {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>AddTaskScreen(
                  task: task),),)
            },
          ),
          Divider(
            color: Colors.amberAccent,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: Text("To-Do List")),
      backgroundColor: Color.fromRGBO(14, 17, 22, 1.0),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.add),
          onPressed: () => {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddTaskScreen(

                )))
              }),
      body: FutureBuilder<List<Task>>(
        future: _taskList,
        builder: (context, snapshot) {
          var t= snapshot.data;
          if (!snapshot.hasData) {
            print("no");
            return Center(
              child: CircularProgressIndicator(),

            );
          }




          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: t!.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tasks',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 50,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }
              return _buildTask( t[2] );
            },
          );

          },
      ),
    );
  }
}
/*Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            height: 70,
            width: double.infinity,
            color: Colors.red,
          );*/
