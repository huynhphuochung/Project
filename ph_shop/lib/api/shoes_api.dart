import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shoes.dart';
import 'base_url.dart'; // <-- thêm dòng này

Future<List<Shoes>> fetchShoes() async {
  final response = await http.get(Uri.parse('${baseUrl}shoes/get_shoes.php'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData['success']) {
      List<dynamic> data = jsonData['data'];
      return data.map((item) => Shoes.fromJson(item)).toList();
    } else {
      throw Exception("Không có dữ liệu giày");
    }
  } else {
    throw Exception("Lỗi kết nối đến server");
  }
}
Future<List<Shoes>> searchShoes(String keyword) async {
  final response = await http.get(Uri.parse('$baseUrl/shoes/search_shoes.php?keyword=$keyword'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data.map<Shoes>((json) => Shoes.fromJson(json)).toList();
  } else {
    throw Exception('Failed to search shoes');
  }
}

