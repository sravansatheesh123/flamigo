import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Enquiry extends StatefulWidget {
  const Enquiry({super.key});

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  bool isLoading = false;
  bool isExpandedOrderTracking = false;
  bool isExpandedDeliveryTime = false;
  bool isExpandedFlamingoOrder = false;

  TextEditingController searchController = TextEditingController();
  List<String> allItems = [
    "How to track my order?",
    "Estimate time of delivery",
    "What else can I order from Flamingo Creativity?"
  ];
  List<String> searchResults = [];

  String receiverName = "";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    searchResults = List.from(allItems);
  }

  // Function to search for order by contact
  Future<void> searchOrderByContact(String contact) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
      receiverName = "";
    });

    final url =
        Uri.parse('http://localhost:5000/orders/contact?contact=$contact');

    try {
      final response = await http.get(url);

      print("user url $url");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['data'].isNotEmpty) {
          setState(() {
            receiverName = data['data'];
            errorMessage = "";
          });
        } else {
          setState(() {
            receiverName = "";
            errorMessage = 'No order found for this contact number.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch data. Please try again.';
          receiverName = "";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        receiverName = "";
      });
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: const Color(0xffFFB6B6),
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
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchResults = allItems
                          .where((result) => result
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchResults =
                              List.from(allItems); // Reset to all items
                        });
                      },
                    ),
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
      body: Container(
        color: const Color(0xffFFEEEE),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: searchResults.isNotEmpty
                ? searchResults.map((result) {
                    if (result == "How to track my order?") {
                      return _buildExpandableTile(
                        icon: Icons.location_on_outlined,
                        title: result,
                        isExpanded: isExpandedOrderTracking,
                        onTap: () {
                          setState(() {
                            isExpandedOrderTracking = !isExpandedOrderTracking;
                          });
                        },
                        content: const [
                          Text("Follow these steps to track your order:"),
                          SizedBox(height: 5),
                          Text(
                              "• Enter your contact number in the track via contact input field."),
                          Text("• Click on the search icon 🔍."),
                          Text(
                              "• After a few days of dispatching the order, it will be updated with a courier website link and tracking ID."),
                          Text(
                              "• When you see courier details, go to the link and enter your tracking ID."),
                          Text(
                              "• You will be able to see the status of your parcel."),
                        ],
                      );
                    } else if (result == "Estimate time of delivery") {
                      return _buildExpandableTile(
                        icon: Icons.message_outlined,
                        title: result,
                        isExpanded: isExpandedDeliveryTime,
                        onTap: () {
                          setState(() {
                            isExpandedDeliveryTime = !isExpandedDeliveryTime;
                          });
                        },
                        content: const [
                          Text(
                              "The estimated date of delivery is usually 10 days."),
                          SizedBox(height: 5),
                          Text(
                              "• However, it will be delivered sooner if you have discussed it with our customer support."),
                          Text(
                              "• If your delivery location is near our factory, it may arrive earlier."),
                        ],
                      );
                    } else if (result ==
                        "What else can I order from Flamingo Creativity?") {
                      return _buildExpandableTile(
                        icon: Icons.shopping_bag_outlined,
                        title: result,
                        isExpanded: isExpandedFlamingoOrder,
                        onTap: () {
                          setState(() {
                            isExpandedFlamingoOrder = !isExpandedFlamingoOrder;
                          });
                        },
                        content: const [
                          Text(
                              "We are glad to provide you with the best quality products and packaging."),
                          SizedBox(height: 5),
                          Text(
                              "• If you want to order something different other than website hampers, contact us over WhatsApp for the same."),
                        ],
                      );
                    } else {
                      return Container(); // Empty container if no result matches
                    }
                  }).toList()
                : [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Receipt",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffDEC55A),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Flamingo Creativity",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 2),
                                    Text("Phone: 9342724119",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 2),
                                    Text("Email: example@email.com",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 2),
                                    Text("GST: GSTINXXXXXXXXXX",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 2),
                                    Text("State: Kerala",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Image.asset(
                                  'assets/images/IMG_8698.PNG',
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black, thickness: 1),
                          const Center(
                            child: Text(
                              "Tax Invoice",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Bill To:",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Sneha Verma",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Ship To:",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Address Here",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Text(
                                      "Invoice Details:",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 2),
                                    Text("Invoice Number: 3505",
                                        style: TextStyle(fontSize: 10)),
                                    SizedBox(height: 2),
                                    Text("Date: 09/01/2025",
                                        style: TextStyle(fontSize: 10)),
                                    SizedBox(height: 2),
                                    Text("Place : 09 - Uttar Pradesh",
                                        style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            color: Colors.grey.shade300,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Item Name"),
                                Text("HSN/SAC"),
                                Text("Quantity"),
                                Text("Price/Unit"),
                                Text("GST"),
                                Text("Amount"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("1 Wallet Combo",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text("42023120"),
                              Text("1"),
                              Text("₹3,016"),
                              Text("₹542"),
                              Text("₹3,559"),
                            ],
                          ),
                          const Divider(color: Colors.black, thickness: 1),
                          const SizedBox(height: 5),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(""),
                              Text(""),
                              Text(""),
                              Text("1"),
                              Text(""),
                              Text("₹542"),
                              Text("₹3,559"),
                            ],
                          ),
                          const Divider(color: Colors.black, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Invoice Amount in Words:"),
                              Text("Sub Total"),
                              Text("₹3,016.10"),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                  "Three Thousand Five Hundred \n and Fifty-Nine Rupees"),
                              Text("IGST @18.0%"),
                              SizedBox(
                                width: 5,
                              ),
                              Text("₹542"),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Terms and Conditions"),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Total",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 125,
                                    ),
                                    Text("₹3,559",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Thank you  for doing\n bussines "),
                              Text("Recived"),
                              Text("₹3,559"),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          123), // Moves "Balance" slightly to the right
                                  child: Center(
                                    child: Text("Balance"),
                                  ),
                                ),
                              ),
                              Text("₹0.00"),
                            ],
                          ),
                          const Divider(color: Colors.black, thickness: 1),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          200), // Moves "Balance" slightly to the right
                                  child: Center(
                                    child: Text(
                                      "Authorized Singnatorry",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableTile({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              icon,
              color: const Color(0xffE15D5D),
              size: 24,
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              onPressed: onTap,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content,
              ),
            ),
        ],
      ),
    );
  }
}
