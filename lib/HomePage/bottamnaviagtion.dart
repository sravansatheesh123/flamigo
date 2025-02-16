import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:new_projectes/HomePage/homepage.dart';
import 'package:new_projectes/OrderPage/order.dart';
import 'package:new_projectes/ProfilePage/profile.dart';

class Bottamnaviagtion extends StatefulWidget {
  const Bottamnaviagtion({super.key});

  @override
  _HomemainState createState() => _HomemainState();
}

class _HomemainState extends State<Bottamnaviagtion> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const Order(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFB6B6),
        appBar: _selectedIndex == 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(
                  color: Color(0xffFFB6B6),
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
                                icon:
                                    const Icon(Icons.menu, color: Colors.black),
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
                            suffixIcon:
                                const Icon(Icons.mic, color: Colors.grey),
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
              )
            : null, // No AppBar for Order and Profile pages
        body: _pages[_selectedIndex],
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
      ),
    );
  }
}
