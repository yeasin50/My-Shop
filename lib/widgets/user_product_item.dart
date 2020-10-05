import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductItem({Key key, this.title, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        // AssetImage for local img
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
