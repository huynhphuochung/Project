import 'package:http/http.dart' as http;
import 'base_url.dart';

Future<bool> updateCartQuantity(int cartId, int quantity) async {
  final url = Uri.parse('$baseUrl/cart/update_cart_quantity_api.php');
  final response = await http.post(
    url,
    body: {'id': cartId.toString(), 'quantity': quantity.toString()},
  );
print('🛠️ API response: ${response.body}');
  if (response.statusCode == 200) {
    return response.body.contains('success');
  }
  return false;
}
