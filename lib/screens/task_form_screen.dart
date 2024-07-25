import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import '../models/task.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  DateTime _selectedDeadline = DateTime.now();

  Future<void> _zonedScheduleNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'task_channel_id', // Channel ID
      'Task Notifications', // Channel name
      channelDescription: 'Channel for task reminders', // Channel description
      icon: '@mipmap/ic_launcher',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Task Reminder',
        'You have a task due soon!',
        tz.TZDateTime.from(_selectedDeadline.subtract(Duration(minutes: 10)), tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final task = Task(
      id: widget.task?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      deadline: _selectedDeadline,
      duration: int.parse(_durationController.text),
      isCompleted: widget.task?.isCompleted ?? false,
    );

    final firestore = FirebaseFirestore.instance;

    if (widget.task == null) {
      await firestore.collection('tasks').add(task.toMap());
    } else {
      await firestore.collection('tasks').doc(task.id).update(task.toMap());
    }

    _zonedScheduleNotification();

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _durationController.text = widget.task!.duration.toString();
      _selectedDeadline = widget.task!.deadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration (in minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Deadline: ${_selectedDeadline.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDeadline,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedDeadline = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Text('Select Date & Time'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// // screens/task_form_screen.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../main.dart';
// import '../models/task.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class TaskFormScreen extends StatefulWidget {
//   final Task? task;
//
//   TaskFormScreen({this.task});
//
//   @override
//   _TaskFormScreenState createState() => _TaskFormScreenState();
// }
//
// class _TaskFormScreenState extends State<TaskFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _durationController = TextEditingController();
//   DateTime _selectedDeadline = DateTime.now();
//
//   void _scheduleNotification(DateTime scheduledNotificationDateTime) async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       // 'your_channel_description',
//       icon: 'secondary_icon',
//       sound: RawResourceAndroidNotificationSound('slow_spring_board'),
//       largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.schedule(
//       0,
//       'Task Reminder',
//       'You have a task due in 10 minutes',
//       scheduledNotificationDateTime,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//     );
//   }
//
//   void _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     final task = Task(
//       id: widget.task?.id ?? '',
//       title: _titleController.text,
//       description: _descriptionController.text,
//       deadline: _selectedDeadline,
//       duration: int.parse(_durationController.text),
//       isCompleted: widget.task?.isCompleted ?? false,
//     );
//
//     final firestore = FirebaseFirestore.instance;
//
//     if (widget.task == null) {
//       await firestore.collection('tasks').add(task.toMap());
//     } else {
//       await firestore.collection('tasks').doc(task.id).update(task.toMap());
//     }
//
//     // Schedule notification 10 minutes before the task deadline
//     final scheduledNotificationDateTime = _selectedDeadline.subtract(Duration(minutes: 10));
//     _scheduleNotification(scheduledNotificationDateTime);
//
//     Navigator.of(context).pop();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.task != null) {
//       _titleController.text = widget.task!.title;
//       _descriptionController.text = widget.task!.description;
//       _durationController.text = widget.task!.duration.toString();
//       _selectedDeadline = widget.task!.deadline;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _durationController,
//                 decoration: InputDecoration(labelText: 'Duration (in minutes)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a duration';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Deadline: ${_selectedDeadline.toLocal()}'.split(' ')[0],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       final pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: _selectedDeadline,
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(2101),
//                       );
//                       if (pickedDate != null) {
//                         final pickedTime = await showTimePicker(
//                           context: context,
//                           initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
//                         );
//                         if (pickedTime != null) {
//                           setState(() {
//                             _selectedDeadline = DateTime(
//                               pickedDate.year,
//                               pickedDate.month,
//                               pickedDate.day,
//                               pickedTime.hour,
//                               pickedTime.minute,
//                             );
//                           });
//                         }
//                       }
//                     },
//                     child: Text('Select Date & Time'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // // screens/task_form_screen.dart
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../main.dart';
// // import '../models/task.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //
// // class TaskFormScreen extends StatefulWidget {
// //   final Task? task;
// //
// //   TaskFormScreen({this.task});
// //
// //   @override
// //   _TaskFormScreenState createState() => _TaskFormScreenState();
// // }
// //
// // class _TaskFormScreenState extends State<TaskFormScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _titleController = TextEditingController();
// //   final _descriptionController = TextEditingController();
// //   final _durationController = TextEditingController();
// //   DateTime _selectedDeadline = DateTime.now();
// //
// //   void _scheduleNotification(DateTime scheduledNotificationDateTime) async {
// //     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
// //       'your other channel id',
// //       'your other channel name',
// //       // 'your other channel description',
// //       icon: 'secondary_icon',
// //       sound: RawResourceAndroidNotificationSound('slow_spring_board'),
// //       largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
// //     );
// //     // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
// //     NotificationDetails platformChannelSpecifics = NotificationDetails(
// //         android: androidPlatformChannelSpecifics, );
// //     await flutterLocalNotificationsPlugin.schedule(
// //       0,
// //       'Task Reminder',
// //       'You have a task due in 10 minutes',
// //       scheduledNotificationDateTime,
// //       platformChannelSpecifics,
// //     );
// //   }
// //
// //   void _submit() async {
// //     if (!_formKey.currentState!.validate()) {
// //       return;
// //     }
// //
// //     final task = Task(
// //       id: widget.task?.id ?? '',
// //       title: _titleController.text,
// //       description: _descriptionController.text,
// //       deadline: _selectedDeadline,
// //       duration: int.parse(_durationController.text),
// //       isCompleted: widget.task?.isCompleted ?? false,
// //     );
// //
// //     final firestore = FirebaseFirestore.instance;
// //
// //     if (widget.task == null) {
// //       await firestore.collection('tasks').add(task.toMap());
// //     } else {
// //       await firestore.collection('tasks').doc(task.id).update(task.toMap());
// //     }
// //
// //     // Schedule notification 10 minutes before the task deadline
// //     final scheduledNotificationDateTime = _selectedDeadline.subtract(Duration(minutes: 10));
// //     _scheduleNotification(scheduledNotificationDateTime);
// //
// //     Navigator.of(context).pop();
// //   }
// //
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.task != null) {
// //       _titleController.text = widget.task!.title;
// //       _descriptionController.text = widget.task!.description;
// //       _durationController.text = widget.task!.duration.toString();
// //       _selectedDeadline = widget.task!.deadline;
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               TextFormField(
// //                 controller: _titleController,
// //                 decoration: InputDecoration(labelText: 'Title'),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter a title';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               TextFormField(
// //                 controller: _descriptionController,
// //                 decoration: InputDecoration(labelText: 'Description'),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter a description';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               TextFormField(
// //                 controller: _durationController,
// //                 decoration: InputDecoration(labelText: 'Duration (in minutes)'),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter a duration';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: Text(
// //                       'Deadline: ${_selectedDeadline.toLocal()}'.split(' ')[0],
// //                     ),
// //                   ),
// //                   TextButton(
// //                     onPressed: () async {
// //                       final pickedDate = await showDatePicker(
// //                         context: context,
// //                         initialDate: _selectedDeadline,
// //                         firstDate: DateTime.now(),
// //                         lastDate: DateTime(2101),
// //                       );
// //                       if (pickedDate != null) {
// //                         final pickedTime = await showTimePicker(
// //                           context: context,
// //                           initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
// //                         );
// //                         if (pickedTime != null) {
// //                           setState(() {
// //                             _selectedDeadline = DateTime(
// //                               pickedDate.year,
// //                               pickedDate.month,
// //                               pickedDate.day,
// //                               pickedTime.hour,
// //                               pickedTime.minute,
// //                             );
// //                           });
// //                         }
// //                       }
// //                     },
// //                     child: Text('Select Date & Time'),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 16),
// //               ElevatedButton(
// //                 onPressed: _submit,
// //                 child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
