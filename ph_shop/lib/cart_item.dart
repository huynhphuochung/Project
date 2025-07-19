class CartItem {
  final int id;
  final String shoeId;
  final String name;
  final String image; // ảnh đại diện màu
  final double price;
  int quantity;
  final String size;
final int? colorId;
      // ✅ thêm colorId
  final String? colorName;  // ✅ tùy chọn: tên màu (ví dụ: Đỏ, Trắng)

  CartItem({
    required this.id,
    required this.shoeId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.size,
   this.colorId,
    this.colorName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      shoeId: json['shoe_id'],
      name: json['name'],
      image: json['image'],
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      size: json['size'],
      colorId: json['color_id'],
      colorName: json['color_name'], // nếu có join tên màu
    );
  }
}
