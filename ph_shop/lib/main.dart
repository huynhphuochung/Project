import 'package:flutter/material.dart';
import 'shoes.dart';
import 'shoes_detail.dart';
void main() {
  runApp(const ph_shop());
}

class ph_shop extends StatelessWidget {
  const ph_shop({super.key});

  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: (Shoes.ListShoes.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                // 7
                return GestureDetector(
                  // 8
                  onTap: () {
                    // 9
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // 10
                          // TODO: Replace return with return RecipeDetail()
                          return ShoesDetail(shoes: Shoes.ListShoes[index]);
                        },
                      ),
                    );
                  },
                  // 11
                  child: buildShoesCard(Shoes.ListShoes[index]),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: (Shoes.ListShoes.length / 2).floor(),
              itemBuilder: (BuildContext context, int index) {
                int rightIndex = index + (Shoes.ListShoes.length / 2).ceil();
                // 7
                return GestureDetector(
                  // 8
                  onTap: () {
                    // 9
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // 10
                          // TODO: Replace return with return RecipeDetail()
                         return ShoesDetail(shoes: Shoes.ListShoes[rightIndex]);
                        },
                      ),
                    );
                  },
                  // 11
                  child: buildShoesCard(Shoes.ListShoes[rightIndex]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
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
