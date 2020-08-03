

// encargado de hacer relaciones directas con bd

import 'dart:convert';

import 'package:formularios_bloc/src/models/producto_model.dart';
import 'package:http/http.dart' as http;

class ProductosProvider{

  final String _url = 'https://fluttervarios-6729d.firebaseio.com';

  // get, put , post y delete gracias al rest api 

  Future<bool> crearProducto(ProductoModel producto) async {

    final url = '$_url/productos.json';


    final response = await http.post(url, body: productoModelToJson(producto));


    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json';
    final List<ProductoModel> productos = new List();

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if(decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);
    });


    return  productos;

  }
  
}