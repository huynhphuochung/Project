import 'dart:convert';
import 'package:http/http.dart' as http;
import '../cart_item.dart';
import 'base_url.dart';

Future<List<CartItem>> fetchCartItems(int idUser) async {
  print('📦 Đang lấy giỏ hàng cho ID: $idUser');
  final response = await http.get(Uri.parse('${baseUrl}cart/get_cart_api.php?id_user=$idUser'));
print('📦 Status code: ${response.statusCode}');
  print('📦 Body: ${response.body}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data.map<CartItem>((item) => CartItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load cart items');
  }
}
