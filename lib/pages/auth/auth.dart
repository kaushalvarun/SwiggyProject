import 'package:swiggy/pages/auth/login_page.dart';
import 'package:swiggy/pages/get_location.dart';
// import 'package:swiggy/pages/home_page.dart';
import 'package:swiggy/pages/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // checking if user is logged in or not
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if firebase waiting show splash screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        // user logged in
        if (snapshot.hasData) {
          print('change me to HomePage');
          return const GetLocation();
        }
        // user not logged in
        else {
          return const LoginPage();
        }
      },
    );
  }
}
