import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/whitelist_service.dart';

class WhiteListScreen extends StatefulWidget {
  @override
  _WhiteListScreenState createState() => _WhiteListScreenState();
}

class _WhiteListScreenState extends State<WhiteListScreen> {
  late Future<List<Product>> whiteListProducts;

  @override
  void initState() {
    super.initState();
    whiteListProducts = getWhiteListProducts();
  }

  Future<List<Product>> getWhiteListProducts() async {
    List<String> productIds = await WhiteListService.getWhiteList();
    List<Product> products = [];
    for (String id in productIds) {
      Product product = await ApiService().fetchProductById(id);
      products.add(product);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('White List'),
      ),
      body: FutureBuilder<List<Product>>(
        future: whiteListProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading white list items: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your white list is empty'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return productCard(snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget productCard(Product product) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/productDetails', arguments: product);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(product.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Category: ${product.category}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () async {
                await WhiteListService.removeFromWhiteList(product.id.toString());
                setState(() {
                  whiteListProducts = getWhiteListProducts();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.title} removed from White List')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
