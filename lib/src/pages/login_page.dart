import 'package:flutter/material.dart';
import 'package:formularios_bloc/src/bloc/provider.dart';
import 'package:formularios_bloc/src/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  static final String routeName = "login_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        _fondoHeader(context),
        _loginForm(context),
      ]),
    );
  }

  Widget _fondoHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final radiente = Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0)
        ],
      )),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(children: <Widget>[
      radiente,
      Positioned(
        child: circulo,
        top: 100.0,
        right: 50.0,
      ),
      Positioned(
        child: circulo,
        bottom: 10.0,
      ),
      circulo,
      Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.person_pin_circle,
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            Text(
              'Sebastian Acuña',
              style: TextStyle(fontSize: 30.0, color: Colors.white),
            ),
          ],
        ),
      )
    ]);
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            // height: 180.0,
            width: size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 10))
                ]),
            padding: EdgeInsets.symmetric(vertical: 20.0),
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    'Ingreso',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60.0,
                ),
                _crearEmail(context, bloc),
                SizedBox(
                  height: 20.0,
                ),
                _crearPass(context, bloc),
                SizedBox(
                  height: 20.0,
                ),
                _crearBoton(context, bloc)
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
            width: double.infinity,
          ),
          Text(
            '¿Olvido la Contraseña?',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _crearBoton(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (context, snapshot) {
          return RaisedButton(
            onPressed: (snapshot.hasData) ? () => _login(bloc, context) : null,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
              child: Text(
                'Ingresar',
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          );
        });
  }

  Widget _crearEmail(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo Electronico',
              hintText: 'Ejemplo@correo.com',
              counterText: snapshot.data,
              errorText: snapshot.error,
              icon: Icon(Icons.alternate_email,
                  color: Theme.of(context).primaryColor),
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPass(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Contraseña',
                icon: Icon(
                  Icons.lock_outline,
                  size: 25.0,
                  color: Theme.of(context).primaryColor,
                ),
                counterText: snapshot.data,
                errorText: (snapshot.hasError) ? snapshot.error : null),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.routeName);
    // print('email : ${bloc.email}');
  }
}
