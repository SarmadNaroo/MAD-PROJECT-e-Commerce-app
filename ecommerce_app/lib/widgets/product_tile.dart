import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/productDetails',
          arguments: product,
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(8.0),
        child: IntrinsicHeight(  // This widget forces its child to be exactly as tall as its content.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,  // Ensuring the column does not take more space than its content.
            children: <Widget>[
              Expanded(  // Removing fixed height and allowing image to scale with its aspect ratio.
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,  // Ensures the image covers the allotted space without resizing its aspect ratio.
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),  // Reducing padding around the price.
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
