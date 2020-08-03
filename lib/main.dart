import 'package:flutter/material.dart';
import 'package:formularios_bloc/src/bloc/provider.dart';
import 'package:formularios_bloc/src/pages/home_page.dart';
import 'package:formularios_bloc/src/pages/login_page.dart';
import 'package:formularios_bloc/src/pages/product_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formularios_bloc',
      initialRoute: HomePage.routeName,
      routes: {
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        ProductPage.routeName: (BuildContext context) => ProductPage(),
      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    ));
  }
}
