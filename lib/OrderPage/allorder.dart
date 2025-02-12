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
  List<bool> isExpanded = [];
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _orders = [];

  List<Map<String, String>> _courierDetails = [];

  Future<void> _openCamera() async {
    await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to fetch data from the server
  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.3:5000/orders'));

      if (response.statusCode == 200) {
        // Parse the JSON response if successful
        var data = json.decode(response.body);
        setState(() {
          _orders = List<Map<String, dynamic>>.from(data);
          isExpanded =
              List<bool>.filled(_orders.length, false); // initialize isExpanded
          _courierDetails = List.generate(
              _orders.length, (_) => {"courierName": "", "trackingId": ""});
        });
        print('Response data: $_orders');
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Function to handle the PUT request for updating the order
  Future<void> updateOrder(int index) async {
    try {
      final order = _orders[index];
      final courierName = _courierDetails[index]["courierName"];
      final trackingId = _courierDetails[index]["trackingId"];

      final url = Uri.parse('http://192.168.1.3:5000/orders/${order['_id']}');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "courierName": courierName,
          "trackingId": trackingId,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated the order
        print('Order updated successfully');
        // Optionally, you can reload the data after the update, or handle the UI accordingly
        fetchData(); // Re-fetch data to reflect the updated order
      } else {
        print('Failed to update the order');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
      body: Container(
        color: const Color(0xffFFEEEE),
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: _orders.length, // Use the length of _orders
          itemBuilder: (context, index) {
            var order = _orders[index];

            return Card(
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
                          width: 70,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Text(
                            order['orderId'] ?? 'No Order ID',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      order['name'] ?? 'No Name',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        size: 20, color: Colors.black54),
                                    onPressed: _openCamera,
                                  ),
                                ],
                              ),
                              Text(
                                order['address'] ?? 'No Address',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Roboto",
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isExpanded[index] = !isExpanded[index];
                                      });
                                    },
                                    child: Text(
                                      order['unshipped'] == true
                                          ? "Unshipped"
                                          : "Shipped",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: order['unshipped'] == true
                                            ? Color(0xffCA4040)
                                            : Color(0xff007580),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Text(
                                    "No Query",
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff007580),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isExpanded[index]) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Courier",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          IconButton(
                            icon: const Icon(Icons.camera_alt,
                                size: 20, color: Colors.black54),
                            onPressed: _openCamera,
                          ),
                        ],
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _courierDetails[index]["courierName"] = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter courier name",
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Tracking ID",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _courierDetails[index]["trackingId"] = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter tracking ID",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            updateOrder(index); // Update order on Submit
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffE15D5D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                          ),
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
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
