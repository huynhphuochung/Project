import 'package:http/http.dart' as http;
import 'base_url.dart';

Future<void> addToCart({
  required int idUser,
  required String shoeId,
  required String size,
  int quantity = 1,
  required String image,
  int? colorId, // ✅ Thêm dòng này
}) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}cart/add_to_cart.php'),
      body: {
        'id_user': idUser.toString(),
        'shoe_id': shoeId.toString(),
        'size': size,
        'quantity': quantity.toString(),
        'image': image,
        'color_id': colorId?.toString(), // ✅ Gửi thêm color_id nếu có
      },
    );

    if (response.statusCode == 200) {
      print('✅ Thêm vào giỏ: ${response.body}');
    } else {
      print('❌ Lỗi khi thêm giỏ: ${response.body}');
    }
  } catch (e) {
    print('❌ Lỗi kết nối: $e');
  }
}
