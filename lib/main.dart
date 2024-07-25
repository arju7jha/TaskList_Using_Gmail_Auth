import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AuthScreen.dart';
import 'screens/task_screen.dart';
import 'screens/task_form_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(),
        '/tasks': (context) => TaskScreen(),
        '/task_form': (context) => TaskFormScreen(),
      },
    );
  }
}



// // main.dart
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'AuthScreen.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//           apiKey: "AIzaSyAWmhRHPEgOfiLiIuFZxbEuXkmZmOHoduE",
//           authDomain: "tasklist-52cfc.firebaseapp.com",
//           projectId: "tasklist-52cfc",
//           storageBucket: "tasklist-52cfc.appspot.com",
//           messagingSenderId: "811006370180",
//           appId: "1:811006370180:web:fb7e0d700c305e3298fdd1",
//           measurementId: "G-1BX10XFLD7"),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }
//
//   var initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   // var initializationSettingsIOs = IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid, );
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   runApp(MyApp());
// }
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthScreen(),
//     );
//   }
// }

// Add notification scheduling code in TaskFormScreen




// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'AuthScreen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//           apiKey: "AIzaSyAWmhRHPEgOfiLiIuFZxbEuXkmZmOHoduE",
//           authDomain: "tasklist-52cfc.firebaseapp.com",
//           projectId: "tasklist-52cfc",
//           storageBucket: "tasklist-52cfc.appspot.com",
//           messagingSenderId: "811006370180",
//           appId: "1:811006370180:web:fb7e0d700c305e3298fdd1",
//           measurementId: "G-1BX10XFLD7"
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthScreen(),
//     );
//   }
// }



// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: "AIzaSyAWmhRHPEgOfiLiIuFZxbEuXkmZmOHoduE",
//         authDomain: "tasklist-52cfc.firebaseapp.com",
//         projectId: "tasklist-52cfc",
//         storageBucket: "tasklist-52cfc.appspot.com",
//         messagingSenderId: "811006370180",
//         appId: "1:811006370180:web:fb7e0d700c305e3298fdd1",
//         measurementId: "G-1BX10XFLD7",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthScreen(),
//     );
//   }
// }
//
// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   bool isLogin = true;
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   void _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     try {
//       if (isLogin) {
//         await _auth.signInWithEmailAndPassword(
//           email: _emailController.text,
//           password: _passwordController.text,
//         );
//       } else {
//         await _auth.createUserWithEmailAndPassword(
//           email: _emailController.text,
//           password: _passwordController.text,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   isLogin ? 'Login' : 'Register',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 24),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty || !value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value.length < 6) {
//                       return 'Please enter a password with at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 if (!isLogin)
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Confirm Password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value != _passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                 SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: _submit,
//                   child: Text(isLogin ? 'Login' : 'Register'),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       isLogin = !isLogin;
//                     });
//                   },
//                   child: Text(
//                     isLogin ? 'Don\'t have an account? Register' : 'Already have an account? Login',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
