import 'package:flutter/material.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://www.collinsdictionary.com/images/full/trousers_29362489_1000.jpg'),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.favorite).toList();
  }

  void addProduct(Product product) {
    // _items.add(value);
    final _product = Product(
      id: DateTime.now().toString(),
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      title: product.title,
    );
    _items.add(_product);
    notifyListeners();
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
