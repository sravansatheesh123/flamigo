import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class OrderService {
  static const String apiUrl = "http://192.168.29.10:5100/orders";

  static Future<void> createOrder(
    String orderId,
    String address,
    String orderDetails,
    String receiverName,
    String contact,
    String color,
    bool gst,
  ) async {
    try {
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      // Add required fields (text data)
      request.fields['orderId'] = orderId;
      request.fields['address'] = address;
      request.fields['orderDetails'] = orderDetails;
      request.fields['receiverName'] = receiverName;
      request.fields['contact'] = contact;
      request.fields['color'] = color;
      request.fields['gst'] = gst.toString();

      // Send the request
      var response = await request.send();

      if (response.statusCode == 201) {
        print("Order created successfully!");
        final responseData = await response.stream.bytesToString();
        print(responseData);
      } else {
        print("Failed to create order: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
