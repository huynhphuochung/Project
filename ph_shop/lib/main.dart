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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[100],
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
String searchQuery = '';

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
  // Giỏ hàng
  Padding(
    padding: const EdgeInsets.only(right: 12),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.black,
          size: 24,
        ),
      ),
    ),
  ),

  // Đăng nhập hoặc tài khoản
  Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Builder(
      builder: (context) {
        final user = FirebaseAuth.instance.currentUser;
        return GestureDetector(
          onTap: () {
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
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              user == null ? Icons.login : Icons.person,
              color: Colors.black,
              size: 24,
            ),
          ),
        );
      },
    ),
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
                  hintText: 'Looking for shoes',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
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
                                isSelected ? Colors.blue[300] : Colors.white,
                            foregroundColor:
                                isSelected ? Colors.white : Colors.black,
                                 side: BorderSide.none,
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
        color: Colors.blue[50],
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[400], // 🎨 màu nền khung sao
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          shoes.star,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset('assets/star.png', width: 16, height: 16),
                      ],
                    ),
                  ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🟥 Khung tên giày (trên)
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      shoes.name_shoe,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 🟩 Khung giá giày (dưới)
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$${shoes.price}',
                      style:  TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[400],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
