import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import 'task_form_screen.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addOrEditTask(Task? task) {
    Navigator.of(context).pushNamed('/task_form', arguments: task);
  }

  void _deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  void _toggleCompleteStatus(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update({
      'isCompleted': !task.isCompleted,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addOrEditTask(null),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('tasks').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> taskSnapshot) {
          if (taskSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final taskDocs = taskSnapshot.data!.docs;
          return ListView.builder(
            itemCount: taskDocs.length,
            itemBuilder: (ctx, index) {
              final taskData = taskDocs[index].data() as Map<String, dynamic>;
              final task = Task.fromMap(taskData, taskDocs[index].id);
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: Icon(task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
                  onPressed: () => _toggleCompleteStatus(task),
                ),
                onTap: () => _addOrEditTask(task),
                onLongPress: () => _deleteTask(task.id),
              );
            },
          );
        },
      ),
    );
  }
}
