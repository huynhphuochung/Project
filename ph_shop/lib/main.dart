import 'package:flutter/material.dart';
import 'shoes.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
  String? _selectedBranch;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Shoes> shoesList = [
    Shoes(
      name: 'Nike Air Max',
      price: '\$120',
      imageUrl: 'assets/Nike_kill.jpg',
      branch: 'assets/logo_nike.png',
      star: 'assets/star.png',
    ),
    Shoes(
      name: 'Adidas Ultraboost',
      price: '\$150',
      imageUrl: 'assets/samba.jpg',
      branch: 'assets/logo_adidas.jpg',
      star: 'assets/star.png',
    ),
    Shoes(
      name: 'Puma Suede',
      price: '\$100',
      imageUrl: 'assets/Nike_kill.jpg',
      branch: 'assets/logo_adidas.jpg',
      star: 'assets/star.png',
    ),
  ];

  final List<String> pageViewImages = [
    'image1.png',
    'image2.png',
    'image3.png',
  ];

  @override
  void initState() {
    super.initState();
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
    final filteredShoes = _selectedBranch != null
        ? shoesList.where((shoe) => shoe.branch == _selectedBranch).toList()
        : shoesList;
    final uniqueBranches =
        shoesList.map((shoe) => shoe.branch).toSet().toList();

    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
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
  actions: [
    IconButton(
      icon: const Icon(Icons.login, color: Colors.black),
      tooltip: 'Đăng nhập',
      onPressed: () => _navigateToLogin(context),
    ),
  ],
),

      body: CustomScrollView(
        slivers: [
          // Branch Filter Buttons
          SliverToBoxAdapter(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.blueGrey[50],
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
                            side: BorderSide(
                                color: _selectedBranch == null
                                    ? Colors.black
                                    : Colors.grey),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                          ),
                          child: const Center(
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
                              side: BorderSide(
                                  color: _selectedBranch == branch
                                      ? Colors.black
                                      : Colors.grey),
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
          ),

          // PageView
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 200.0,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pageViewImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/pageview/${pageViewImages[index]}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pageViewImages.length, (index) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
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

          // Shoes Grid
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final shoe = filteredShoes[index];
                  return GestureDetector(
                    onTap: () {},
                    child: buildShoesCard(shoe),
                  );
                },
                childCount: filteredShoes.length,
              ),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Image.asset(shoes.branch, height: 30, width: 30),
                const Spacer(),
                Image.asset(
                  shoes.star,
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            SizedBox(
              height: 150,
              child: Image.asset(
                shoes.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              shoes.name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'MerriweatherSans',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5.0),
            Text(
              shoes.price,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'MerriweatherSans',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
