import 'package:flutter/material.dart';

class Enquiry extends StatefulWidget {
  const Enquiry({super.key});

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  bool isExpandedOrderTracking = false;
  bool isExpandedDeliveryTime = false;
  bool isExpandedFlamingoOrder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffFFEEEE),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // "How to track my order?" expandable box
            _buildExpandableTile(
              icon: Icons.location_on_outlined,
              title: "How to track my order?",
              isExpanded: isExpandedOrderTracking,
              onTap: () {
                setState(() {
                  isExpandedOrderTracking = !isExpandedOrderTracking;
                });
              },
              content: const [
                Text(
                  "Follow these steps to track your order:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    "• Enter your contact number in the track via contact input field."),
                Text("• Click on the search icon 🔍."),
                Text(
                    "• After a few days of dispatching the order, it will be updated with a courier website link and tracking ID."),
                Text(
                    "• When you see courier details, go to the link and enter your tracking ID."),
                Text("• You will be able to see the status of your parcel."),
              ],
            ),
            const SizedBox(height: 10),

            // "Estimate time of delivery" expandable box
            _buildExpandableTile(
              icon: Icons.message_outlined,
              title: "Estimate time of delivery",
              isExpanded: isExpandedDeliveryTime,
              onTap: () {
                setState(() {
                  isExpandedDeliveryTime = !isExpandedDeliveryTime;
                });
              },
              content: const [
                Text(
                  "The estimated date of delivery is usually 10 days.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                    "• However, it will be delivered sooner if you have discussed it with our customer support."),
                Text(
                    "• If your delivery location is near our factory, it may arrive earlier."),
              ],
            ),
            const SizedBox(height: 10),

            // "What else can I order from Flamingo Creativity?" expandable box
            _buildExpandableTile(
              icon: Icons.shopping_bag_outlined,
              title: "What else can I order from Flamingo Creativity?",
              isExpanded: isExpandedFlamingoOrder,
              onTap: () {
                setState(() {
                  isExpandedFlamingoOrder = !isExpandedFlamingoOrder;
                });
              },
              content: const [
                Text(
                  "We are glad to provide you with best quality products and packaging.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                    "• If you want to order something different other than website hampers, contact us over WhatsApp for the same."),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableTile({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              icon,
              color: Color(0xffE15D5D),
              size: 24,
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              onPressed: onTap,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content,
              ),
            ),
        ],
      ),
    );
  }
}
