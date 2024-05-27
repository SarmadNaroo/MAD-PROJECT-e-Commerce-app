import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'order_tracking_screen.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Order>> orders;

  @override
  void initState() {
    super.initState();
    orders = ApiService().fetchOrders();
  }

  Future<Product?> fetchFirstProduct(String productId) async {
    return await ApiService().fetchProductById(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),

      ),
      body: FutureBuilder<List<Order>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading orders: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Order order = snapshot.data![index];
                return FutureBuilder<Product?>(
                  future: fetchFirstProduct(order.productIds.first),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (productSnapshot.hasError) {
                      return Center(child: Text('Error loading product: ${productSnapshot.error}'));
                    } else {
                      Product? product = productSnapshot.data;
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: product != null ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                          ) : Container(width: 50, height: 50, color: Colors.grey),
                          title: Text('Order #${order.orderId}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product != null ? product.title : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Placed on: ${order.orderPlaced.toLocal()}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderTrackingScreen(order: order),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
