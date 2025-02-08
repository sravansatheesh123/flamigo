import 'package:flutter/material.dart';
import 'package:new_projectes/OrderPage/allorder.dart';
import 'package:new_projectes/OrderPage/enquriy.dart';
import 'package:new_projectes/OrderPage/unshiped.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  int _selectedIndex = 0;

  final List<String> _tabs = ["All Orders", "Unshipped", "Enquiry"];
  final List<Widget> _pages = [
    const Allorder(),
    Unshiped(),
    const Enquriy(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_tabs.length, (index) {
                bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(255, 248, 185, 209)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black38),
                    ),
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
