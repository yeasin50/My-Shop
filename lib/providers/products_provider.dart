import 'dart:math';

import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final url = 'https://my-shop-2233f.firebaseio.com/products.json';
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    /// /use as sub folder to root. [don't forget to use .json] */
    // const url = 'https://my-shop-2233f.firebaseio.com/products';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'title': product.title,
          'isFavorite': product.isFavorite
        }),
      );

      final _product = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.add(_product);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadProducts = [];
      extractData.forEach((key, prodData) {
        loadProducts.add(Product(
          id: key,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void updateProduct(String id, Product product) {
    final indexProduct = _items.indexWhere((element) => element.id == id);

    if (indexProduct >= 0) {
      _items[indexProduct] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
