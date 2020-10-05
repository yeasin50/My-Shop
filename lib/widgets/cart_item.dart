import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productID;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.productID, this.price, this.title, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {

        // confirm dismiss take future argument and ShowDialog return future 
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("Do you want remove from cart?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: ListTile(
            leading: CircleAvatar(
              radius: 27,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
