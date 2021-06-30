import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  // final Object argument;
  // const MyDrawer({ Key? key, required this.argument }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var userId = argument;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(            
            child: Image(
              image: AssetImage('lib/images/logo.png'),
            ),
            decoration: BoxDecoration(
                color: Colors.green[300],
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('lib/images/finance.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'home')
            },
          ),
          ListTile(
            leading: Icon(Icons.wallet_travel),
            title: Text('Carteras'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'wallets')
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Opciones'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'options')
            },
          ),
        ],
      ),
    );
  }
}