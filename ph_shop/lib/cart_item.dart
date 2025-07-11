class CartItem {
  final int id;
  final String shoeId;
  final String name;
  final String image;
  final double price;
   int quantity;
  final String size;

  CartItem({
    required this.id,
    required this.shoeId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.size,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      shoeId: json['shoe_id'],
      name: json['name'],
      image: json['image'], // 👈 đây là hình theo màu
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      size: json['size'],
    );
  }
}
