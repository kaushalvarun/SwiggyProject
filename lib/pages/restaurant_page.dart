import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiggy/components/general_components/custom_loading_spinner.dart';
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
    super.initState();
    _scrollController.addListener(() {
      _scrollController.addListener(scrollPosition);
    });
    _scrollController1.addListener(() {
      _scrollController1.addListener(scrollPosition1);
    });
    _scrollController2.addListener(() {
      _scrollController1.addListener(scrollPosition2);
    });
  }

// scroll control
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  var isTopPosition = 0.0;
  var isTopPosition1 = 0.0;
  var isTopPosition2 = 0.0;

  void scrollPosition() {
    final isTop = _scrollController.position.pixels;

    setState(() {
      isTopPosition = isTop;
    });
  }

  void scrollPosition1() {
    final isTop1 = _scrollController1.position.pixels;

    setState(() {
      isTopPosition1 = isTop1;
    });
  }

  void scrollPosition2() {
    final isTop2 = _scrollController2.position.pixels;

    setState(() {
      isTopPosition2 = isTop2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(233, 232, 241, 1),
      ),
      body: (_currRestaurant == null || menuCategories.isEmpty || menu.isEmpty)
          ? (Center(
              child: SizedBox(
                  height: 100,
                  width: 100,
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
                              return Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(bottom: 15),
                                color: Colors.white,
                                child: ExpansionTile(
                                  title: Text(
                                    menuCategories[index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        fontFamily: 'Tahoma'),
                                  ),
                                  children: [
                                    ListView.builder(
                                        controller: _scrollController2,
                                        shrinkWrap: true,
                                        itemCount: menu[index]['dishes'].length,
                                        itemBuilder: (context, indexMenuCat) {
                                          bool veg = (menu[index]['dishes']
                                                          [indexMenuCat]
                                                      ['veg_or_non_veg'] ==
                                                  'Veg')
                                              ? true
                                              : false;
                                          // dish
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    (veg)
                                                        ? Image.asset(
                                                            'lib/assets/images/veg.png',
                                                            height: 20,
                                                            width: 20,
                                                          )
                                                        : Image.asset(
                                                            'lib/assets/images/nonveg.png',
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxWidth: 150,
                                                      ),
                                                      child: Text(
                                                        menu[index]['dishes']
                                                                [indexMenuCat]
                                                            ['dish_name'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: 'Tahoma',
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      menu[index]['dishes']
                                                              [indexMenuCat]
                                                          ['price'],
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                                // add to cart button
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    width: 100,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color:
                                                            Colors.grey[700]!,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'ADD',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.green[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
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
