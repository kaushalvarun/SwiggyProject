// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

class AddCoordinatesToRestaurants extends StatefulWidget {
  const AddCoordinatesToRestaurants({super.key});

  @override
  State<AddCoordinatesToRestaurants> createState() =>
      _AddCoordinatesToRestaurantsState();
}

class _AddCoordinatesToRestaurantsState
    extends State<AddCoordinatesToRestaurants> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;
  int _requestCount = 0;
  List<Map<String, dynamic>> _restaurantsData = [];
  int _sucCnt = 0;
  int _failCnt = 0;

  Future<void> addCoordinatesToRestaurants() async {
    // Get a reference to the restaurants collection
    CollectionReference restaurantsRef = _firestore
        .collection('cities')
        .doc('Vellore')
        .collection('restaurants');
    try {
      // Get all documents in the restaurants collection
      QuerySnapshot restaurantsSnapshot = await restaurantsRef.get();

      // Store restaurant data in a list
      _restaurantsData = restaurantsSnapshot.docs
          .map((doc) => {'id': doc.id, 'address': doc['address']})
          .toList();

      // Schedule the task to get coordinates for restaurants
      _scheduleGetCoordinates();
      print('Request scheduling completed.');
    } catch (e) {
      print('Error adding coordinates, Error msg: $e');
    }
  }

  // Schedule a task to get coordinates for restaurants
  void _scheduleGetCoordinates() async {
    const batchSize = 10; // Number of requests per batch
    const delay = Duration(milliseconds: 20000); // Delay between batches

    _timer = Timer.periodic(delay, (timer) async {
      if (_requestCount >= _restaurantsData.length) {
        // All restaurants processed, cancel the timer
        timer.cancel();
        print('All coordinates updated successfully!');
        print('sucCnt: $_sucCnt');
        print('failCnt: $_failCnt');
        print('Total: ${_sucCnt + _failCnt}');
      } else {
        int endIndex = (_requestCount + batchSize <= _restaurantsData.length)
            ? _requestCount + batchSize
            : _restaurantsData.length;

        List<Map<String, dynamic>> batchData =
            _restaurantsData.sublist(_requestCount, endIndex);

        for (var restaurant in batchData) {
          String docId = restaurant['id'];
          String address = restaurant['address'];
          List<double> coordinates = await getCoordinatesFromAddress(address);

          if (coordinates.isNotEmpty) {
            // Update the document with coordinates field
            await _firestore
                .collection('cities')
                .doc('Vellore')
                .collection('restaurants')
                .doc(docId)
                .update({'coordinates': coordinates});

            print('Coordinates updated for $docId');
            _sucCnt++;
          } else {
            print('Error getting coordinates for $docId');
            _failCnt++;
          }

          _requestCount++; // Increment request count
        }
      }
    });
  }

  // Function to get coordinates from the address
  Future<List<double>> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        print('$latitude, $longitude');
        return [latitude, longitude];
      } else {
        print('No coordinates found for the address.');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coordinates to Restaurants'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addCoordinatesToRestaurants,
          child: const Text('Add Coordinates'),
        ),
      ),
    );
  }
}
