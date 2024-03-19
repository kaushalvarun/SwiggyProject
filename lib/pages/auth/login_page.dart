import 'package:swiggy/components/general_components/my_button.dart';
import 'package:swiggy/components/general_components/my_text_field.dart';
import 'package:swiggy/util/error_msg_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      Navigator.pop(context);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.toLowerCase(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      // WRONG username
      if (e.code == "invalid-email") {
        // ignore: use_build_context_synchronously
        showErrorMessage(context, 'Wrong Username');
      }

      // WRONG password
      else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        // ignore: use_build_context_synchronously
        showErrorMessage(context, 'Wrong Password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[50], // bg color for login page
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  // logo
                  Image.asset(
                    'lib/assets/images/swiggy_logo.png',
                    height: 175,
                    width: 175,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // welcome back
                  const Text(
                    'Welcome back, you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // username
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Enter email',
                    obscureText: false,
                  ),

                  // password
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Enter password',
                    obscureText: true,
                  ),

                  // forgot password
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                    msg: 'Sign In',
                    textColor: Colors.white,
                    buttonColor: Colors.black,
                  ),

                  const SizedBox(height: 25),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
