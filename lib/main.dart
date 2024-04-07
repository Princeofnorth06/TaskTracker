import 'package:flutter/material.dart';
import 'package:task_tracker/myhomepage.dart';

void main() {
  runApp(TaskTrackerApp());
}

class Task {
  String title;
  String description;
  bool completed;

  Task(
      {required this.title, required this.description, this.completed = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
    };
  }

  // Create Task object from a Map retrieved from storage
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Tracker',
      home: MyHomePage(),
    );
  }
}
