import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateManagement/providers/auth.dart';
import 'package:stateManagement/screens/edit_product_screen.dart';
import 'package:stateManagement/screens/order_screen.dart';
import './providers/cart_.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overView.dart';
import './screens/user_product_screen.dart';
import 'screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        // // FIXME It may need to change update-> create
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevPorducts) => Products(
            auth.token,
            auth.userId,
            prevPorducts == null ? [] : prevPorducts.items,
          ),
        ), // in v3 use builder instead of create

        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        // FIXME It may need to change update-> create
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrders) => Orders(
            auth.token,
            prevOrders.orders == null ? [] : prevOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, ch) => MaterialApp(
          title: "My Shop",
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductOverViewScreen() : AuthScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routename: (context) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
