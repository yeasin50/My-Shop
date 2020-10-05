import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateManagement/providers/cart_.dart';
import 'package:stateManagement/providers/product.dart';
import 'package:stateManagement/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String description;
  // final String imageUrl;
  // const ProductItem(this.id, this.title, this.description, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    /// this will not listen hole product
    print('product Rebuild');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,

          /* consimer will listen only favorite changes 
            child of consumer used to assign as const
          */
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.favorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                  productId: product.id,
                  price: product.price,
                  title: product.title);

              //hiding overlap snackbar
              Scaffold.of(context).hideCurrentSnackBar();

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Added ${product.title} to cart!",
                  ),
                  duration: Duration(
                    seconds: 1,
                    milliseconds: 500,
                  ),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
