import 'package:flutter/material.dart';
// import 'package:formularios_bloc/src/bloc/provider.dart';
import 'package:formularios_bloc/src/models/producto_model.dart';
import 'package:formularios_bloc/src/pages/product_page.dart';
import 'package:formularios_bloc/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {
  static final String routeName = "home_page";

  final productosProvider  = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Formularios Bloc'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, ProductPage.routeName),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _crearListado(),
    );
  }

 Widget  _crearListado() {

   return FutureBuilder(
     future: productosProvider.cargarProductos(),
     builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
       if(snapshot.hasData){
         final productos = snapshot.data;
         return ListView.builder(
           itemCount: productos.length ,
           itemBuilder: (context, i) => _crearItem(productos[i], context),
         );
       }else{
         return Center(child:CircularProgressIndicator());
       }
     },
   );
 }

 Widget _crearItem(ProductoModel producto, BuildContext context){
  //  dismissible es para la animacion de borrar
   return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion){
        productosProvider.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null) 
            ? Image(image: AssetImage('assets/no-image.png')) 
            : FadeInImage(
              image:NetworkImage(producto.fotoUrl),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover),

               ListTile(
                title: Text('${producto.titulo} - ${producto.valor }'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, ProductPage.routeName, arguments: producto),

              ),
          ],
        ),
      )
   );

  
 }



}
