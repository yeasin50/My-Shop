import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateManagement/providers/products_provider.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;
  ProductGrid(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productList =
        showFavorite ? productsData.favItems : productsData.items;

    // print("Global Fav "+ showFavorite.toString());
    // for (int i = 0; i < productList.length; i++) {
    //   print(productList[i].favorite);
    // }

    return GridView.builder(
      itemCount: productList.length,
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4, /// [width]/[height] ratio 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // we are not interested in return , that's why added value
        // create: (context) => productList[i],
        value: productList[i],
        child: ProductItem(
            // productList[i].id,
            //  productList[i].title,
            // productList[i].description,
            // productList[i].imageUrl
            ),
      ),
    );
  }
}
