import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';

Future<String?> uploadAvatar(File file, String uid) async {
  final uri = Uri.parse('$baseUrl/user/upload_avatar.php');
  final request = http.MultipartRequest('POST', uri);
  request.fields['uid'] = uid;
  request.files.add(await http.MultipartFile.fromPath('avatar', file.path));

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final jsonData = json.decode(responseBody);
    if (jsonData['status'] == 'success') {
      return '$baseUrl/${jsonData['avatar']}'; // trả về đường dẫn ảnh đầy đủ
    }
  }
  return null;
}
