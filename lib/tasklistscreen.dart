import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker/addtask.dart';

import 'main.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      setState(() {
        tasks = taskList.map((taskJson) {
          Map<String, dynamic> taskMap = jsonDecode(taskJson);
          return Task.fromJson(taskMap);
        }).toList();
      });
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('tasks', taskList);
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
    saveTasks();
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TaskTrackerApp()));
          },
        ),
        title: const Text(
          'Task List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteAllTasks();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          Task task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Checkbox(
              value: task.completed,
              onChanged: (bool? value) {
                toggleTaskCompletion(index);
              },
            ),
            onLongPress: () {
              deleteTask(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade400,
        onPressed: () async {
          Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null) {
            addTask(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
