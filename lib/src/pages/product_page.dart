import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formularios_bloc/src/bloc/provider.dart';
import 'package:formularios_bloc/src/models/producto_model.dart';
import 'package:formularios_bloc/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  static final String routeName = "product_page";

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // final productoProider = new ProductosProvider();
   ProductosBloc productoBloc;


  File foto;

  ProductoModel producto = new ProductoModel();

  bool _guardando = false;

  @override
  Widget build(BuildContext context) {

    // una forma de recibir parametros
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    productoBloc = Provider.productosBloc(context);

    if(prodData != null) {
      producto = prodData;
    }
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () => _seleccionarFoto(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _seleccionarFoto(ImageSource.camera),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(context),
                _crearBoton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value){
        if(value.length < 3){
          return 'Ingrese el nombre del producto';
        }else{
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }else{
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: (!_guardando) ?  _submit : null,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  void _submit() async {

    if(!formKey.currentState.validate()) return;

    formKey.currentState.save();

    

    setState(() { _guardando = true; });

    if(foto != null){
     producto.fotoUrl =  await productoBloc.subirFoto(foto);
    }

    if(producto.id != null){
      productoBloc.editarProducto(producto);
      // productoProider.editarProducto(producto);
    }else{
      productoBloc.agregarProducto(producto);
      
    }

    // setState(() { _guardando = false; });
      _snakbar('Registro guardado');
      // para volver la pantalla
      Navigator.pop(context);

  }

  Widget _crearDisponible(BuildContext context) {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Theme.of(context).primaryColor,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );
  }

  void _snakbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto(){
    if(producto.fotoUrl != null){
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.contain,
        height: 300.0,
      );
    }else{
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png' ),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _seleccionarFoto(ImageSource imageSource) async {

    // final _picker = ImagePicker();
    foto = await ImagePicker.pickImage(source: imageSource);

    if(foto != null){

      producto.fotoUrl = null;

    }

    setState(() {
      
    });
  }

}
