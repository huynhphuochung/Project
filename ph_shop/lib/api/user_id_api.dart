import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';

Future<int?> getUserIdFromUid(String uid) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}user/get_user_id.php'),
      body: {'uid': uid},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return int.parse(data['id'].toString());
      }
    }
  } catch (e) {
    print('Lỗi lấy id người dùng: $e');
  }
  return null;
}
