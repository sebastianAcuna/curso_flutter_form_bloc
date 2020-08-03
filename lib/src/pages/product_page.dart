import 'package:flutter/material.dart';
import 'package:formularios_bloc/src/models/producto_model.dart';
import 'package:formularios_bloc/src/providers/productos_provider.dart';
import 'package:formularios_bloc/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  static final String routeName = "product_page";

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  ProductoModel producto = new ProductoModel();
  final productoProider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
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
      onPressed: _submit,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  void _submit(){

    if(!formKey.currentState.validate()) return;

    formKey.currentState.save();

    print('TOdo OK');

    
    productoProider.crearProducto(producto);

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
}
