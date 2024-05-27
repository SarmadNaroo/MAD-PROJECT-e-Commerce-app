import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Product>> cartProducts;

  @override
  void initState() {
    super.initState();
    cartProducts = getCartProducts();
  }

  Future<List<Product>> getCartProducts() async {
    List<String> productIds = await CartService.getCartItems();
    List<Product> products = [];
    for (String id in productIds) {
      Product product = await ApiService().fetchProductById(id);
      products.add(product);
    }
    return products;
  }

  double calculateTotal(List<Product> products) {
    return products.fold(0, (double total, current) => total + current.price);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: cartProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error loading cart items: ${snapshot.error}"));
        } else if (snapshot.data!.isEmpty) {
          return Center(child: Text("Your cart is empty"));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    Product product = snapshot.data![index];
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(product.imageUrl,
                                  width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(product.title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text("\$${product.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16)),
                                  SizedBox(height: 8),
                                  Text("Category: ${product.category}",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline,
                                            color: Colors.red),
                                        onPressed: () {
                                          CartService.removeFromCart(
                                                  product.id.toString())
                                              .then((_) {
                                            setState(() {
                                              cartProducts = getCartProducts();
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                        "\$${calculateTotal(snapshot.data!).toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0))),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        0), // Rounded corners for aesthetic
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 242, 101, 73), // Light orange
                        Color.fromARGB(255, 222, 34, 92) // Deep pink
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Ensures that the gradient is visible
                      elevation: 0, // No elevation for a flat design
                      shadowColor:
                          Colors.transparent, // No shadow for a cleaner look
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Match container border
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () => showCheckoutForm(context),
                    child: Text('CHECKOUT',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
