import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; // this will change according to person wish

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _revFavValue(bool fav) {
    isFavorite = fav;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://my-shop-2233f.firebaseio.com/products/$id';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      /* patch, put or delete doesn't throw exception*/
      if (response.statusCode >= 400) {
        _revFavValue(oldStatus);
      }
    } catch (e) {
      _revFavValue(oldStatus);
    }
  }
}
