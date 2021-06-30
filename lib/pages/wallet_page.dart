// import 'package:finanzapp/models/wallets.dart';
import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/drawer.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  
  DbHelper helper = DbHelper();
  var walletList;  
  @override
  void initState() {
    super.initState();
    showData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de carteras'),
        backgroundColor: Colors.green[300],
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,  
            ),
            onPressed: () {
              // setState(() {
                
              // });
              Navigator.pushNamed(context, 'add_wallet');
            },
          )
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
             _wallets(),
          ],
        ),
      ),
    );
  }

  Widget _wallets() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: (walletList != null)? walletList.length : 0,
      itemBuilder: (BuildContext context, i){
        return ListTile(
          title: Text("Cartera " + walletList[i]['id'].toString()),
          subtitle: Text("Fecha descuento: " + walletList[i]['fechaDesc'].toString()),
          leading: CircleAvatar(
            backgroundImage: AssetImage('lib/images/wallet.jpg'),
            backgroundColor: Colors.blue,
          ),
          onTap: (){
            // Navigator.pop(context),
            Navigator.pushNamed(context, 'wallet_details', arguments: walletList[i]['id']);
          },
        );
      },
    );
  }

  Future showData() async {
    await helper.openDb();
    walletList = await helper.getWallets();
    setState(() {
      walletList = walletList;
    });
  }
}