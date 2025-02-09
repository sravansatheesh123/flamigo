import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Allorder extends StatefulWidget {
  const Allorder({super.key});

  @override
  State<Allorder> createState() => _AllorderState();
}

class _AllorderState extends State<Allorder> {
  List<bool> isExpanded = [false, false];
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffFFEEEE),
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            bool isUnshipped = index == 0;
            return Card(
              color: Colors.white,
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isUnshipped ? "#123456" : "#654321",
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
                                      isUnshipped
                                          ? "Sagar Suman"
                                          : "Rahul Sharma",
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
                                isUnshipped
                                    ? "123, Street Name, City, PIN - 560001"
                                    : "456, Another Street, City, PIN - 110011",
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
                                      isUnshipped ? "Unshipped" : "Shipped",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isUnshipped
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
                      const SizedBox(
                        width: double.infinity,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter courier name",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Tracking ID",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(
                        width: double.infinity,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter tracking ID",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
