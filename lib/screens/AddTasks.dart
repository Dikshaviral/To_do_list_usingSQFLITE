import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/helpers/database_helper.dart';
import 'package:todo_list/models/Task_model.dart';


class AddTaskScreen extends StatefulWidget {
  final Task? task;
  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String _title = '';
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('dd, MM, yyyy');

  @override
  void initState()
  {
    super.initState();
    if(widget.task != null)
      {
        _title = widget.task!.title;
        _date = widget.task!.date;


      }
    _dateController.text = _dateFormatter.format(_date);
  }

  _handleDate() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(_date);
    }
  }

  _submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      Task task = Task(title: _title, date: _date);
      if(widget.task == null)
        {
          task.status =0;

          DatabaseHelper.instance.insertTask(task);

}     else
        {
          task.status = widget.task!.status;
          DatabaseHelper.instance.updateTask(task);
        }
      print(task.title);
    }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 17, 22, 1.0),
      appBar: AppBar(backgroundColor: Colors.red, title: Text("To-Do List")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Text(
                    "Add Task",
                    style: TextStyle(color: Colors.amber, fontSize: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18, decorationColor: Colors.red),
                            decoration: InputDecoration(
                                labelText: "Enter the Task",
                                border: OutlineInputBorder()),
                            validator: (input) =>
                                input != null && input.trim().isEmpty
                                    ? 'Please enter a task title'
                                    : null,
                            onSaved: (input) => _title =input.toString(),
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            onTap: _handleDate,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                labelText: "Select Date",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 70),
                          child: SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: _submit,
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
