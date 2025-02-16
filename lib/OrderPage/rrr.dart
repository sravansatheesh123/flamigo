import 'package:flutter/material.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: const Color(0xffFFB6B6),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        'assets/images/Flamingo Logo.png',
                        width: 55,
                        height: 55,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person_2_outlined,
                            color: Colors.white),
                        onPressed: () {},
                      ),
                      const Text(
                        "Sagar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: const Icon(Icons.mic, color: Colors.grey),
                    hintText: "Search using name or contact",
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Receipt",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffDEC55A),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Flamingo Creativity",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text("Phone: 9342724119",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500)),
                        SizedBox(height: 2),
                        Text("Email: example@email.com",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500)),
                        SizedBox(height: 2),
                        Text("GST: GSTINXXXXXXXXXX",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500)),
                        SizedBox(height: 2),
                        Text("State: Kerala",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Image.asset(
                      'assets/images/IMG_8698.PNG',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.black, thickness: 1),
              const Center(
                child: Text(
                  "Tax Invoice",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Bill To:",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Sneha Verma",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Ship To:",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Address Here",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          "Invoice Details:",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text("Invoice Number: 3505",
                            style: TextStyle(fontSize: 10)),
                        SizedBox(height: 2),
                        Text("Date: 09/01/2025",
                            style: TextStyle(fontSize: 10)),
                        SizedBox(height: 2),
                        Text("Place : 09 - Uttar Pradesh",
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: Colors.grey.shade300,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Item Name"),
                    Text("HSN/SAC"),
                    Text("Quantity"),
                    Text("Price/Unit"),
                    Text("GST"),
                    Text("Amount"),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("1 Wallet Combo",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text("42023120"),
                  Text("1"),
                  Text("₹3,016"),
                  Text("₹542"),
                  Text("₹3,559"),
                ],
              ),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(""),
                  Text(""),
                  Text(""),
                  Text("1"),
                  Text(""),
                  Text("₹542"),
                  Text("₹3,559"),
                ],
              ),
              const Divider(color: Colors.black, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Invoice Amount in Words:"),
                  Text("Sub Total"),
                  Text("₹3,016.10"),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Three Thousand Five Hundred \n and Fifty-Nine Rupees"),
                  Text("IGST @18.0%"),
                  SizedBox(
                    width: 5,
                  ),
                  Text("₹542"),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Terms and Conditions"),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Total",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 125,
                        ),
                        Text("₹3,559",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Thank you  for doing\n bussines "),
                  Text("Recived"),
                  Text("₹3,559"),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 123), // Moves "Balance" slightly to the right
                      child: Center(
                        child: Text("Balance"),
                      ),
                    ),
                  ),
                  Text("₹0.00"),
                ],
              ),
              const Divider(color: Colors.black, thickness: 1),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 200), // Moves "Balance" slightly to the right
                      child: Center(
                        child: Text(
                          "Authorized Singnatorry",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
     
     
      ),
    );
  }
}