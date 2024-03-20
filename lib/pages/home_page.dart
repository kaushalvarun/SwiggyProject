import 'package:flutter/material.dart';
import 'package:swiggy/pages/auth/login_page.dart';
import 'package:swiggy/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Logged in!"),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                AuthService.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
