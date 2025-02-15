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
    Unshiped(),
    const Enquiry(),
  ];

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    fetchData();
  }

  // Function to make GET request and print the response
  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.29.10:5100/orders'));

      if (response.statusCode == 200) {
        // Parse the JSON response if successful
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
      body: Column(
        children: [
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
