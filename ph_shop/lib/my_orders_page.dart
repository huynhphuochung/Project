import 'dart:async'; // thêm để dùng StreamSubscription
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/base_url.dart';
import '../api/user_id_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List orders = [];
  bool isLoading = true;
  StreamSubscription<RemoteMessage>? _messageSubscription; // lưu listener

 Future<void> fetchOrders() async {
  setState(() {
    isLoading = true;
  });

  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final userId = await getUserIdFromUid(currentUser.uid);

    final response = await http.get(
      Uri.parse('${baseUrl}orders/get_orders.php?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          orders = data['orders'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ${data['message']}')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi server: ${response.statusCode}')),
      );
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi kết nối: $e')),
    );
  }
}



  @override
  void initState() {
    super.initState();
    fetchOrders();
    _messageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (message.data['type'] == 'order_update') {
          fetchOrders();
        }
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel(); // hủy listener khi thoát trang
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đơn hàng của tôi"),
        backgroundColor: Colors.blue[100],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('Bạn chưa có đơn hàng nào.'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final items = order['items'] as List;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ExpansionTile(
                        title: Text('🧾 Đơn hàng #${order['id']}'),
                        subtitle: Text(
                          'Tổng tiền: \$${double.parse(order['total'].toString()).toStringAsFixed(2)}\nTrạng thái: ${order['status']}',
                        ),
                        children: items.map((item) {
                          final quantity = int.parse(item['quantity'].toString());
                          final price = double.parse(item['price'].toString());
                          return ListTile(
                            leading: Image.network(
                              // ưu tiên ảnh màu nếu có, fallback ảnh giày, fallback ảnh mặc định
                              '$baseUrl/image/${item['color_image'] ?? item['image'] ?? 'default_image.jpg'}',
                              width: 50,
                              height: 50,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                            title: Text(item['name_shoe']),
                            subtitle: Text(
                              'Size: ${item['size']} | SL: $quantity | Màu: ${item['color_name'] ?? 'Không rõ'}',
                            ),
                            trailing: Text(
                              '\$${(quantity * price).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
    );
  }
}
