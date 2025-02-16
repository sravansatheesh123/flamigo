import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Enquiry extends StatefulWidget {
  const Enquiry({super.key});

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  Map<String, dynamic> firstOrder = {};
  bool isLoading = false;
  String receiverName = "";
  String errorMessage = "";
  TextEditingController searchController = TextEditingController();

  bool isExpandedOrderTracking = false;
  bool isExpandedDeliveryTime = false;
  bool isExpandedFlamingoOrder = false;

  List<String> allItems = [
    "How to track my order?",
    "Estimate time of delivery",
    "What else can I order from Flamingo Creativity?"
  ];

  Future<void> searchOrderByContact(String contact) async {
    setState(() {
      isLoading = true;
    });

    final url = 'http://192.168.1.7:5000/orders/contact?contact=$contact';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] && data['data'].isNotEmpty) {
          firstOrder = data['data'][0];

          setState(() {
            receiverName = firstOrder['receiverName'] ?? "Unknown";
            errorMessage = "";
          });
        } else {
          setState(() {
            errorMessage = 'No matching contact found.';
            receiverName = "";
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
        isLoading = false;
      });
    }
  }

  Widget _buildExpandableTile({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required Function onTap,
    required List<Widget> content,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        children: content,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (bool expanding) => onTap(),
      ),
    );
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
                  decoration: InputDecoration(
                    hintText: "Search by Contact....",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        String contact = searchController.text.trim();
                        if (contact.isNotEmpty) {
                          searchOrderByContact(contact);
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 14),
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
            children: [
              if (isLoading) const CircularProgressIndicator(),
              if (errorMessage.isNotEmpty)
                Center(
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              if (receiverName.isNotEmpty)
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
                              children: [
                                const Text(
                                  "Ship To:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  firstOrder['address'] ??
                                      "Address not available",
                                  style: const TextStyle(fontSize: 10),
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
                                  fontSize: 12, fontWeight: FontWeight.bold)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Total",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 125,
                                ),
                                Text("₹3,559",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                              padding: EdgeInsets.only(left: 123),
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
                              padding: EdgeInsets.only(left: 200),
                              child: Center(
                                child: Text(
                                  "Authorized Singnatorry",
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
              if (errorMessage.isEmpty && searchController.text.isEmpty)
                Column(
                  children: allItems.map((result) {
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
                      return Container();
                    }
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
