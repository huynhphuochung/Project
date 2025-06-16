import 'package:flutter/material.dart';
import 'shoes.dart';
import 'shoes_detail.dart';

void main() {
  runApp(const ph_shop());
}

class ph_shop extends StatelessWidget {
  const ph_shop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PH Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.green,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.blueGrey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const MyHomePage(title: 'PH SHOP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedBranch; // Biến để lưu thương hiệu được chọn

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách giày theo thương hiệu nếu _selectedBranch không null
    final filteredShoes = _selectedBranch != null
        ? Shoes.ListShoes.where((shoe) => shoe.branch == _selectedBranch).toList()
        : Shoes.ListShoes;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Thêm logo (giả định đường dẫn)
            Image.asset(
              'assets/logo.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            // Áp dụng kiểu chữ cho tiêu đề
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'MerriweatherSans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Hàng ngang các nút thương hiệu
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Nút "Tất cả" để hiển thị tất cả giày
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedBranch = null; // Xóa bộ lọc
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _selectedBranch == null ? Colors.black : Colors.grey),
                        foregroundColor: _selectedBranch == null ? Colors.black : Colors.grey,
                      ),
                      child: const Text('Tất cả'),
                    ),
                  ),
                  // Danh sách các nút thương hiệu
                  ...Shoes.ListShoes.map((shoe) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedBranch = shoe.branch; // Lưu thương hiệu được chọn
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _selectedBranch == shoe.branch ? Colors.black : Colors.grey),
                          foregroundColor: _selectedBranch == shoe.branch ? Colors.black : Colors.grey,
                        ),
                        child: Text(
                          shoe.branch.split('/').last.replaceAll('.png', '').replaceAll('.jpg', ''),
                          style: const TextStyle(fontSize: 16, ),
                        ),
                      ),
                    );
                  }).toSet().toList(), // Loại bỏ các nút trùng lặp
                ],
              ),
            ),
          ),
          // Danh sách giày với 2 cột (giữ nguyên như bạn cung cấp)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: (filteredShoes.length / 2).ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ShoesDetail(shoes: filteredShoes[index]);
                              },
                            ),
                          );
                        },
                        child: buildShoesCard(filteredShoes[index]),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: (filteredShoes.length / 2).floor(),
                    itemBuilder: (BuildContext context, int index) {
                      int rightIndex = index + (filteredShoes.length / 2).ceil();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ShoesDetail(
                                  shoes: filteredShoes[rightIndex],
                                );
                              },
                            ),
                          );
                        },
                        child: buildShoesCard(filteredShoes[rightIndex]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShoesCard(Shoes shoes) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Image.asset(shoes.branch, height: 30, width: 30),
                Spacer(),
                Image.asset(
                  shoes.star,
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Image(image: AssetImage(shoes.imageUrl)),
            const SizedBox(height: 10.0),
            Text(
              shoes.name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'MerriweatherSans',
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              shoes.price,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'MerriweatherSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}