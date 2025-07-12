import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/base_url.dart';

Future<String?> fetchAvatarUrl(String uid) async {
  final response = await http.get(
    Uri.parse('$baseUrl/user/get_user_profile.php?uid=$uid'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      return '$baseUrl/${data['avatar_url']}';
    } else {
      print('❌ Server trả về: ${data['message']}');
    }
  } else {
    print('❌ HTTP lỗi: ${response.statusCode}');
  }
  return null;
}
