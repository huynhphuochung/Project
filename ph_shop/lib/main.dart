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
  int _currentIndex = 0; // Chỉ số trang hiện tại
  final PageController _pageController = PageController(); // Thêm PageController

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0; // Cập nhật _currentIndex
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredShoes = _selectedBranch != null
        ? Shoes.ListShoes.where((shoe) => shoe.branch == _selectedBranch).toList()
        : Shoes.ListShoes;
    final uniqueBranches = Shoes.ListShoes.map((shoe) => shoe.branch).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: Colors.blueGrey[30],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedBranch = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _selectedBranch == null ? Colors.black : Colors.grey),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            'ALL',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...uniqueBranches.map((branch) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: SizedBox(
                        width: 70,
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedBranch = branch;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _selectedBranch == branch ? Colors.black : Colors.grey),
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          child: Image.asset(
                            branch,
                            height: 60,
                            width: 70,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200.0,
                  child: PageView.builder(
                    controller: _pageController, // Sử dụng PageController
                    itemCount: filteredShoes.length,
                    itemBuilder: (context, index) {
                      final shoe = filteredShoes[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShoesDetail(shoes: shoe),
                              ),
                            );
                          },
                          child: Image.asset(
                            shoe.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: filteredShoes.map((shoe) {
                    int index = filteredShoes.indexOf(shoe);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index ? Colors.black : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
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
                                return ShoesDetail(shoes: filteredShoes[rightIndex]);
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