import 'package:flutter/material.dart';
import 'package:new_projectes/OrderPage/order.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();
  final List<TextEditingController> _textControllers =
      List.generate(6, (index) => TextEditingController());
  final TextEditingController _amountController = TextEditingController();
  bool _isTextEntered = false;
  bool _showOrderPopup = false;
  bool _showAmountPopup = false;
  bool _isGSTSelected = true;

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
    setState(() {
      _showOrderPopup = true;
    });
  }

  void _showAmountDetailsPopup() {
    setState(() {
      _showOrderPopup = false;
      _showAmountPopup = true;
    });
  }

  void _toggleGSTSelection() {
    setState(() {
      _isGSTSelected = !_isGSTSelected;
    });
  }

  void _submitAmount() {
    setState(() {
      _showAmountPopup = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Order()),
    );
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
                  if (_showAmountPopup) _buildAmountPopup(),
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
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _showAmountDetailsPopup,
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

  Widget _buildAmountPopup() {
    return Center(
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Enter the amount for customer",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: _toggleGSTSelection,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isGSTSelected ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("GST",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _submitAmount,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xffE15D5D)),
              child:
                  const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
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
