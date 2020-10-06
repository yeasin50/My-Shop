import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/main_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserProductItem(
                id: productData.items[i].id,
                title: productData.items[i].title,
                imageUrl: productData.items[i].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
