import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';

Future<bool> deleteCartItem(int idCart) async {
  final url = Uri.parse('$baseUrl/cart/delete_cart_item.php');
  final response = await http.post(url, body: {
    'id': idCart.toString(), // 👈 key phải là 'id' để khớp với PHP
  });

  print('🧾 Response: ${response.body}'); // 👈 để debug

  if (response.statusCode == 200) {
    try {
      final jsonData = json.decode(response.body);
      return jsonData['status'] == 'success';
    } catch (e) {
      print('❌ JSON decode error: $e');
    }
  }

  return false;
}

