import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateManagement/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product_detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context,
    listen: false// we dont need to update 
    ).findByID(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Text(productId),
      ),
    );
  }
}
