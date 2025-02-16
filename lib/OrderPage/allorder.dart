import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Allorder extends StatefulWidget {
  const Allorder({super.key});

  @override
  State<Allorder> createState() => _AllorderState();
}

class _AllorderState extends State<Allorder> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, String>> _courierDetails = [];
  List<String> shipmentStatus = [];
  final List<String> statusOptions = ["Unshipped", "Shipped"];

  Future<void> _openCamera() async {
    await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.7:5000/orders'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['orders'] != null) {
          setState(() {
            _orders = List<Map<String, dynamic>>.from(data['orders']);

            shipmentStatus = _orders
                .map((order) => order['shippedUnshippedStatus'] == true
                    ? "Shipped"
                    : "Unshipped")
                .toList();

            _courierDetails = List.generate(
                _orders.length, (_) => {"courierName": "", "trackingId": ""});
          });
          print('Response data: $_orders');
        } else {
          print('Orders not found in response.');
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> updateOrder(
      String orderId, String courierName, String trackingId) async {
    try {
      // Use the _id directly in the URL
      final url =
          'http://localhost:5000/orders/$orderId'; // Dynamic orderId (_id)
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trackingId': trackingId,
          'courierName': courierName,
        }),
      );

      if (response.statusCode == 200) {
        fetchData(); // Reload the data after updating
        print('Order updated successfully');
      } else {
        print('Failed to update order');
      }
    } catch (e) {
      print('Error occurred during update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffFFEEEE),
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            var order = _orders[index];
            return GestureDetector(
              onTap: () {
                // Pass the _id to the updateOrder function when the card is tapped
                updateOrder(
                    order['_id'],
                    _courierDetails[index]["courierName"]!,
                    _courierDetails[index]["trackingId"]!);
              },
              child: Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Text(
                              order['orderId'] ?? 'No Order ID',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order['receiverName'] ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  order['address'] ?? 'No Address',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt,
                                size: 20, color: Colors.black54),
                            onPressed: _openCamera,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 85),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: PopupMenuButton(
                                  onSelected: (String? newValue) {
                                    setState(() {
                                      shipmentStatus[index] = newValue!;
                                    });
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: "Shipped",
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: _courierDetails[
                                                                    index]
                                                                ["courierName"]!
                                                            .isNotEmpty
                                                        ? _courierDetails[index]
                                                            ["courierName"]
                                                        : null,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: "Courier Name",
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 10),
                                                    ),
                                                    items: [
                                                      "DHL",
                                                      "FedEx",
                                                      "UPS",
                                                      "Blue Dart",
                                                      "Delhivery",
                                                      "Other"
                                                    ].map((String courier) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: courier,
                                                        child: Text(courier),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _courierDetails[index][
                                                                "courierName"] =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.camera_alt,
                                                      size: 20,
                                                      color: Colors.black54),
                                                  onPressed: _openCamera,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              onChanged: (value) {
                                                _courierDetails[index]
                                                    ["trackingId"] = value;
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "Tracking ID",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  String courierName =
                                                      _courierDetails[index]
                                                          ["courierName"]!;
                                                  String trackingId =
                                                      _courierDetails[index]
                                                          ["trackingId"]!;
                                                  updateOrder(order['_id'],
                                                      courierName, trackingId);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xffE15D5D),
                                                ),
                                                child: const Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: Text(
                                    shipmentStatus[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          shipmentStatus[index] == "Unshipped"
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text("No Enquiry"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
