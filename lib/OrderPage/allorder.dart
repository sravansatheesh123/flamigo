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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5000/orders'));

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
                _orders.length,
                (_) => {
                      "courierName": "",
                      "trackingId": "",
                      "customCourier": "" // For "Other" option
                    });
          });
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
      final url = 'http://localhost:5000/orders/$orderId';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body:
            json.encode({'trackingId': trackingId, 'courierName': courierName}),
      );

      if (response.statusCode == 200) {
        fetchData();
        print('Order updated successfully $response');
      } else {
        print('Failed to update order');
      }
    } catch (e) {
      print('Error occurred during update: $e');
    }
  }

  void _showShipmentDialog(int index, String orderId) {
    String selectedCourier = _courierDetails[index]["courierName"] ?? "";
    String trackingId = _courierDetails[index]["trackingId"] ?? "";
    bool showCustomCourierField = selectedCourier == "Other";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Update Shipment"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Courier Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCourier.isNotEmpty ? selectedCourier : null,
                  decoration: const InputDecoration(labelText: "Courier Name"),
                  items: [
                    "DHL",
                    "FedEx",
                    "UPS",
                    "Blue Dart",
                    "Delhivery",
                    "Other"
                  ].map((String courier) {
                    return DropdownMenuItem<String>(
                      value: courier,
                      child: Text(courier),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCourier = value!;
                      _courierDetails[index]["courierName"] = value;
                      showCustomCourierField = value == "Other";
                    });
                  },
                ),

                // Show custom text field if "Other" is selected
                if (showCustomCourierField)
                  TextField(
                    decoration: const InputDecoration(labelText: "Enter url"),
                    onChanged: (value) {
                      _courierDetails[index]["customCourier"] = value;
                    },
                  ),

                // Tracking ID Field
                TextField(
                  decoration: const InputDecoration(labelText: "Tracking ID"),
                  onChanged: (value) {
                    _courierDetails[index]["trackingId"] = value;
                  },
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String courierToSend = selectedCourier == "Other"
                        ? _courierDetails[index]["customCourier"]!
                        : selectedCourier;

                    updateOrder(orderId, courierToSend, trackingId);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE15D5D), // Button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
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
            return Card(
              color: Colors.white,
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tracking ID at the top

                    const SizedBox(height: 8), // Spacing

                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: Text(
                            order['orderId'] ?? 'No Order ID',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
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
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order['address'] ?? 'No Address',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.black54),
                          onPressed: () async {
                            await _picker.pickImage(source: ImageSource.camera);
                          },
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        // Moves "Shipped/Unshipped" slightly to the left
                        Padding(
                          padding: const EdgeInsets.only(left: 80),
                          child: TextButton(
                            onPressed: () =>
                                _showShipmentDialog(index, order['_id']),
                            child: Text(
                              shipmentStatus[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: shipmentStatus[index] == "Unshipped"
                                    ? Colors.red
                                    : const Color(0xff007580),
                              ),
                            ),
                          ),
                        ),

                        // Adds a small space before "No Enquiry"
                        const SizedBox(width: 10),

                        const Text("No Enquiry"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
