import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/base_url.dart';
import '../api/user_id_api.dart';
import 'cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_orders_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String paymentMethod = 'COD';

  Future<void> placeOrder() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Vui lòng đăng nhập để đặt hàng')),
      );
      return;
    }

    final userId = await getUserIdFromUid(currentUser.uid);
    final orderItems =
        widget.cartItems
            .map(
              (item) => {
                'shoe_id': item.shoeId,
                'size': item.size,
                'quantity': item.quantity,
                'price': item.price,
                'color_id': item.colorId,
              },
            )
            .toList();

    final response = await http.post(
      Uri.parse('${baseUrl}orders/create_order.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'address': addressController.text,
        'phone': phoneController.text,
        'payment_method': paymentMethod,
        'items': orderItems,
        'total_amount': widget.totalAmount,
      }),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        (result['success'] == true || result['status'] == 'success')) {
      for (var item in widget.cartItems) {
        await http.post(
          Uri.parse('${baseUrl}orders/update_quantity.php'),
          body: {
            'shoe_id': item.shoeId,
            'color_id': item.colorId.toString(),
            'size': item.size.toString(),
            'quantity': item.quantity.toString(),
          },
        );
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('✅ ${result['message']}')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyOrdersPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ ${result['message']}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đơn hàng'),
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Sản phẩm:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ...widget.cartItems.map(
              (item) => ListTile(
                leading: Image.network(
                  '$baseUrl/image/${item.image}',
                  width: 50,
                  height: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
                title: Text(item.name),
                subtitle: Text(
                  'Size: ${item.size} | Số lượng: ${item.quantity}',
                ),
                trailing: Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                ),
              ),
            ),
            const Divider(height: 32),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ giao hàng',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            const Text(
              'Phương thức thanh toán:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              value: 'COD',
              groupValue: paymentMethod,
              title: const Text('Thanh toán khi nhận hàng'),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),
            RadioListTile(
              value: 'BANK',
              groupValue: paymentMethod,
              title: const Text('Chuyển khoản'),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                if (addressController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ Vui lòng nhập đủ thông tin'),
                    ),
                  );
                  return;
                }
                placeOrder();
              },
              child: Text(
                'XÁC NHẬN ĐẶT HÀNG - \$${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
