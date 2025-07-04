import 'package:http/http.dart' as http;
import 'base_url.dart'; // import đường dẫn cơ bản

/// Gửi thông tin người dùng về server PHP để lưu vào MySQL
Future<void> insertUserToMySQL(String uid, String email, String name) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}user/create_user.php'), // sử dụng baseUrl
      body: {'uid': uid, 'email': email, 'name': name},
    );

    if (response.statusCode == 200) {
      print("✅ Insert thành công: ${response.body}");
    } else {
      print("❌ Insert thất bại: ${response.body}");
    }
  } catch (e) {
    print("❌ Lỗi khi gọi API: $e");
  }
}
