import 'package:flutter/material.dart';
import 'package:swiggy/components/general_components/dotted_divider.dart';
import 'package:swiggy/pages/payment_page.dart';
import 'package:swiggy/restaurant.dart';

class CartPage extends StatefulWidget {
  final Restaurant restaurant;
  final List<Map<String, dynamic>> order;
  const CartPage({super.key, required this.order, required this.restaurant});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _incrementQuantity(int index) {
    setState(() {
      widget.order[index]['quantity'] =
          (double.parse(widget.order[index]['quantity']) + 1).toString();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (double.parse(widget.order[index]['quantity']) > 1) {
        widget.order[index]['quantity'] =
            (double.parse(widget.order[index]['quantity']) - 1).toString();
      }
    });
  }

  double calculateTotalCost(List<Map<String, dynamic>> order) {
    double total = 0.0;
    for (var item in order) {
      total += double.parse(item['price']) * double.parse(item['quantity']);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = calculateTotalCost(widget.order);
    double gstLogic = totalCost * 0.12;
    double paymentAmt = (totalCost + 21 + 3 + gstLogic);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 232, 241, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(233, 232, 241, 1),
        centerTitle: false,
        title: Text(
          widget.restaurant.name.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Tahoma',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: widget.order.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = widget.order[index];
                            return ListTile(
                              title: Text(item['dish_name']),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('₹ ${item['price']}'),
                                  const SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[700]!,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _decrementQuantity(index),
                                          icon: const Icon(Icons.remove),
                                          color: Colors.green[700],
                                        ),
                                        Text(
                                          double.parse(item['quantity'])
                                              .toInt()
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.green[700],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _incrementQuantity(index),
                                          icon: const Icon(Icons.add),
                                          color: Colors.green[700],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Bill Details',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Item Total'),
                                Text('₹ ${totalCost.toStringAsFixed(2)}'),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Fee'),
                                Text('₹ 21.0'),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'This fee compensates your Delivery\nPartner fairly',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const DottedDivider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delivery Tip'),
                                Text(
                                  'Add Tip',
                                  style: TextStyle(color: Colors.orange[800]),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Platform Fee'),
                                Text('₹ 3.00'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('GST and Restaurant Charges'),
                                Text('₹ ${gstLogic.toStringAsFixed(2)}'),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const DottedDivider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'To Pay',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text('₹ ${paymentAmt.toStringAsFixed(2)}'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                    restaurant: widget.restaurant,
                                    paymentAmt: paymentAmt,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Confirm Address and Pay',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
