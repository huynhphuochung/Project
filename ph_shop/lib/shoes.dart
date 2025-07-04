class Shoes {
  final String id_shoe;
  final String name_shoe;
  final String type_shoe;
  final String user_gender;
  final String price;
  final String image;
  final String star;

  Shoes({
    required this.id_shoe,
    required this.name_shoe,
    required this.type_shoe,
    required this.user_gender,
    required this.price,
    required this.image,
    required this.star,
  });

  factory Shoes.fromJson(Map<String, dynamic> json) {
    return Shoes(
      id_shoe: json['id_shoe'],
      name_shoe: json['name_shoe'],
      type_shoe: json['type_shoe'],
      user_gender: json['user_gender'],
      price: json['price'],
      image: json['image'],
      star: json['star'],
    );
  }
}
class ShoeSize {
  final int size;
  final int quantity;

  ShoeSize({required this.size, required this.quantity});

  factory ShoeSize.fromJson(Map<String, dynamic> json) {
    return ShoeSize(
      size: int.parse(json['size'].toString()),
      quantity: int.parse(json['quantity'].toString()),
    );
  }
}
