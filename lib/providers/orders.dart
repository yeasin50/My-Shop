import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import './cart_.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart' as Constants;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  // final String userId;
  Orders(this.authToken, this._orders);
  void update(
    String authToken,
    // this.userId,
  ) {
    authToken = authToken;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    // TODO: add base api
    final url = '${Constants.BASE_API_REALTIMEdb}/orders.json?auth=$authToken';
    final response = await http.get(url);
    // print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) return;
    extractedData.forEach((key, value) {
      loadedOrders.add(
        OrderItem(
          id: key,
          amount: value['amount'],
          dateTime: DateTime.parse(value['dateTime']),
          products: (value['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // TODO: add base api
    // final url = '${Constants.BASE_API_REALTIMEdb}/orders.json?auth=$authToken';
    final url =
        'https://my-shop-2233f.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                    // 'creatorId':
                  })
              .toList(),
        }),
      );
      print(json.decode(response.body));
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: cartProducts),
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
