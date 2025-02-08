import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Allorder extends StatelessWidget {
  const Allorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 2, // Example: Displaying 2 orders
          itemBuilder: (context, index) {
            bool isUnshipped =
                index == 0; // First card is unshipped, second is shipped
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                        color: Colors.grey[400], // Dark grey for contrast
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isUnshipped
                            ? "#123456"
                            : "#654321", // Different order IDs
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                            isUnshipped ? "Sagar Suman" : "Rahul Sharma",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            isUnshipped
                                ? "123, Street Name, City, PIN - 560001"
                                : "456, Another Street, City, PIN - 110011",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showUnshippedPopup(context);
                                },
                                child: Text(
                                  isUnshipped ? "Unshipped" : "Shipped",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isUnshipped ? Colors.red : Colors.green,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(
                                "No Query",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
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
          },
        ),
      ),
    );
  }

  void _showUnshippedPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox(); // Required placeholder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1), // Start from the top
            end: Offset.zero, // Move to its normal position
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: Align(
            alignment: Alignment.topCenter,
            child: _buildPopupBox(context),
          ),
        );
      },
    );
  }

  Widget _buildPopupBox(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        height:
            MediaQuery.of(context).size.height * 0.4, // 40% of screen height
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for "Courier" text and Camera Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Courier",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.black54),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null) {
                        print("Captured Image Path: ${image.path}");
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter courier name",
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tracking ID",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter tracking ID",
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 248, 185, 209),
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
      ),
    );
  }
}
