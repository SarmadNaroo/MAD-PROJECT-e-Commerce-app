import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/whitelist_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Handle share action
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.network(product.imageUrl),
                    ),
                    SizedBox(height: 16),
                    Text(
                      product.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'BY: ${product.category}', // Assuming category as brand here
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'STYLE: ${product.title}', // Assuming title as style here
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 4),
                        Text(
                          '${product.rating.rate} (${product.rating.count} reviews)',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: () async {
                    await WhiteListService.addToWhiteList(product.id.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to White List'))
                    );
                  },
                  icon: Icon(Icons.favorite_border_outlined),
                  label: Text('WHITE LIST'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // Make the button square
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16), // Adjust padding for square shape
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(0), // Make the button square
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 242, 101, 73), // RGB(242, 101, 73)
                        Color.fromARGB(255, 222, 34, 92) // RGB(222, 34, 92)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await CartService.addToCart(product.id
                          .toString()); // Call the add to cart function with the product's ID
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Added to cart'))); 
                    },
                    icon: Icon(Icons.shopping_cart),
                    label: Text('ADD TO CART'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Use transparent to show the gradient
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // Make the button square
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16), // Adjust padding for square shape
                      foregroundColor: Colors.white, // Set text color to white
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
