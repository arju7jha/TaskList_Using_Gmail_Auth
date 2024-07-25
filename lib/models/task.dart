// models/task.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime deadline;
  int duration; // in minutes
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.duration,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'],
      description: data['description'],
      deadline: (data['deadline'] as Timestamp).toDate(),
      duration: data['duration'],
      isCompleted: data['isCompleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'duration': duration,
      'isCompleted': isCompleted,
    };
  }
}
