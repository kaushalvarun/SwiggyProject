import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swiggy/pages/auth/login_page.dart';
import 'package:swiggy/services/auth_service.dart';

class HomePage extends StatelessWidget {
  final Position? currentPosition;
  final String? currentAddress;
  const HomePage({
    super.key,
    this.currentPosition,
    this.currentAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('LAT: ${currentPosition?.latitude ?? ""}'),
            Text('LNG: ${currentPosition?.longitude ?? ""}'),
            Text('ADDRESS: ${currentAddress ?? ""}',
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
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
