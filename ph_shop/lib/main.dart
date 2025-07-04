import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'account_page.dart';
import 'shoes.dart';
import '../api/shoes_api.dart';
import '../api/base_url.dart';
import 'shoes_detail.dart';
import 'cart.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PHShop());
}

class PHShop extends StatelessWidget {
  const PHShop({super.key});

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
  String? _selected_user_Gender;
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  List<Shoes> shoesList = [];
  bool isLoading = true;

  final List<String> pageViewImages = [
    'image1.png',
    'image2.png',
    'image3.png',
  ];

  final List<String> types = ['ALL', 'MEN', 'WOMEN'];
  final Map<String, String?> genderFilters = {
    'ALL': null,
    'MEN': 'Nam',
    'WOMEN': 'Nữ',
  };

  @override
  void initState() {
    super.initState();
    fetchShoes().then((data) {
      setState(() {
        shoesList = data;
        isLoading = false;
      });
    });
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filteredShoes =
        _selected_user_Gender == null || _selected_user_Gender == 'ALL'
            ? shoesList
            : shoesList
                .where((shoe) => shoe.user_gender == _selected_user_Gender)
                .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40, width: 40),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            tooltip: 'Giỏ hàng',
            onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CartPage()),
  );
},

          ),
          Builder(
            builder: (context) {
              final user = FirebaseAuth.instance.currentUser;
              return IconButton(
                icon: Icon(
                  user == null ? Icons.login : Icons.account_circle,
                  color: Colors.black,
                ),
                tooltip: user == null ? 'Đăng nhập' : 'Tài khoản',
                onPressed: () {
                  if (user == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AccountPage()),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                enabled: false, // ⛔ Không cho nhập, chỉ là giao diện
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.white,
              child: Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children:
                    genderFilters.entries.map((entry) {
                      final String label = entry.key; // 'MEN'
                      final String? genderValue = entry.value; // 'Nam'
                      final bool isSelected =
                          _selected_user_Gender == genderValue;

                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 64) / 3,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selected_user_Gender = genderValue;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                isSelected ? Colors.black : Colors.white,
                            foregroundColor:
                                isSelected ? Colors.white : Colors.black,
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pageViewImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'assets/pageview/${pageViewImages[index]}',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pageViewImages.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final shoe = filteredShoes[index];
                return buildShoesCard(shoe);
              }, childCount: filteredShoes.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShoesCard(Shoes shoes) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoesDetail(shoes: shoes)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/logo.png', width: 40, height: 40),
                  const Spacer(),
                  Text(
                    shoes.star,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 5)),
                  Image.asset('assets/star.png', width: 20, height: 20),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Image.network(
                  '$baseUrl/image/${shoes.image}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                shoes.name_shoe,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(shoes.price, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
