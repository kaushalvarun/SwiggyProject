import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swiggy/components/general_components/heading.dart';
import 'package:swiggy/components/general_components/my_button.dart';
import 'package:swiggy/pages/home_page.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _addressLabel;
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // Check if the context is still valid before interacting with it
    if (!context.mounted) {
      return false;
    }

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ),
      );

      return false;
    }
    // Check if the context is still valid before interacting with it
    if (!context.mounted) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // Check if the context is still valid before interacting with it
      if (!context.mounted) {
        return false;
      }

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    // Check if the context is still valid before interacting with it
    if (!context.mounted) {
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // get latitude and longitude of user
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
      // ge address
      await _getAddressFromLatLng(_currentPosition!);
      // add details to db
      try {
        await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'position': [_currentPosition!.latitude, _currentPosition!.longitude],
          'address': _currentAddress!,
          'addressLabel': _addressLabel!,
        });
      } catch (e) {
        // ignore: avoid_print
        print('Error adding address to user: $e');
      }
    }).catchError((e) {
      // ignore: avoid_print
      print(e);
    });
  }

  // get address from latitude and longitude
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _addressLabel = place.subLocality;
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      // ignore: avoid_print
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyHeading(
                      text: 'What\'s your location?',
                    ),

                    SizedBox(height: 12),

                    // subheading text
                    Text(
                      'We need your location to show available restaurants & products.',
                      style: TextStyle(
                        color: Color(0xFF616161),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // fancy location image
              Image.asset(
                'lib/assets/images/FancyLocation.png',
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 20),
              // continue button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    onPressed: () async {
                      await _getCurrentPosition();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    },
                    msg: 'Continue',
                    buttonColor: Colors.deepOrange[600]!,
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // enter location manually
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Enter location manually',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
