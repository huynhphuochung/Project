import 'package:flutter/material.dart';
import 'cart_item.dart';
import '../api/user_id_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/get_card_api.dart';
import '../api/base_url.dart';
import '../api/delete_cart_api.dart'; // thêm đầu file

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<List<CartItem>>? futureCart; // Thay vì late

  Future<int?> getCurrentUserId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;
    return await getUserIdFromUid(currentUser.uid);
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = await getUserIdFromUid(currentUser.uid);
      if (userId != null) {
        setState(() {
          futureCart = fetchCartItems(userId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[100],
        elevation: 2,
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<CartItem>>(
        future: futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Giỏ hàng trống'));
          }

          final cartItems = snapshot.data!;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            '$baseUrl/image/${item.image}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text('Size: ${item.size}'),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        setState(() {
                                          item.quantity--;
                                        });
                                      }
                                    },
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20,),
                            IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.red),
                              onPressed: () async {
                                final success = await deleteCartItem(item.id);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('🗑️ Đã xóa khỏi giỏ hàng'),
                                    ),
                                  );
                                  loadCart();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                   // Dòng ngang
                ],
              );
            },
          );
        },
      ),
    );
  }
}
