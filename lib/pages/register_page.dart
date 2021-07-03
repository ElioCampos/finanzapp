import 'package:finanzapp/utils/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DbHelper helper = DbHelper();
  TextEditingController userText = new TextEditingController();
  TextEditingController passText = new TextEditingController();
  TextEditingController fullNameText = new TextEditingController();
  TextEditingController emailText = new TextEditingController();
  TextEditingController repeatPassText = new TextEditingController();
  Map userBody = new Map();
  bool userValid = true;
  bool passValid = true;
  bool fullNameValid = true;
  bool emailValid = true;
  bool repeatPassValid = true;
  bool conditionsAccepted = false;
  @override
  Widget build(BuildContext context) {
    //var userId;
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
            padding: EdgeInsets.only(top: 50, left: 40, right: 40, bottom: 40),
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
                    primarySwatch: Colors.blue,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 20))),
                child: Container(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: emailText,
                        decoration: InputDecoration(
                          labelText: "Correo",
                          errorText: emailValid ? null : 'Ingrese su correo',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        controller: fullNameText,
                        decoration: InputDecoration(
                          labelText: "Nombre completo",
                          errorText: fullNameValid
                              ? null
                              : 'Ingrese su nombre completo',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: userText,
                        decoration: InputDecoration(
                          labelText: "Usuario",
                          errorText: userValid ? null : 'Ingrese su usuario',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: passText,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          errorText: passValid ? null : 'Ingrese su contraseña',
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      TextFormField(
                        controller: repeatPassText,
                        decoration: InputDecoration(
                          labelText: "Repita contraseña",
                          errorText: repeatPassValid
                              ? null
                              : 'Las contraseñas no coinciden',
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.blue,
                            value: conditionsAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                conditionsAccepted = value!;
                              });
                            },
                          ),
                          Text(
                            'Acepto los términos y condiciones',
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      userText.text.isNotEmpty
                          ? userValid = true
                          : userValid = false;
                      passText.text.isNotEmpty
                          ? passValid = true
                          : passValid = false;
                      fullNameText.text.isNotEmpty
                          ? fullNameValid = true
                          : fullNameValid = false;
                      emailText.text.isNotEmpty
                          ? emailValid = true
                          : emailValid = false;
                      repeatPassText.text == passText.text
                          ? repeatPassValid = true
                          : repeatPassValid = false;
                    });
                    if (conditionsAccepted &&
                        userValid &&
                        passValid &&
                        fullNameValid &&
                        emailValid &&
                        repeatPassValid) {
                      await helper.registerUser(userText.text, passText.text, emailText.text, fullNameText.text);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(500, 50)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                    shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    )),
                  ),
                  child: const Text('Registrar'),
                ),
              ),
              Divider(),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: '¿Ya tienes una cuenta? ¡Inicia sesión!',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, 'login');
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
