import 'package:flutter/material.dart';
import 'package:new_projectes/HomePage/bottamnaviagtion.dart';
import 'package:new_projectes/OrderPage/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();
  final List<TextEditingController> _textControllers =
      List.generate(7, (index) => TextEditingController());
  final TextEditingController _nameController = TextEditingController();
  bool _isTextEntered = false;
  bool _showOrderPopup = false;
  bool _isGSTSelected = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTextEntered = _controller.text.isNotEmpty;
      });
    });
  }

  void _showOrderDetailsPopup() {
    String enteredText = _controller.text;
    List<String> lines = enteredText.split("\n");

    setState(() {
      _textControllers[0].text = _extractOrderId(lines);
      _textControllers[1].text = _extractItemDetails(lines);

      _textControllers[2].text = _extractDetail(lines, "Receiver’s name");
      _textControllers[3].text = _extractAddress(lines);
      _textControllers[4].text = _extractDetail(lines, "Contact");
      _textControllers[5].text = _extractDetail(lines, "Color");
      _textControllers[6].text = _extractDetail(lines, "Amount");
      _nameController.text = _extractDetail(lines, "");

      _showOrderPopup = true;
    });
  }

  String _extractOrderId(List<String> lines) {
    RegExp orderIdPattern = RegExp(r"\d{2}-\d{2}-\d{2}-F\d+");

    for (String line in lines) {
      Match? match = orderIdPattern.firstMatch(line);
      if (match != null) {
        return match.group(0) ?? "";
      }
    }
    return "";
  }

// Extract full item details (including numbered list)
  String _extractItemDetails(List<String> lines) {
    StringBuffer items = StringBuffer();
    bool startAdding = false;

    for (String line in lines) {
      if (line.contains("(Item details)")) {
        startAdding = true;
        continue; // Skip the (Item details) line
      }
      if (startAdding) {
        if (line.contains("Receiver’s name"))
          break; // Stop at receiver's details
        items.writeln(line.trim());
      }
    }
    return items.toString().trim();
  }

// Extract address (multi-line)
  String _extractAddress(List<String> lines) {
    StringBuffer address = StringBuffer();
    bool startAdding = false;

    for (String line in lines) {
      if (line.contains("Address")) {
        startAdding = true;
        continue;
      }
      if (startAdding) {
        if (line.contains("State") || line.contains("Pincode"))
          break; // Stop at state/pincode
        address.writeln(line.trim());
      }
    }
    return address.toString().trim();
  }

  String _extractDetail(List<String> lines, String fieldName) {
    for (String line in lines) {
      if (line.startsWith(fieldName)) {
        return line.substring(fieldName.length + 1).trim();
      }
    }
    return "";
  }

  void _toggleGSTSelection() {
    setState(() {
      _isGSTSelected = !_isGSTSelected;
    });
  }

  String trackingId = DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _submitOrder() async {
    // Get data from text fields
    String orderId = _textControllers[0].text;
    String orderDetails = _textControllers[1].text;
    String receiverName = _textControllers[2].text;
    String address = _textControllers[3].text;
    String contact = _textControllers[4].text;
    String color = _textControllers[5].text;
    String amount = _textControllers[6].text;

    String trackingId = DateTime.now().millisecondsSinceEpoch.toString();

    // API data to send
    Map<String, String> orderData = {
      'orderId': orderId,
      'orderDetails': orderDetails,
      'receiverName': receiverName,
      'address': address,
      'contact': contact,
      'color': color,
      'amount': amount,
      'trackingId': trackingId,
      'gst': 'false',
    };

    // API URL
    final Uri apiUrl = Uri.parse('http://192.168.1.7:5000/orders');

    try {
      // Creating a multipart request
      var request = http.MultipartRequest('POST', apiUrl)
        ..fields.addAll(orderData);

      // Send the request
      final response = await request.send();

      // Get the response
      final responseBody = await http.Response.fromStream(response);

      print('Response status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order submitted successfully!')),
        );

        for (var controller in _textControllers) {
          controller.clear();
        }

        _nameController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Bottamnaviagtion(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit order')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffFFEEEE),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xffFFB6B6),
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Stack(
                                    children: [
                                      if (!_isTextEntered)
                                        const Text(
                                          "Enter order details here...............",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      TextField(
                                        controller: _controller,
                                        maxLines: null,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                right: 16,
                                child: ElevatedButton(
                                  onPressed: _showOrderDetailsPopup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffE15D5D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Submit",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_showOrderPopup) _buildOrderPopup(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderPopup() {
    return Center(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField("Order ID", _textControllers[0]),
            _buildTextField("Order Details", _textControllers[1]),
            _buildTextField("Received Name", _textControllers[2]),
            _buildTextField("Address", _textControllers[3]),
            _buildTextField("Contact", _textControllers[4]),
            _buildTextField("Color", _textControllers[5]),
            _buildTextField("Amount", _textControllers[6]),

            // Move GST checkbox below all text fields
            _buildGSTCheckbox(),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _submitOrder,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Confirm",
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showOrderPopup = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE15D5D)),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGSTCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleGSTSelection,
            child: Icon(
              _isGSTSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: _isGSTSelected ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          const Text("Inclusive of GST"),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
