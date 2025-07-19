import 'package:flutter/material.dart';
import '../api/base_url.dart';
import '../api/shoes_size_api.dart';
import '../api/shoes_colors_api.dart';
import 'shoes.dart';
import '../api/cart_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/user_id_api.dart';
import 'cart.dart';

class ShoesDetail extends StatefulWidget {
  final Shoes shoes;

  const ShoesDetail({super.key, required this.shoes});

  @override
  State<ShoesDetail> createState() => _ShoesDetailState();
}

class _ShoesDetailState extends State<ShoesDetail> {
  List<ShoeSize> sizes = [];
  List<ShoeColor> colors = [];
  String? selectedSizeValue;
  ShoeColor? selectedColor;
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
   if (selectedColor != null) {
  fetchShoeSizes(widget.shoes.id_shoe, selectedColor!.idColor).then((sizesList) {
    setState(() {
      sizes = sizesList;
    });
  });
}

    fetchShoeColors(widget.shoes.id_shoe).then((value) {
      setState(() {
        colors = value;
        if (colors.isNotEmpty) {
          selectedColor = colors.first;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final shoes = widget.shoes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.black,
        elevation: 2,
        centerTitle: true,
        title: Text(
          shoes.name_shoe,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  selectedColor != null
                      ? '$baseUrl/image/${selectedColor!.imageUrl}'
                      : '$baseUrl/image/${shoes.image}',
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),

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
                        color: Colors.blue[100],
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
                  const SizedBox(height: 4),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${shoes.price}\$',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  const Text(
                    'Gallery',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        final color = colors[index];
                        print('$baseUrl/image/${color.imageUrl}');
                        final isSelected =
                            color.idColor == selectedColor?.idColor;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                              selectedSizeValue = null; // reset size
                              sizes = [];
                            });

                            fetchShoeSizes(
                              widget.shoes.id_shoe,
                              color.idColor,
                            ).then((value) {
                              setState(() {
                                sizes = value;
                              });
                            });
                          },

                          child: Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey,
                                width: isSelected ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                '$baseUrl/image/${color.imageUrl}',
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    'Sizes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          sizes.map((size) {
                            final outOfStock = size.quantity == 0;
                            final isSelected =
                                selectedSizeValue == size.size.toString();

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap:
                                    outOfStock
                                        ? null
                                        : () {
                                          setState(() {
                                            selectedSizeValue =
                                                size.size.toString();
                                          });
                                        },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        outOfStock
                                            ? Colors.grey[300]
                                            : isSelected
                                            ? Colors.blue[100]
                                            : Colors.white,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Colors.lightBlueAccent
                                              : Colors.white,
                                      width: isSelected ? 2.0 : 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    '${size.size}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          outOfStock ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (selectedQuantity > 1) {
                            setState(() {
                              selectedQuantity--;
                            });
                          }
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          selectedQuantity.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            selectedQuantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (selectedSizeValue == null) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: const Text(
                                    '⚠️ Vui lòng chọn size',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                        child: const Text('ĐÓNG'),
                                      ),
                                    ),
                                  ],
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
                            quantity: selectedQuantity,
                            image:
                                selectedColor?.imageUrl ?? widget.shoes.image,
                            colorId: selectedColor?.idColor, // ✅ thêm dòng này
                          );

                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 48,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Đã thêm vào giỏ hàng!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
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
