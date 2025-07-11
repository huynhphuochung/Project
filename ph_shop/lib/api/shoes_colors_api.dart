import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shoes.dart'; // nơi chứa model ShoeColor
import 'base_url.dart';

Future<List<ShoeColor>> fetchShoeColors(String shoeId) async {
  final response = await http.get(Uri.parse('$baseUrl/shoes/get_colors.php?id_shoe=$shoeId'));

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((json) => ShoeColor.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load colors');
  }
}
