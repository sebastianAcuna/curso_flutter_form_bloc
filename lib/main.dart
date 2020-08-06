import 'package:flutter/material.dart';
import 'package:formularios_bloc/src/bloc/provider.dart';
import 'package:formularios_bloc/src/pages/home_page.dart';
import 'package:formularios_bloc/src/pages/login_page.dart';
import 'package:formularios_bloc/src/pages/product_page.dart';
import 'package:formularios_bloc/src/pages/registro_page.dart';
import 'package:formularios_bloc/src/preferences/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    print(prefs?.token);

    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formularios_bloc',
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        ProductPage.routeName: (BuildContext context) => ProductPage(),
        RegistroPage.routeName : (BuildContext context) => RegistroPage(),
      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    ));
  }
}
