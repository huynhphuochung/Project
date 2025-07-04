import 'package:flutter/material.dart';
import '../api/base_url.dart';
import '../api/shoes_size_api.dart';
import 'shoes.dart';
import '../api/cart_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/user_id_api.dart';
import '../api/cart_api.dart';

class ShoesDetail extends StatefulWidget {
  final Shoes shoes;

  const ShoesDetail({super.key, required this.shoes});

  @override
  State<ShoesDetail> createState() => _ShoesDetailState();
}

class _ShoesDetailState extends State<ShoesDetail> {
  List<ShoeSize> sizes = [];
  String? selectedSizeValue;

  @override
  void initState() {
    super.initState();
    fetchShoeSizes(widget.shoes.id_shoe)
        .then((value) {
          setState(() {
            sizes = value;
          });
        })
        .catchError((e) {
          print('Lỗi khi lấy size: $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    final shoes = widget.shoes;

    return Scaffold(
      appBar: AppBar(
        title: Text(shoes.name_shoe),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hình ảnh giày
            Container(
              margin: const EdgeInsets.all(16),
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  '$baseUrl/image/${shoes.image}',
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),

            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shoes.name_shoe,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Price: ${shoes.price}\$',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Evaluate: ${shoes.star}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/star.png',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Bảng size giày
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Sizes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        sizes.map((size) {
                          final outOfStock = size.quantity == 0;
                          final isSelected =
                              selectedSizeValue ==
                              size.size.toString(); // 👈 Sửa ở đây

                          return GestureDetector(
                            onTap:
                                outOfStock
                                    ? null
                                    : () {
                                      setState(() {
                                        selectedSizeValue =
                                            size.size
                                                .toString(); // 👈 size dạng chuỗi
                                      });
                                    },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    outOfStock
                                        ? Colors.grey[300]
                                        : isSelected
                                        ? Colors
                                            .blue[100] // ✅ màu khi được chọn
                                        : Colors.green[100], // ✅ màu mặc định
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected ? Colors.blue : Colors.black12,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                              ),
                              child: Text(
                                outOfStock ? '${size.size} ❌' : '${size.size}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color: outOfStock ? Colors.red : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Nút BUY
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Xử lý mua ngay
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Buy now')),
                        );
                      },
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  // Nút Add to Cart
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                         print('🖱️ Bạn đã nhấn Add to Cart');

                        if (selectedSizeValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('⚠️ Vui lòng chọn size'),
                            ),
                          );
                          return;
                        }

                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) return;

                        final idUser = await getUserIdFromUid(currentUser.uid);
                        if (idUser != null) {
                          await addToCart(
                            idUser: idUser,
                           shoeId: widget.shoes.id_shoe,
                            size: selectedSizeValue!,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🛒 Đã thêm vào giỏ')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Không tìm thấy người dùng'),
                            ),
                          );
                        }
                      },

                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
