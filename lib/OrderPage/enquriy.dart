import 'package:flutter/material.dart';

class Enquriy extends StatelessWidget {
  const Enquriy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          "Enquiry Page",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
