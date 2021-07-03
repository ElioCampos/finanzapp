import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  final int userId;
  const MyDrawer({ Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, 'home', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.wallet_travel),
            title: Text('Carteras'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'wallets', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Opciones'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'options', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'login')
            },
          ),
        ],
      ),
    );
  }
}