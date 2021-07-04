import 'package:finanzapp/utils/drawer.dart';
import 'package:finanzapp/utils/stylish.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  final int userId;
  const HelpPage({Key? key, required this.userId}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda'),
        backgroundColor: Colors.green[300],
      ),
      drawer: MyDrawer(
        userId: widget.userId,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 70, 30, 0),
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: stylish("¿Necesitas ayuda?", 20, 1),
                ),
              ),
              Divider(),
              Center(
                child: InkWell(
                    child: Center(child: Text("¡Revisa nuestra guía de usuario!", style: TextStyle(fontSize: 30, color: Colors.blue), textAlign: TextAlign.center,),),
                    onTap: () => launch(
                        'https://github.com/ElioCampos/finanzapp/blob/master/Gu%C3%ADa%20de%20uso%20-%20FinanzApp.pdf')),
              ),
            ],
          ),
        ),
      ),
      // child: InkWell(

      //     onTap: () => launch('https://github.com/ElioCampos/finanzapp/blob/master/Gu%C3%ADa%20de%20uso%20-%20FinanzApp.pdf')
      // ),
    );
  }
}
