import 'package:flutter/material.dart';
import 'package:new_projectes/OrderPage/allorder.dart';
import 'package:new_projectes/OrderPage/enquriy.dart';
import 'package:new_projectes/OrderPage/unshiped.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    Unshipped(),
    Enquiry(),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.29.10:5000/orders'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Response data: $data');
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Hide AppBar when "Enquiry" tab is selected
      appBar: _selectedIndex == 2
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Container(
                color: const Color(0xffFFB6B6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 2),
                            IconButton(
                              icon: const Icon(Icons.menu, color: Colors.black),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/Flamingo Logo.png',
                              width: 55,
                              height: 55,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.person_2_outlined,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                            const Text(
                              "Sagar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: const Icon(Icons.mic, color: Colors.grey),
                          hintText: "Search using name or contact",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            color: Colors.grey,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      body: Column(
        children: [
          // Hide the tab view when "Enquiry" is selected
          if (_selectedIndex != 2)
            Container(
              color: const Color(0xffFFEEEE),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xffE15D5D) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black38),
                      ),
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
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
