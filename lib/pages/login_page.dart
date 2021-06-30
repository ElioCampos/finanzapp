// import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:easystory/src/endpoints/endpoints.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userText = new TextEditingController();
  TextEditingController passText = new TextEditingController();
  List dataUsers = [];
  bool userExists = false;
  bool userValid = true;
  bool passValid = true;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var userId;
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage('lib/images/fondo.png'),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          ListView(
            padding: EdgeInsets.only(top: 210, left:40, right:40, bottom:40),
            children: <Widget>[
              Image.asset(
                'lib/images/piggy.png',
                height: 100,
                width: 100,
              ),
              Form(
                  child: Theme(
                data: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.teal,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 20))),
                child: Container(
                  padding: EdgeInsets.only(bottom:40.0, top:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: userText,
                        decoration: InputDecoration(
                          labelText: "Ingresa usuario",
                          errorText: userValid ? null : 'El usuario no existe',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        controller: passText,
                        decoration: InputDecoration(
                          labelText: "Ingresa contraseña",
                          // errorText:
                          //     passValid ? 'La contraseña es incorrecta' : 'Ingrese una contraseña',
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              )),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // for (var cosa in dataUsers) {
                    //   if (cosa['username'] == userText.text) {
                    //     userExists = true;
                    //     userId = cosa['id'];
                    //   }
                    // }
                    setState(() {
                    //   userExists ? userValid = true : userValid = false;
                      // passText.text.isNotEmpty
                      //     ? passValid = true
                      //     : passValid = false;
                    });
                    // if (userValid && passValid) {
                      Navigator.pushNamed(context, 'home');
                    // }
                  },
                  style: ButtonStyle(                                 
                    minimumSize: MaterialStateProperty.all(Size(400, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical:10,horizontal:10)), 
                    shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          )),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
              ),
              Divider(),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: '¿No tienes una cuenta? ¡Regístrate!',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, 'register');
                      },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
