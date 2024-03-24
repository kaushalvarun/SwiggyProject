// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MenuCategory extends StatefulWidget {
  final List<Map<String, dynamic>> order;
  final menuCategories;
  final List<bool> addButtonTapped;
  final List<int> quantityCnt;
  final int itemCount;
  final dishMap;
  final Function(List<int>) onQuantityChanged; // Callback function
  final Function(List<Map<String, dynamic>>)
      onOrderChanged; // Callback function

  const MenuCategory({
    super.key,
    required this.addButtonTapped,
    required this.quantityCnt,
    required this.menuCategories,
    required this.itemCount,
    required this.dishMap,
    required this.onQuantityChanged,
    required this.order,
    required this.onOrderChanged,
  });

  @override
  State<MenuCategory> createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> {
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: true,
    initialScrollOffset: 0.0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          widget.menuCategories,
          style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 18, fontFamily: 'Tahoma'),
        ),
        children: [
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: widget.itemCount,
            itemBuilder: (context, indexMenuCat) {
              bool veg =
                  (widget.dishMap[indexMenuCat]['veg_or_non_veg'] == 'Veg');

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        veg
                            ? Image.asset('lib/assets/images/veg.png',
                                height: 20, width: 20)
                            : Image.asset('lib/assets/images/nonveg.png',
                                height: 20, width: 20),
                        const SizedBox(height: 5),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Text(
                            widget.dishMap[indexMenuCat]['dish_name'],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Tahoma'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          widget.dishMap[indexMenuCat]['price'],
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.quantityCnt[indexMenuCat] > 0) {
                          return;
                        }
                        setState(() {
                          widget.addButtonTapped[indexMenuCat] =
                              !widget.addButtonTapped[indexMenuCat];
                        });
                      },
                      child: widget.addButtonTapped[indexMenuCat]
                          ? Container(
                              width: 100,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey[700]!, width: 0.5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        if (widget.quantityCnt[indexMenuCat] >
                                            0) {
                                          setState(() {
                                            widget.quantityCnt[indexMenuCat]--;
                                            widget.onQuantityChanged(
                                                widget.quantityCnt);

                                            // dish already present
                                            for (int i = 0;
                                                i < widget.order.length;
                                                i++) {
                                              if (widget.order[i]
                                                      ['dish_name'] ==
                                                  widget.dishMap[indexMenuCat]
                                                      ['dish_name']) {
                                                // quantity
                                                widget.order[i].update(
                                                    'quantity',
                                                    (value) =>
                                                        (double.parse(value) -
                                                                1)
                                                            .toString(),
                                                    ifAbsent: () => '1');

                                                widget.onOrderChanged(
                                                    widget.order);
                                              }
                                            }
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                  ),
                                  Text(
                                    widget.quantityCnt[indexMenuCat].toString(),
                                    style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.quantityCnt[indexMenuCat]++;
                                          widget.onQuantityChanged(
                                              widget.quantityCnt);

                                          // dish already present
                                          bool dishPresent = false;
                                          for (int i = 0;
                                              i < widget.order.length;
                                              i++) {
                                            if (widget.order[i]['dish_name'] ==
                                                widget.dishMap[indexMenuCat]
                                                    ['dish_name']) {
                                              dishPresent = true;

                                              widget.order[i].update(
                                                  'quantity',
                                                  (value) =>
                                                      (double.parse(value) + 1)
                                                          .toString(),
                                                  ifAbsent: () => '1');
                                              widget
                                                  .onOrderChanged(widget.order);
                                            }
                                          }
                                          if (!dishPresent) {
                                            // add dish
                                            widget.order.add({
                                              'dish_name':
                                                  widget.dishMap[indexMenuCat]
                                                      ['dish_name'],
                                              'quantity': widget
                                                  .quantityCnt[indexMenuCat]
                                                  .toString(),
                                              'price':
                                                  widget.dishMap[indexMenuCat]
                                                      ['price']
                                            });
                                            widget.onOrderChanged(widget.order);
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey[700]!, width: 0.5),
                              ),
                              child: Center(
                                child: Text(
                                  'ADD',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
