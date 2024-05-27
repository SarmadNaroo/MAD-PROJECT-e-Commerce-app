import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> addToCart(String productId) async {
    List<String> cart = _prefs?.getStringList('cartItems') ?? [];
    if (!cart.contains(productId)) {
      cart.add(productId);
      await _prefs?.setStringList('cartItems', cart);
    }
  }

  static Future<void> removeFromCart(String productId) async {
    List<String> cart = _prefs?.getStringList('cartItems') ?? [];
    if (cart.contains(productId)) {
      cart.remove(productId);
      await _prefs?.setStringList('cartItems', cart);
    }
  }

  static Future<List<String>> getCartItems() async {
    return _prefs?.getStringList('cartItems') ?? [];
  }

  static Future<void> clearCart() async {
    await _prefs?.remove('cartItems');
  }
}
