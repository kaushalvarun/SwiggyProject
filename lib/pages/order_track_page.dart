// ignore_for_file: avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackPage extends StatefulWidget {
  final String restAddress;

  const OrderTrackPage({super.key, required this.restAddress});

  @override
  State<OrderTrackPage> createState() => _OrderTrackPageState();
}

class _OrderTrackPageState extends State<OrderTrackPage> {
  final Completer<GoogleMapController> _controller = Completer();
  List<double> userPosn = [0, 0];
  List<double> restPosn = [0, 0];
  static LatLng sourceLocation = const LatLng(0, 0);
  static LatLng destination = const LatLng(0, 0);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getUserCoord();
    getRestCoord();
  }

  Future<void> getUserCoord() async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          final positionData = userData['position'] as List<dynamic>?;
          if (positionData != null) {
            final userPos = positionData
                .map((e) => (e as num?)?.toDouble() ?? 0.0)
                .whereType<double>()
                .toList();

            setState(() {
              userPosn = userPos;
              destination = LatLng(userPos[0], userPos[1]);
            });
          }
        }
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> getRestCoord() async {
    final query = widget.restAddress;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location first = locations.first;
        setState(() {
          restPosn = [first.latitude, first.longitude];
          sourceLocation = LatLng(first.latitude, first.longitude);
        });
      } else {
        print("No location found for the query: $query");
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('User Position'),
          Text('${userPosn[0]}, ${userPosn[1]}'),
          const SizedBox(height: 20),
          const Text('Restaurant Position'),
          Text('${restPosn[0]}, ${restPosn[1]}'),
          // Expanded(
          //   child: GoogleMap(
          //     initialCameraPosition: CameraPosition(
          //       target: sourceLocation,
          //       zoom: 10,
          //     ),
          //     markers: {
          //       Marker(
          //         markerId: const MarkerId("source"),
          //         position: sourceLocation,
          //       ),
          //       Marker(
          //         markerId: const MarkerId("destination"),
          //         position: destination,
          //       ),
          //     },
          //     onMapCreated: (mapController) {
          //       _controller.complete(mapController);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
