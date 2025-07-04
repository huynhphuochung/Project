import 'package:flutter/material.dart';
import '../api/cart_api.dart';
import 'cart_item.dart';
import '../api/user_id_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/cart_api.dart';
import '../api/get_card_api.dart';
import '../api/base_url.dart';
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
    loadCart(); // 👈 GỌI ĐỂ FETCH DỮ LIỆU
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
      appBar: AppBar(title: const Text('Giỏ Hàng')),
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
              return ListTile(
                leading: Image.network('$baseUrl/image/${item.image}', width: 50),
                title: Text(item.name),
                subtitle: Text('Size: ${item.size} - ${item.quantity} x \$${item.price}'),
                trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
