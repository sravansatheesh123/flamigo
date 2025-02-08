import 'package:flutter/material.dart';
import 'package:new_projectes/OrderPage/order.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isTextEntered = false;
  bool _showPopup = false;
  bool _showReminder = false;
  bool _isGSTSelected = true; // Default: GST ON (Green)

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTextEntered = _controller.text.isNotEmpty;
      });
    });
  }

  void _showAmountPopup() {
    setState(() {
      _showPopup = true;
      _showReminder = true;
    });

    // Hide the reminder after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _showReminder = false;
      });
    });
  }

  void _submitAmount() {
    setState(() {
      _showPopup = false; // Close the popup
    });

    // Navigate to OrderPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Order()),
    );
  }

  void _toggleGSTSelection() {
    setState(() {
      _isGSTSelected = !_isGSTSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 250, 249, 249),
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
                            color: const Color.fromARGB(255, 249, 208, 222),
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
                                  "Type here...",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              TextField(
                                controller: _controller,
                                maxLines: null,
                                textAlignVertical: TextAlignVertical.top,
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
                          onPressed: _showAmountPopup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 248, 185, 209),
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

          // Slide-down Popup
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _showPopup ? 100 : -200,
            left: 20,
            right: 20,
            child: _showPopup ? _buildPopupBox() : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupBox() {
    return Container(
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
              const Text(
                "Enter the amount for customer",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: _toggleGSTSelection,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _isGSTSelected ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    "GST",
                    style: TextStyle(
                      color: Colors.white, // Text color stays white
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Amount Text Field
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter amount",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black12),
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitAmount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 248, 185, 209),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
