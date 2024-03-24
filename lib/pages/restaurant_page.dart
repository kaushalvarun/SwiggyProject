import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiggy/components/general_components/custom_loading_spinner.dart';
import 'package:swiggy/components/restaurnat_components/menu_category.dart';
import 'package:swiggy/pages/cart_page.dart';
import 'package:swiggy/restaurant.dart';
import 'package:video_player/video_player.dart';

class RestaurantPage extends StatefulWidget {
  final String userAddress;
  final String restaurantName;
  const RestaurantPage({
    super.key,
    required this.restaurantName,
    required this.userAddress,
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // add to cart snackbar
  Completer<void> _snackBarCompleter = Completer<void>();

  // Function to show the snackbar
  void _showSnackBar(BuildContext context, List<int> quantityCnt) {
    int totalItems = quantityCnt.fold(
        0, (previousValue, element) => previousValue + element);

    // Dismiss any existing snackbar
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    if (totalItems > 0) {
      final snackBar = SnackBar(
        backgroundColor: Colors.green[800],
        content: Container(
          height: 70,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalItems Items added',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to view cart page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartPage(order: order)));
                  // Complete the Completer to dismiss the snackbar
                  _snackBarCompleter.complete();
                },
                child: const Text(
                  'View Cart > ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: Durations.extralong4,
        // Show the new snackbar
      );
      _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      // Show the snackbar only if it's not already shown
      if (!_snackBarCompleter.isCompleted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar)
            .closed
            .then((reason) {
          // Check if the snackbar is closed due to timeout
          if (reason == SnackBarClosedReason.timeout) {
            // Reset the Completer to allow showing the snackbar again
            _snackBarCompleter = Completer<void>();
          }
        });
      }
    } else {
      // If totalItems is 0, dismiss the snackbar if it's showing
      _snackBarCompleter.complete();
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Restaurant? _currRestaurant;

  List<String> menuCategories = [];
  List<Map<String, dynamic>> menu = [];
  // fetching restaurant details
  void fetchRestaurantDetails() async {
    try {
      QuerySnapshot restaurantQuerySnapshot = await _firestore
          .collection('cities')
          .doc('Vellore')
          .collection('restaurants')
          .where('name', isEqualTo: widget.restaurantName)
          .get();

      if (restaurantQuerySnapshot.docs.isNotEmpty) {
        DocumentSnapshot restaurantDoc = restaurantQuerySnapshot.docs.first;
        // Access restaurant data
        Map<String, dynamic> restaurantData =
            restaurantDoc.data() as Map<String, dynamic>;

        setState(() {
          _currRestaurant = Restaurant.fromJson(restaurantData);
        });

        List<Map<String, dynamic>> menuLoc =
            (restaurantData['menu'] as List<dynamic>)
                .map((e) => e as Map<String, dynamic>)
                .toList();

        // Fetch menu entries
        setState(() {
          menu = menuLoc;
        });

        List<String> menuCat = [];
        // Iterate through each menu entry
        for (int i = 0; i < menu.length; i++) {
          menuCat.add(menu[i]['category_name']);
        }

        setState(() {
          menuCategories = menuCat;
        });
      } else {
        const AlertDialog(title: Text('Restaurant not found'));
      }
    } on Exception catch (e) {
      // ignore: avoid_print
      print('Error fetching restaurant data, Error: $e');
    }
  }

  @override
  void initState() {
    fetchRestaurantDetails();
    order = [];
    super.initState();
  }

  // scroll control
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: true,
    initialScrollOffset: 0.0,
  );
  final ScrollController _scrollController1 = ScrollController(
    keepScrollOffset: true,
    initialScrollOffset: 0.0,
  );

  // order
  late List<Map<String, dynamic>> order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(233, 232, 241, 1),
      ),
      body: (_currRestaurant == null || menuCategories.isEmpty || menu.isEmpty)
          ? (Center(
              child: SizedBox(
                  height: 250,
                  width: 250,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: (CustomLoadingSpinner(
                      videoPlayerController: VideoPlayerController.asset(
                          'lib/assets/videos/restaurantLoading.mp4'),
                      looping: true,
                      autoplay: true,
                    )),
                  )),
            ))
          : SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                color: Colors.white,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      // restaurant name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(233, 232, 241, 1),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 250,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      // restaurant name
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            _currRestaurant!.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,
                                              fontFamily: 'Tahoma',
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Rating
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.stars,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              _currRestaurant!.rating
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                fontFamily: 'Tahoma',
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              '${_currRestaurant!.cost} for two',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                fontFamily: 'Tahoma',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Cuisine
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            _currRestaurant!.cuisine,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              fontFamily: 'Tahoma',
                                            ),
                                          ),
                                        ],
                                      ),

                                      // divider
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Divider(height: 2),
                                      ),

                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'lib/assets/images/barDumbell.png',
                                                height: 60,
                                                width: 40,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Outlet',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Tahoma',
                                                            fontSize: 15,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            width: 50),
                                                        Expanded(
                                                          child: Text(
                                                            _currRestaurant!
                                                                .address,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Tahoma',
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // deliver to me
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          '30-35 mins',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Tahoma',
                                                            fontSize: 15,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            widget.userAddress,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Tahoma',
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      // divider
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Divider(height: 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,

                        // discount banner
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(
                                      'lib/assets/images/offerSymbol.jpeg')),
                              const SizedBox(width: 5),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '50% off up to ₹100',
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'USE SWIGGYIT | ABOVE ₹149',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/images/menu2.png',
                              width: 20,
                              height: 20,
                            ),
                            const Text(
                              ' M E N U ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  fontFamily: 'Monospace'),
                            ),
                            Image.asset(
                              'lib/assets/images/menu1.png',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),

                      // Search bar
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(233, 232, 241, 1),
                            hintText: 'Search Dishes',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Divider(height: 2),
                      ),

                      // menu
                      Expanded(
                        child: Container(
                          color: const Color.fromRGBO(233, 232, 241, 1),
                          child: ListView.builder(
                            controller: _scrollController1,
                            itemCount: menuCategories.length,
                            itemBuilder: (context, index) {
                              // dish management
                              List<bool> addButtonTapped = List<bool>.filled(
                                  menu[index]['dishes'].length, false);
                              List<int> quantityCnt = List<int>.filled(
                                  menu[index]['dishes'].length, 0);
                              return MenuCategory(
                                order: order,
                                itemCount: menu[index]['dishes'].length,
                                menuCategories: menuCategories[index],
                                addButtonTapped: addButtonTapped,
                                quantityCnt: quantityCnt,
                                dishMap: menu[index]['dishes'],
                                onQuantityChanged: (updatedQuantityCnt) {
                                  _showSnackBar(context, updatedQuantityCnt);
                                },
                                onOrderChanged: (neworder) {
                                  setState(() {
                                    order = neworder;
                                  });
                                },
                              );
                            },
                          ),
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
