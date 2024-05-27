import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_tile.dart';
import 'cart_screen.dart';
import 'white_list_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;
  late Future<List<Product>> _products;
  late List<Product> _filteredProducts;

  final List<Map<String, String>> categories = [
    {'name': 'all', 'imageUrl': 'assets/images/all.png'},
    {'name': "men's clothing", 'imageUrl': 'assets/images/menclothing.png'},
    {'name': "women's clothing", 'imageUrl': 'assets/images/womenclothing.png'},
    {'name': "jewelery", 'imageUrl': 'assets/images/jewelry.jpg'},
    {'name': "electronics", 'imageUrl': 'assets/images/electronics.jpg'}
  ];

  @override
  void initState() {
    super.initState();
    _products = ApiService().fetchProducts();
    _filteredProducts = [];
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      if (categories[index]['name'] == 'all') {
        _products.then((products) {
          setState(() {
            _filteredProducts = products;
          });
        });
      } else {
        _products.then((products) {
          setState(() {
            _filteredProducts = products
                .where(
                    (product) => product.category == categories[index]['name'])
                .toList();
          });
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (_filteredProducts.isEmpty) {
              _filteredProducts = snapshot.data!;
            }
            return Column(
              children: [
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List<Widget>.generate(categories.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          avatar: CircleAvatar(
                            backgroundImage:
                                AssetImage(categories[index]['imageUrl']!),
                          ),
                          label: Text(categories[index]['name']!),
                          selected: _selectedCategoryIndex == index,
                          onSelected: (bool selected) {
                            _onCategorySelected(index);
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          2 / 3, // Adjust this ratio to reduce extra space
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      var product = _filteredProducts[index];
                      return ProductTile(
                        product: product,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No products found'));
          }
        },
      ),
      CartScreen(),
      WhiteListScreen(),
      OrderScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png',
                height: 40), // Your logo image
            SizedBox(width: 10),
            Text('Shopee',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.search),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined), 
              label: 'White List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Order Tracking',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 128, 128, 128),
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}
