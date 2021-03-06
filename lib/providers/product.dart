import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart' as Constants;

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

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    print(isFavorite);
    notifyListeners();
    // TODO: add base api
    final url =
        '${Constants.BASE_API_REALTIMEdb}/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      print(response.body);
      /* patch, put or delete doesn't throw exception*/
      if (response.statusCode >= 400) {
        _revFavValue(oldStatus);
      }
    } catch (e) {
      _revFavValue(oldStatus);
    }
  }
}
