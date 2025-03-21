import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class Unshipped extends StatefulWidget {
  @override
  _UnshippedState createState() => _UnshippedState();
}

class _UnshippedState extends State<Unshipped> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.56:5001/orders/shippingStatus?status=false'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['data'] != null) {
          setState(() {
            _orders = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          print('No unshipped orders found.');
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _pickImageAndUpload(int index) {
    _showImagePickerDialog(index);
  }

  void _showImagePickerDialog(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  _uploadPickedImage(pickedFile, index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  _uploadPickedImage(pickedFile, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _uploadPickedImage(XFile? pickedFile, int index) async {
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (await imageFile.exists()) {
        String orderId = _orders[index]['_id'];
        await uploadImage(imageFile, orderId);
      }
    }
  }

  Future<void> uploadImage(File imageFile, String orderId) async {
    try {
      final dio = Dio();
      final uri = 'http://192.168.1.56:5001/orders/uploadImage/$orderId';

      FormData formData = FormData.fromMap({
        'image':
            await MultipartFile.fromFile(imageFile.path, filename: 'image.jpg'),
      });

      dio.options.headers = {
        'Authorization': 'Bearer YOUR_TOKEN',
        'Content-Type': 'multipart/form-data',
      };

      Response response = await dio.put(uri, data: formData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')));
        fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')));
      }
    } catch (e) {
      print('Error occurred during image upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error occurred during upload')));
    }
  }

  Future<void> updateOrder(
      String putId, String courierName, String trackingId, String link) async {
    try {
      final url = 'http://192.168.1.56:5001/orders/$putId';
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
        print('Order updated successfully');
      } else {
        print('Failed to update order');
      }
    } catch (e) {
      print('Error occurred during update: $e');
    }
  }

  void _showShipmentDialog(String putId) {
    String selectedCourier = "";
    String trackingId = "";
    String link = "";
    bool showCustomCourierField = false;

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
                      showCustomCourierField = value == "Other";
                    });
                  },
                ),
                if (showCustomCourierField)
                  TextField(
                    decoration: const InputDecoration(labelText: "Enter URL"),
                    onChanged: (value) {
                      link = value;
                    },
                  ),
                TextField(
                  decoration: const InputDecoration(labelText: "Tracking ID"),
                  onChanged: (value) {
                    trackingId = value;
                  },
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String courierToSend =
                        selectedCourier == "Other" ? link : selectedCourier;

                    updateOrder(putId, courierToSend, trackingId, link);
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
        child: _orders.isEmpty
            ? const Center(
                child: Text(
                  'No orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  var order = _orders[index];
                  return OrderCard(
                    putId: order['_id'] ?? 'No Order ID',
                    orderId: order['orderId'] ?? 'No Order ID',
                    customerName: order['receiverName'] ?? 'No Name',
                    address: order['address'] ?? 'No Address',
                    status: order['shippedUnshippedStatus']
                        ? 'Shipped'
                        : 'Unshipped',
                    onStatusClick: () {
                      _showShipmentDialog(order['_id']);
                    },
                    onCameraClick: () {
                      _pickImageAndUpload(index);
                    },
                  );
                },
              ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String address;
  final String status;
  final String putId;
  final VoidCallback onStatusClick;
  final VoidCallback onCameraClick;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.status,
    required this.putId,
    required this.onStatusClick,
    required this.onCameraClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                orderId,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: onStatusClick,
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffE15D5D),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Text(
                        "No Query",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff007580),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.black54),
              onPressed: onCameraClick,
            ),
          ],
        ),
      ),
    );
  }
}
