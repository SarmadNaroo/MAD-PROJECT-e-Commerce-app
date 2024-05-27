import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';

class OrderReviewScreen extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String city;
  final String postalAddress;
  final String paymentMethod;

  const OrderReviewScreen({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.postalAddress,
    required this.paymentMethod,
  }) : super(key: key);

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

  Future<void> confirmOrder(BuildContext context, List<String> productIds) async {
    try {
      await ApiService().placeOrder(name, phoneNumber, city, postalAddress, productIds);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully!')));
      Navigator.pushNamed(context, "/home");
      // Clear the cart after placing the order
      CartService.clearCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Your Order'),
      ),
      body: FutureBuilder<List<Product>>(
        future: getCartProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading cart items: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          } else {
            final cartProducts = snapshot.data!;
            final total = calculateTotal(cartProducts);
            final productIds = cartProducts.map((product) => product.id.toString()).toList();
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildSectionTitle('User Details'),
                  _buildUserInfoRow(Icons.person, 'Name', name),
                  _buildUserInfoRow(Icons.phone, 'Phone Number', phoneNumber),
                  _buildUserInfoRow(Icons.location_city, 'City', city),
                  _buildUserInfoRow(Icons.home, 'Postal Address', postalAddress),
                  _buildUserInfoRow(Icons.payment, 'Payment Method', paymentMethod),
                  SizedBox(height: 20),
                  Divider(),
                  _buildSectionTitle('Cart Items'),
                  ...cartProducts.map((product) => _buildCartItem(product)).toList(),
                  Divider(),
                  _buildTotalRow(total),
                  SizedBox(height: 20),
                  _buildButtons(context, productIds),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Expanded(
            child: Text('$label: $value', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("\$${product.price.toStringAsFixed(2)}", style: TextStyle(color: Colors.green, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, List<String> productIds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 140,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Square corners
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel Order', style: TextStyle(color: Colors.black)),
          ),
        ),
        Container(
          width: 160,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 242, 101, 73), // Light orange
                Color.fromARGB(255, 222, 34, 92) // Deep pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20), // Square corners
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent, // No shadow for a cleaner look
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Square corners
              ),
            ),
            onPressed: () => confirmOrder(context, productIds),
            child: const Text('Confirm Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
