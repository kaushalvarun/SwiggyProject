import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> order;
  const CartPage({super.key, required this.order});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: ListView.builder(
        itemCount: widget.order.length,
        itemBuilder: (context, index) {
          final item = widget.order[index];
          return ListTile(
            title: Text(item['dish_name']),
            subtitle:
                Text('Price: ${item['price']} | Quantity: ${item['quantity']}'),
          );
        },
      ),
    );
  }
}
