import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double temp = 0.0;
    _items.forEach((key, cartitem) {
      temp += cartitem.quantity * cartitem.price;
    });
    return temp;
  }

  void addItem({String productId, double price, String title}) {
    if (_items.containsKey(productId)) {
      // if we have the item already, update the quantity
      _items.update(
          productId,
          (exitsitem) => CartItem(
                id: exitsitem.id,
                title: exitsitem.title,
                price: exitsitem.price,
                quantity: exitsitem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }
}
