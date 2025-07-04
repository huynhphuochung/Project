import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shoes.dart';
import 'base_url.dart';

Future<List<ShoeSize>> fetchShoeSizes(String shoeId) async {
  final response = await http.get(Uri.parse('$baseUrl/shoes/get_sizes.php?shoe_id=$shoeId'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData['success']) {
      List data = jsonData['data'];
      return data.map((item) => ShoeSize.fromJson(item)).toList();
    } else {
      throw Exception('Không có dữ liệu size');
    }
  } else {
    throw Exception('Lỗi kết nối server');
  }
}
