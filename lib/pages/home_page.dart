import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DbHelper helper = DbHelper();

  @override
  void initState() {
    super.initState();
    helper.openDb();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinanzApp'),
        backgroundColor: Colors.green[300],
      ),
      drawer: MyDrawer(),
      body: _homeInfo(),
    );
  }

  Widget _homeInfo() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Image(
            image: AssetImage('lib/images/home.png')
          )
        ),
        Center(
          child: _stylish('¡Bienvenido a FinanzApp!', 30, 3)
        ),
        Divider(),
        _options()
      ],
    );
  }

  Widget _options() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            elevation: 1.0,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            // margin: EdgeInsets.only(
            //     bottom: 2.0, top: 14.0, left: 15.0, right: 15.0),
            // elevation: 5,
            // margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Center(child: _stylish('Agregar cartera', 20, 2),)
                ),
                Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'add_wallet');
                    },
                    icon: Icon(Icons.add)
                  ),
                )
              ]
            ),
          ),
          Card(
            elevation: 1.0,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            // margin: EdgeInsets.only(
            //     bottom: 2.0, top: 14.0, left: 15.0, right: 15.0),
            shape: RoundedRectangleBorder(
              // side: BorderSide(
              //   color: Colors.grey.shade400,
              //   width: 2.0,
              // ),
              borderRadius: BorderRadius.circular(10),
            ),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // child: Center(child: Text("Visualizar carteras", textAlign: TextAlign.center)),
                  child: Center(child: _stylish('Visualizar carteras', 20, 2),)
                ),
                Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'wallets');
                    },
                    icon: Icon(Icons.remove_red_eye_outlined),
                    color: Colors.black,
                  ),
                )
              ]
            ),
          ),
        ]
      ),
    );
  }

  Widget _stylish(String stylish, double size, double stroke) {
    return Stack(
      children: <Widget>[
        Text(
          stylish,
          style: TextStyle(
            fontSize: size,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = stroke
              ..color = Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          stylish,
          style: TextStyle(
            fontSize: size,
            color: Colors.green[300],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}