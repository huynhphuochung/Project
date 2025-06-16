class Shoes {
  final int id;
  final String name;
  final String imageUrl;
  final String branch;
  final String star;
  final String price;
  Shoes({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.branch,
    required this.star,
    required this.price,
  });
  static List<Shoes> ListShoes = [
    Shoes(
      id: 1,
      name: 'VOMERO 18',
      imageUrl: 'assets/Nike.png',
      branch: 'assets/logo_nike.png',
      star: 'assets/star.png',
      price: '1.800.000đ',
    ),
    Shoes(
      id: 2,
      name: 'ZX 700',
      imageUrl: 'assets/ZX_700.png',
      branch: 'assets/logo_adidas.jpg',
      star: 'assets/star.png',
      price: '1.800.000đ',
    ),
    Shoes(
      id: 3,
      name: 'Nike killshort',
      imageUrl: 'assets/Nike_kill.jpg',
      branch: 'assets/logo_nike.png',
      star: 'assets/star.png',
      price: '1.800.000đ',
    ),
    Shoes(
      id: 4,
      name: 'Samba',
      imageUrl: 'assets/samba.jpg',
      branch: 'assets/logo_adidas.jpg',
      star: 'assets/star.png',
      price: '1.800.000đ',
    ),
  ];
}

class Information_shoes {
  final id;
  final List<double> size;
  final String describe;

  Information_shoes({
    required this.id,
    required this.size,
    required this.describe,
  });
  static List<Information_shoes> List_Information_shoes = [
    Information_shoes(
      id:1,
      size: [39, 40, 41, 42, 43, 44],
      describe: 'Giày thể thao nam màu đen',
    ),
    Information_shoes(
      id:2,
      size: [39, 40, 41, 42, 43, 44],
      describe: 'Giày thời trang nam',
    ),
    Information_shoes(
      id:3,
      size: [39, 40, 41, 42, 43, 44],
      describe: 'Giày thời trang nữ',
    ),
    Information_shoes(
      id:4  ,
      size: [39, 40, 41, 42, 43, 44],
      describe: 'Giày thể thao nam màu đen',
    ),
  ];
}
