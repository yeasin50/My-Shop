import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateManagement/providers/cart_.dart';
import 'package:stateManagement/providers/products_provider.dart';
import 'package:stateManagement/screens/cart_screen.dart';
import 'package:stateManagement/screens/product_details_screen.dart';
import 'package:stateManagement/screens/products_overView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),// in v3 use builder instead of create
        ),
      
        ChangeNotifierProvider(
          create:(ctx)=> Cart(),
        ),
      ],
      child: MaterialApp(
        title: "My Shop",
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverViewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName : (ctx) => CartScreen(),
        },
      ),
    );
  }
}
