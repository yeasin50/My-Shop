import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/https_exception.dart';

/// [Dont forget to add .json after URL ]
class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    /// /use as sub folder to root. [don't forget to use .json] */
    const url = 'https://my-shop-2233f.firebaseio.com/products.json';

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
    const url = 'https://my-shop-2233f.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadProducts = [];
      if (extractData == null) return;

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

  Future<void> updateProduct(String id, Product product) async {
    final indexProduct = _items.indexWhere((element) => element.id == id);

    if (indexProduct >= 0) {
      final url = 'https://my-shop-2233f.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price
          }));
      _items[indexProduct] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    ///* status code
    /// 200, 201 = everything work
    /// 300 redirected
    /// 400 , 500 something went worng
    ///
    final url = 'https://my-shop-2233f.firebaseio.com/products/$id.json';
    final exitProductIndex = _items.indexWhere((element) => element.id == id);
    var exitProduct = _items[exitProductIndex];
    _items.removeAt(exitProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(exitProductIndex, exitProduct);
      notifyListeners();
      throw HttpException('Couldn\'t delete product.');
    }
    exitProduct = null;
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
