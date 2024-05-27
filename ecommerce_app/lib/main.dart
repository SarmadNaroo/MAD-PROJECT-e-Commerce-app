import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/splash_screen.dart';
import 'models/product.dart'; 
import 'services/cart_service.dart';
import 'screens/cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/productDetails':
        if (settings.arguments is Product) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: settings.arguments as Product),
          );
        }
        return _errorRoute();
      case '/cart':  // Add this route
        return MaterialPageRoute(builder: (_) => CartScreen());
      default:
        return _errorRoute();
    }
  }
  
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR: Route not found'),
        ),
      ),
    );
  }
}
