import 'package:flutter/material.dart';
import 'package:stateManagement/widgets/product_item.dart';
import '../models/product.dart';

class ProductOverViewScreen extends StatelessWidget {
  final List<Product> productList = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      body: GridView.builder(
        itemCount: productList.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,//width /height ratio
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ProductItem(
            productList[i].id,
            productList[i].title,
            productList[i].description,
            productList[i].imageUrl),
      ),
    );
  }
}
