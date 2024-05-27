import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart'; 
import '../models/order.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000/api';
  // final String baseUrl = 'http://192.168.56.1:3000/api';

  // fetch all products
  Future<List<Product>> fetchProducts() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> productJson = json.decode(response.body);
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // fetch product by id
  Future<Product> fetchProductById(String productId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/products/$productId'));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  // place order with user details
  Future<void> placeOrder(String name, String phone, String city, String postalAddress, List<String> productIds) async {
    final url = '$baseUrl/orders';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'phone': phone,
        'city': city,
        'postalAddress': postalAddress,
        'productIds': productIds,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to place order');
    }
  }

  // fetch all orders
  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders'));
    if (response.statusCode == 200) {
      List<dynamic> orderJson = json.decode(response.body);
      return orderJson.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
