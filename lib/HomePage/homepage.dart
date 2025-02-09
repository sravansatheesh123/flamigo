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
    setState(() {
      _showOrderPopup = true;
    });
  }

  void _toggleGSTSelection() {
    setState(() {
      _isGSTSelected = !_isGSTSelected;
    });
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

            // Move GST checkbox below all text fields
            _buildGSTCheckbox(),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showOrderPopup = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Order()),
                    );
                  },
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
