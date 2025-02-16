import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Unshipped extends StatefulWidget {
  @override
  _UnshippedState createState() => _UnshippedState();
}

class _UnshippedState extends State<Unshipped> {
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:5000/orders/shippingStatus?status=false'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Access the 'data' key from the response
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
            return OrderCard(
              orderId: order['orderId'] ?? 'No Order ID',
              customerName: order['receiverName'] ?? 'No Name',
              address: order['address'] ?? 'No Address',
              status: order['shippedUnshippedStatus'] ? 'Shipped' : 'Unshipped',
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

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.status,
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
            // Order ID Box
            Container(
              width: 70,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Order Details
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
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffE15D5D),
                          decoration: TextDecoration.underline,
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
