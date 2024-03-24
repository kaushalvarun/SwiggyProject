import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swiggy/components/general_components/search_bar.dart';
import 'package:swiggy/pages/loading_rest.dart';
import 'package:swiggy/pages/user_profile/logout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController controller = TextEditingController();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String? _userAddressLabel;
  String? _userAddress;

  @override
  void initState() {
    getUserData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.initState();
  }

  void getUserData() async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        setState(() {
          _userAddress = userData!['address'] ?? '';
          _userAddressLabel = userData['addressLabel'] ?? '';
        });
      } else {
        // ignore: avoid_print
        print('User document not found');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user data: $e');
    }
  }

  // ignore: unused_element
  void _onSearch() {}

  // slider images
  List<String> sliderImages = ['lib/assets/images/sliderHome1.jpeg'];
  // types grid data
  List<String> gridImages = [
    'lib/assets/images/localMustTrys.png',
    'lib/assets/images/mealsFrom119.png',
    'lib/assets/images/awardWinners.png',
    'lib/assets/images/pocketHero.png',
    'lib/assets/images/pocketHeroImage2.png',
    'lib/assets/images/offerZone.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // app bar
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: MediaQuery.of(context).size.width * 0.15,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: MediaQuery.of(context).size.width * 0.5,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 1, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'lib/assets/images/addressArrow.png',
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    (_userAddressLabel == null) ? '' : _userAddressLabel!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                (_userAddress == null) ? '' : _userAddress!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'lib/assets/images/buyOne.jpeg',
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogOutPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.account_circle),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // main body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // search bar
              MySearchBar(controller: controller),

              const SizedBox(height: 30),

              // offer slider
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 130,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      sliderImages[0],
                      fit: BoxFit.fill,
                    )),
              ),

              const SizedBox(height: 15),

              // types grid
              SizedBox(
                height: 240,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Container(
                            color: Colors.white,
                            height: 60,
                            width: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                gridImages[index],
                                fit: BoxFit.contain,
                              ),
                            )),
                      );
                    }),
              ),

              const SizedBox(height: 15),

              // top rated near you
              // header
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'TOP RATED NEAR YOU',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Divider(height: 1, color: Colors.grey[400])),
                ],
              ),

              // restaurants
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('cities')
                      .doc('Vellore')
                      .collection('restaurants')
                      .orderBy('rating', descending: true)
                      .limit(10)
                      .snapshots(),
                  builder: (context, snapshot) {
                    // error
                    if (snapshot.hasError) {
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: Text(
                              'Something went wrong...\n Error: ${snapshot.error}'),
                        ),
                      );
                    }

                    // Loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: Text('No restuarants available..'),
                        ),
                      );
                    }
                    // Data available, process and display
                    final topRatedRestaurants = snapshot.data!.docs;

                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topRatedRestaurants.length,
                          itemBuilder: (context, index) {
                            // Access restaurant data from document snapshot
                            final restaurantDoc = topRatedRestaurants[index];

                            final restaurantData =
                                restaurantDoc.data() as Map<String, dynamic>;
                            if (_userAddress != null) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoadingRest(
                                          userAddress: _userAddress!,
                                          restaurantName:
                                              restaurantData['name'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 170,
                                        width: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.asset(
                                            'lib/assets/images/restaurantImages/R${index + 1}.avif',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      // Restaurant name
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  restaurantData['name'] ?? '',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),

                                            // rating
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.stars,
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                    '${restaurantData['rating']}'),
                                              ],
                                            ),
                                            // cuisine
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    restaurantData['cuisine'] ??
                                                        ''),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return null;
                          }),
                    );
                  }),
            ],
          ),
        ),
      ),

      // bottom nav bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          // food
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/images/foodIcon.png',
              fit: BoxFit.cover,
              height: 24,
              width: 24,
            ),
            activeIcon: Image.asset(
              'lib/assets/images/foodIconActive.png',
              fit: BoxFit.cover,
              height: 24,
              width: 24,
            ),
            label: 'Food',
          ),
          // genie
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/images/genie.png',
              fit: BoxFit.cover,
              height: 24,
              width: 24,
            ),
            activeIcon: Image.asset(
              'lib/assets/images/genieActive.png',
              fit: BoxFit.cover,
              height: 24,
              width: 24,
            ),
            label: 'Genie',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Credit Card',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
