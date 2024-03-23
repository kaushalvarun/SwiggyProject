import 'package:flutter/material.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<String> menuCategories = [
    'Bestseller',
    'Recommended',
    'Vegetarian Breakfast',
    'DIMSUM VEG',
    'DIMSUM Non-veg',
    'Soup',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(233, 232, 241, 1),
      ),
      body: SingleChildScrollView(
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
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Restaurant name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                        fontFamily: 'Tahoma',
                                      ),
                                    ),
                                  ],
                                ),
                                // Rating
                                const Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.stars,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Rating (Number of Ratings)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          fontFamily: 'Tahoma',
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Cost',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          fontFamily: 'Tahoma',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Cuisine
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cuisine1, Cuisine2',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        fontFamily: 'Tahoma',
                                      ),
                                    ),
                                  ],
                                ),

                                // divider
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Divider(height: 2),
                                ),

                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
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
                                        const Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Outlet',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Tahoma',
                                                      fontSize: 15,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(width: 50),
                                                  Expanded(
                                                    child: Text(
                                                      'Restaurant\'s Address',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'Tahoma',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // deliver to me
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '30-35 mins',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Tahoma',
                                                      fontSize: 15,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      'Current User\'s Address',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'Tahoma',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.transparent),
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

                // menu options
                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(233, 232, 241, 1),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuCategories.length,
                      itemBuilder: (context, index) {
                        bool veg = false; // to be implemented
                        // dish category tile
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
                              // dish
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (veg)
                                            // ignore: dead_code
                                            ? Image.asset(
                                                'lib/assets/images/veg.png',
                                                height: 20,
                                                width: 20,
                                              )
                                            // ignore: dead_code
                                            : Image.asset(
                                                'lib/assets/images/nonveg.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Dish Name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Tahoma'),
                                        ),
                                        const Text(
                                          'Dish Price',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.green,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Dish Rating',
                                              style: TextStyle(
                                                  color: Colors.green[800]),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                    // add to cart button
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 120,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors
                                                  .white, // Set container background color
                                              border: Border.all(
                                                  color: Colors.grey[700]!,
                                                  width: 0.5), // Add border
                                            ),
                                            child: Center(
                                              child: Text(
                                                'ADD',
                                                style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
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
