import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:finanzapp/utils/dbhelper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DbHelper helper = DbHelper();
  TextEditingController userText = new TextEditingController();
  TextEditingController passText = new TextEditingController();
  List dataUsers = [];
  bool isPressed = false;
  bool userExists = false;
  bool passExists = false;
  bool userValid = false;
  bool passValid = false;
  int userId = 0;
  String userPassword = '';
  bool usersLoaded = false;

  Future getData() async {
    await helper.openDb();
    dataUsers = await helper.getAllUsers();
    setState(() {
      dataUsers = dataUsers;
    });
    usersLoaded = true;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.only(top: 210, left: 40, right: 40, bottom: 40),
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
                  padding: EdgeInsets.only(bottom: 40.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: userText,
                        decoration: InputDecoration(
                            labelText: "Ingresa usuario",
                            errorText: _errorUser(userText.text)),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        controller: passText,
                        decoration: InputDecoration(
                            labelText: "Ingresa contraseña",
                            errorText: _errorPassword(passText.text)),
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
                    
                    setState(() {
                      userValid = false;
                      passValid = false;
                      isPressed = true;
                      _validateData();
                    });
                    if (userValid && passValid) {
                      Navigator.pushNamed(context, 'home', arguments: userId);
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(400, 50)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
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

  void _validateData() {
    userExists = false;
    passExists = false;
    for (var user in dataUsers) {
      if (user['username'] == userText.text) {
        userExists = true;
        userId = user['id'];
        userPassword = user['password'];
      }
      if (user['password'] == passText.text) {
        passExists = true;
      }
    }
    if (userExists){
      userValid = true;
      if (passText.text == userPassword){
        passValid = true;
      }
    }
  }

  String? _errorPassword(String passwordText) {
    if (isPressed) {
      if (userExists) {
        if (passwordText == '') {
          return "Introduzca una contraseña";
        } else {
          if (userPassword != passwordText) {
            return "La contraseña es incorrecta";
          }
        }
      }
    }
    return null;
  }

  String? _errorUser(String usernameText) {
    if (isPressed) {
      if (!userExists) {
        return "El usuario no existe";
      }
    }
    return null;
  }
}
