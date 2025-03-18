import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

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
          await http.get(Uri.parse('http://192.168.1.43:5001/orders'));

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
            _courierDetails = List.generate(_orders.length,
                (_) => {"courierName": "", "trackingId": "", "link": ""});
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

  Future<void> updateOrder(String orderId, String courierName,
      String trackingId, String link) async {
    try {
      final url = 'http://192.168.1.43:5001/orders/$orderId';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trackingId': trackingId,
          'courierName': courierName,
          "link": link
        }),
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

  // Modified function using Dio
  Future<void> uploadImage(
      File imageFile, String orderId, BuildContext context) async {
    try {
      final dio = Dio();
      final uri = 'http://192.168.1.43:5001/orders/uploadImage/$orderId';

      // Create FormData to send the file
      FormData formData = FormData.fromMap({
        'image':
            await MultipartFile.fromFile(imageFile.path, filename: 'image.jpg'),
      });

      // You can add headers if needed
      dio.options.headers = {
        'Authorization': 'Bearer YOUR_TOKEN', // Replace with your token
        'Content-Type': 'multipart/form-data',
      };

      // Send the request
      Response response = await dio.put(uri, data: formData);

      // Handle response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')));
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error occurred during image upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error occurred during upload')));
    }
  }

  void _pickImageAndUpload(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (await imageFile.exists()) {
        String orderId = _orders[index]['_id'];
        await uploadImage(imageFile, orderId, context);
      }
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
                if (showCustomCourierField)
                  TextField(
                    decoration: const InputDecoration(labelText: "Enter url"),
                    onChanged: (value) {
                      _courierDetails[index]["link"] = value;
                    },
                  ),
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
                        ? _courierDetails[index]["link"]!
                        : selectedCourier;

                    String trackingId = _courierDetails[index]["trackingId"]!;
                    String link = _courierDetails[index]["link"]!;

                    updateOrder(orderId, courierToSend, trackingId, link);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE15D5D),
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
                    const SizedBox(height: 8),
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
                            onPressed: () => _pickImageAndUpload(index))
                      ],
                    ),
                    Row(
                      children: [
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
