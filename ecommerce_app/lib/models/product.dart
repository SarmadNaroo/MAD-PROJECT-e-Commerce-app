import 'rating.dart'; // Make sure this import is correct

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'], // Changed from 'id' to '_id'
      title: json['title'],
      price: json['price'].toDouble(), // Ensure this conversion if the price can be int or double
      description: json['description'],
      category: json['category'],
      imageUrl: json['image'], // Ensure this key matches with your JSON
      rating: Rating.fromJson(json['rating']), // Assuming your Rating model handles this structure
    );
  }
}
