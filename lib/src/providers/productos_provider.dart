

// encargado de hacer relaciones directas con bd

import 'dart:convert';
import 'dart:io';

import 'package:formularios_bloc/src/models/producto_model.dart';
import 'package:formularios_bloc/src/preferences/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

import 'package:http_parser/http_parser.dart';

class ProductosProvider{

  final String _url = 'https://fluttervarios-6729d.firebaseio.com';

  final _prefs = new PreferenciasUsuario();

  // get, put , post y delete gracias al rest api 

  Future<bool> crearProducto(ProductoModel producto) async {

    final url = '$_url/productos.json?auth=${_prefs.token}';


    final response = await http.post(url, body: productoModelToJson(producto));


    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;

  }

  Future<bool> editarProducto(ProductoModel producto) async {

    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';


    final response = await http.put(url, body: productoModelToJson(producto));


    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;

  }




  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final List<ProductoModel> productos = new List();

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if(decodedData == null) return [];

    if(decodedData['error'] != null) return [];



    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);
    });


    return  productos;

  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }


  Future<String> subirImagen (File imagen) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dm74sragr/image/upload?upload_preset=umxsidms');

    // para saber tipo de archivo
    final mimeType = mime(imagen.path).split("/");

// request
    final imageUploadRequest = http.MultipartRequest('POST', url);
  // archivo
  final file = await http.MultipartFile.fromPath('file', imagen.path, contentType: MediaType(mimeType[0], mimeType[1]));

// adjuntar archivos, para varios se repite linea
  imageUploadRequest.files.add(file);

  final streamResponse = await imageUploadRequest.send();

// respuesta conocida
  final resp = await http.Response.fromStream(streamResponse);

  if(resp.statusCode != 200 && resp.statusCode != 201){
    print('Algo salio mal');
    print(resp.body);
    return null;
  }

  final respData = json.decode(resp.body);

  return respData['secure_url'];

  }
  
}