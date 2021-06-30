import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/drawer.dart';
import 'package:finanzapp/utils/stylish.dart';
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
          child: stylish('¡Bienvenido a FinanzApp!', 30, 3)
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
                  child: Center(child: stylish('Agregar cartera', 20, 2),)
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
                  child: Center(child: stylish('Visualizar carteras', 20, 2),)
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

  
}