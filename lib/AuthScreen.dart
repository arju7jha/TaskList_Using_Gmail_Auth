import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
      Navigator.of(context).pushReplacementNamed('/tasks');
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please check your credentials!';
      if (e.code == 'network-request-failed') {
        message = 'A network error occurred. Please try again later.';
      } else if (e.code == 'captcha-check-failed') {
        message = 'reCAPTCHA verification failed. Please try again.';
      } else if (e.code == 'invalid-recaptcha-token') {
        message = 'Invalid reCAPTCHA token. Please try again.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password. Please try again.';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unknown error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin ? 'Login' : 'Register',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Please enter a password with at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (!isLogin)
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(isLogin ? 'Login' : 'Register'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin ? 'Don\'t have an account? Register' : 'Already have an account? Login',
                    style: TextStyle(color: Colors.blue),
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


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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
//       print(e.message);
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
