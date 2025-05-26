class Shoes {
  String name;
  String imageUrl;
  String branch;
  String star;
  Shoes(this.name, this.imageUrl, this.branch,this.star);
  static List<Shoes> ListShoes = [
    Shoes('VOMERO 18', 'assets/Nike.png', 'assets/logo_nike.png','assets/star.png'),
    Shoes('ZX 700', 'assets/ZX_700.png', 'assets/logo_adidas.jpg','assets/star.png'),
    Shoes('Nike killshort', 'assets/Nike_kill.jpg', 'assets/logo_nike.png','assets/star.png' )
  ];
}
