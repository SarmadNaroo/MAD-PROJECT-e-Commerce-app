import 'package:shared_preferences/shared_preferences.dart';

class WhiteListService {
  static Future<void> addToWhiteList(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? whiteList = prefs.getStringList('whiteList');
    if (whiteList == null) {
      whiteList = [];
    }
    if (!whiteList.contains(productId)) {
      whiteList.add(productId);
      await prefs.setStringList('whiteList', whiteList);
    }
  }

  static Future<List<String>> getWhiteList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('whiteList') ?? [];
  }

  static Future<void> removeFromWhiteList(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? whiteList = prefs.getStringList('whiteList');
    if (whiteList != null && whiteList.contains(productId)) {
      whiteList.remove(productId);
      await prefs.setStringList('whiteList', whiteList);
    }
  }
}
