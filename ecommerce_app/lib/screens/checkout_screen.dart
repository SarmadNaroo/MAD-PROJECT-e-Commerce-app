import 'package:flutter/material.dart';
import 'order_review_screen.dart'; // Import the OrderReviewScreen

void showCheckoutForm(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalAddressController = TextEditingController();
  final _paymentMethod = 'Cash on Delivery'; // Default payment method

  showDialog(
    context: context,
    barrierDismissible: false,  // Ensures dialog must be actively dismissed
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Enter your details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city, color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _postalAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Postal Address',
                    prefixIcon: Icon(Icons.home, color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your postal address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Text color for the button
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          Container(
            width: 140, // Adjust width as needed
            height: 50, // Adjust height as needed
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
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderReviewScreen(
                        name: _nameController.text,
                        phoneNumber: _phoneNumberController.text,
                        city: _cityController.text,
                        postalAddress: _postalAddressController.text,
                        paymentMethod: _paymentMethod,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    },
  );
}
