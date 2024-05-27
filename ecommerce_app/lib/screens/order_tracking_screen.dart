import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({Key? key, required this.order}) : super(key: key);

  Future<List<Product>> fetchOrderProducts() async {
    List<Product> products = [];
    for (String id in order.productIds) {
      Product product = await ApiService().fetchProductById(id);
      products.add(product);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchOrderProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading products: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            final cartProducts = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Products'),
                    ...cartProducts.map((product) => _buildCartItem(product)).toList(),
                    SizedBox(height: 20),
                    Divider(),
                    _buildSectionTitle('Order Status'),
                    _buildOrderStatus(),
                    SizedBox(height: 20),
                    Divider(),
                    _buildUserInfoSection(),
                  ],
                ),
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

  Widget _buildUserInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('User Details'),
        _buildUserInfoRow(Icons.person, 'Name', order.name),
        _buildUserInfoRow(Icons.phone, 'Phone Number', order.phone),
        _buildUserInfoRow(Icons.location_city, 'City', order.city),
        _buildUserInfoRow(Icons.home, 'Postal Address', order.postalAddress),
      ],
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

  Widget _buildOrderStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusStep(
          isFirst: true,
          isLast: false,
          isActive: true,
          title: 'Order Placed',
          description: order.orderPlaced.toLocal().toString(),
        ),
        _buildStatusStep(
          isFirst: false,
          isLast: false,
          isActive: order.orderProcessedStatus,
          title: 'Order Processed',
          description: order.orderProcessedStatus ? 'Your order is processed' : 'Processing not started',
        ),
        _buildStatusStep(
          isFirst: false,
          isLast: false,
          isActive: order.orderShippedStatus,
          title: 'Order Shipped',
          description: order.orderShippedStatus ? 'Your order is shipped' : 'Shipping not started',
        ),
        _buildStatusStep(
          isFirst: false,
          isLast: false,
          isActive: order.outForDeliveryStatus,
          title: 'Out for Delivery',
          description: order.outForDeliveryStatus ? 'Out for delivery' : 'Not out for delivery',
        ),
        _buildStatusStep(
          isFirst: false,
          isLast: true,
          isActive: order.deliveredStatus,
          title: 'Delivered',
          description: order.deliveredStatus ? 'Order delivered' : 'Not delivered yet',
        ),
      ],
    );
  }

  Widget _buildStatusStep({
    required bool isFirst,
    required bool isLast,
    required bool isActive,
    required String title,
    required String description,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        color: isActive ? Colors.orange : Colors.grey,
        indicator: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.orange : Colors.grey,
          ),
          child: isActive
              ? Center(child: Icon(Icons.check, color: Colors.white))
              : SizedBox(),
        ),
      ),
      beforeLineStyle: LineStyle(
        thickness: 3,
        color: isActive ? Colors.orange : Colors.grey,
      ),
      afterLineStyle: LineStyle(
        thickness: 3,
        color: isActive ? Colors.orange : Colors.grey,
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(description, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
