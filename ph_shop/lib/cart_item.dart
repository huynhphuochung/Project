class CartItem {
  final int id;
  final String shoeId;
  final String name;
  final String image;
  final double price;
  final int quantity;
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
    id: int.parse(json['id'].toString()),
    shoeId: json['shoe_id'].toString(),
    name: json['name'].toString(),
    image: json['image'].toString(),
    price: double.parse(json['price'].toString()),
    quantity: int.parse(json['quantity'].toString()),
    size: json['size'].toString(),
  );
}
}
