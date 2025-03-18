import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Enquiry extends StatefulWidget {
  const Enquiry({super.key});

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  Map<String, dynamic> firstOrder = {};
  bool isLoading = false;
  String receiverName = "";
  String amount = "";
  String errorMessage = "";
  TextEditingController searchController = TextEditingController();

  bool isExpandedOrderTracking = false;
  bool isExpandedDeliveryTime = false;
  bool isExpandedFlamingoOrder = false;

  List<String> allItems = [
    "How to track my order?",
    "Estimate time of delivery",
    "I order from Flamingo Creativity?"
  ];

  Future<void> searchOrderByContact(String contact) async {
    setState(() {
      isLoading = true;
    });

    final url = 'http://192.168.1.43:5001/orders/contact?contact=$contact';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] && data['data'].isNotEmpty) {
          firstOrder = data['data'][0];

          setState(() {
            receiverName = firstOrder['receiverName'] ?? "Unknown";
            amount = firstOrder['amount']?.toString() ?? "0";

            errorMessage = "";
          });
          print("pritn response $amount");
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

  String convertNumberToWords(double number) {
    List<String> ones = [
      "Zero",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine"
    ];
    List<String> tens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety"
    ];
    List<String> teens = [
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen"
    ];
    List<String> aboveHundred = ["", "Hundred", "Thousand", "Lakh", "Crore"];

    if (number == 0) {
      return "Zero Rupees";
    }

    int intPart = number.toInt();
    int decimalPart = ((number - intPart) * 100).toInt();

    String result = "";
    int place = 0;

    while (intPart > 0) {
      if (intPart % 100 < 10) {
        if (intPart % 10 > 0) {
          result =
              ones[intPart % 10] + " " + aboveHundred[place] + " " + result;
        }
      } else if (intPart % 100 < 20) {
        result = teens[intPart % 100 - 10] +
            " " +
            aboveHundred[place] +
            " " +
            result;
      } else {
        result = tens[intPart % 100 ~/ 10] +
            " " +
            ones[intPart % 10] +
            " " +
            aboveHundred[place] +
            " " +
            result;
      }
      intPart = intPart ~/ 100;
      place++;
    }

    String decimalWords = "";
    if (decimalPart > 0) {
      decimalWords =
          " and " + convertNumberToWords(decimalPart.toDouble()) + " Cents";
    }

    return result.trim() + " Rupees" + decimalWords;
  }

  String formattedAmount(double amount) {
    return NumberFormat.currency(symbol: '₹').format(amount);
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
    double parsedAmount = double.tryParse(amount) ?? 0;

    double gst = (parsedAmount * 18) / 118;

    double totalAmount = parsedAmount + gst;

    String amountInWords = convertNumberToWords(totalAmount);

    String formattedAmountString = formattedAmount(parsedAmount);
    String formattedGst = formattedAmount(gst);
    String formattedTotal = formattedAmount(totalAmount);

    String formattedSubTotal = formattedAmount(parsedAmount);

    print('Original Amount: ₹$formattedAmountString');
    print('GST: ₹$formattedGst');
    print('Total Amount: ₹$formattedTotal');
    print('SubTotal: ₹$formattedSubTotal');
    print('Total Amount in Words: $amountInWords');

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
        width: double.infinity,
        height: double.infinity,
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
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Bill To:",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        firstOrder['receiverName'] ?? "Unknown",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Invoice Details:",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      const Text(
                                        "Invoice Number: 3505",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "Date: ${firstOrder['createdAt'] != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(firstOrder['createdAt'])) : 'Unknown'}",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(height: 2),
                                      const Text(
                                        "Place : 09 - Uttar Pradesh",
                                        style: TextStyle(fontSize: 10),
                                      ),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("Item Name"),
                                  Text("HSN/SAC"),
                                  Text("Quantity"),
                                  // Text("Price/Unit"),
                                  Text("GST"),
                                  Text("Amount"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("1 Wallet Combo",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                Text("",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(formattedAmount(parsedAmount),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(color: Colors.black, thickness: 1),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedGst,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedAmount(parsedAmount),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.black, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Invoice Amount in Words:"),
                                Text("Sub Total"),
                                Text(
                                  formattedSubTotal,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  amountInWords
                                      .split(' ')
                                      .asMap()
                                      .entries
                                      .map((entry) =>
                                          entry.key % 3 == 0 && entry.key != 0
                                              ? '\n${entry.value}'
                                              : entry.value)
                                      .join(' '),
                                ),
                                Text("IGST @18.0%"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(formattedGst),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Terms and Conditions"),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Text(formattedTotal,
                                          style: const TextStyle(
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
                              children: [
                                const Text("Thank you  for doing\n bussines "),
                                const Text("Recived"),
                                Text(formattedAmountString),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Row(
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 200),
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
                    ),
                    firstOrder['image'] != null &&
                            firstOrder['image'].isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 20),
                            color: Colors.white,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              "http://192.168.1.43:5001/api/${firstOrder['image'][0]}",
                              height: 180.0,
                              width: 200.0,
                            ),
                          )
                        : const SizedBox.shrink(),
                    firstOrder['trackingId'] != null &&
                            firstOrder['trackingId'].isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1.0,
                                  blurRadius: 5.0,
                                  offset: const Offset(0, 3.0),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Courier Details: ${firstOrder['courierName'] ?? "Unknown"}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "AWB : ${firstOrder['trackingId'] ?? "Unknown"}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              if (errorMessage.isEmpty && searchController.text.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        content: [
                          const SizedBox(height: 5),
                          _buildBulletPoint(
                              "Enter your contact number in the track via contact input field."),
                          _buildBulletPoint("Click on the search icon 🔍."),
                          _buildBulletPoint(
                              "After a few days of dispatching the order, it will be updated with a courier website link and tracking ID."),
                          _buildBulletPoint(
                              "When you see courier details, go to the link and enter your tracking ID."),
                          _buildBulletPoint(
                              "You will be able to see the status of your parcel."),
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
                        content: [
                          const SizedBox(height: 5),
                          _buildBulletPoint(
                              "However, it will be delivered sooner if you have discussed it with our customer support."),
                          _buildBulletPoint(
                              "If your delivery location is near our factory, it may arrive earlier."),
                        ],
                      );
                    } else if (result == "I order from Flamingo Creativity?") {
                      return _buildExpandableTile(
                        icon: Icons.shopping_bag_outlined,
                        title: result,
                        isExpanded: isExpandedFlamingoOrder,
                        onTap: () {
                          setState(() {
                            isExpandedFlamingoOrder = !isExpandedFlamingoOrder;
                          });
                        },
                        content: [
                          const Text(
                              "We are glad to provide you with the best quality products and packaging."),
                          const SizedBox(height: 5),
                          _buildBulletPoint(
                              "If you want to order something different other than website hampers, contact us over WhatsApp for the same."),
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
