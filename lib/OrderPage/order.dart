import 'package:flutter/material.dart';
import 'package:new_projectes/OrderPage/allorder.dart';
import 'package:new_projectes/OrderPage/enquriy.dart';
import 'package:new_projectes/OrderPage/unshiped.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_nav_bar/google_nav_bar.dart'; // Add this import for GNav
import 'package:line_icons/line_icons.dart'; // Add this import for LineIcons

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
          await http.get(Uri.parse('http://192.168.1.3:5000/orders'));

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

  // Handle tab item change for bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: Color(0xffFFB6B6),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: const Icon(Icons.mic, color: Colors.grey),
                    hintText: "Search using name or contact",
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Color(0xffFFB6B6),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          haptic: true,
          tabBorderRadius: 15,
          gap: 8,
          color: Colors.grey[800]!,
          activeColor: Colors.white,
          iconSize: 24,
          tabBackgroundColor: Colors.white.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
          tabs: const [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.shoppingCart,
              text: 'Orders',
            ),
            GButton(
              icon: LineIcons.user,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
