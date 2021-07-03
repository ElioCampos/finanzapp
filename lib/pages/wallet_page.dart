import 'package:finanzapp/pages/add_wallet.dart';
import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/drawer.dart';
import 'package:finanzapp/utils/finance_math.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  final int userId;
  const WalletPage({Key? key, required this.userId}) : super(key: key);
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
               Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddWallet(userId: widget.userId, isEditing: false, walletId: 0,)));
            },
          )
        ],
      ),
      drawer: MyDrawer(userId: widget.userId,),
      body: _wallets(),
    );
  }

  Widget _wallets() {
    if (walletList.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/piggycry.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text("Parece que aún no tienes carteras. ¡Puedes añadir una!"),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (walletList != null) ? walletList.length : 0,
              itemBuilder: (BuildContext context, i) {
                return ListTile(
                  title: Text("Cartera " + walletList[i]['id'].toString()),
                  subtitle: Text("Fecha descuento: " +
                      readDatefromString(walletList[i]['fechaDesc'].toString())),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('lib/images/wallet.jpg'),
                    backgroundColor: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'wallet_details',
                        arguments: walletList[i]['id']);
                   
                  },
                );
              },
            )
          ],
        ),
      );
    }
  }

  Future showData() async {
    await helper.openDb();
    walletList = await helper.getWallets(widget.userId);
    setState(() {
      walletList = walletList;
    });
  }
}
