import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/finance_math.dart';
import 'package:flutter/material.dart';

class WalletDetails extends StatefulWidget {
  final int walletId;
  const WalletDetails({ Key? key, required this.walletId}) : super(key: key);

  @override
  _WalletDetailsState createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails> {
  DbHelper helper = DbHelper();
  var letterList;
  var wallet;
  List valoresRecibir = [];
  var valorTotalRecibir = 0.0;
  bool isLoaded = false;
  
  Future getData() async{
    letterList = await helper.getLettersByWalletId(widget.walletId);
    wallet = await helper.getWalletById(widget.walletId);
    setState(() {
      letterList = letterList;
    });
    isLoaded = true;
  }

  double makeOperation() {
    var data;
    var fechaVenc; 
    var fechaDesc = DateTime.parse(wallet[0]['fechaDesc'].toString());
    var suma = 0.0;
    for (var letter in letterList) {
        fechaVenc = DateTime.parse(letter['fechaVenc'].toString());
        data = letterOperation(fechaVenc, fechaDesc, wallet[0]['tasaEfec']+.0, letter['valNom']+.0, wallet[0]['gastosInic']+.0, wallet[0]['gastosFin']+.0);
        suma += data[1];
      }
    return roundDouble(suma,2);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letras de cartera'),
        backgroundColor: Colors.green[300],
        actions: <Widget>[
           IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,  
            ),
            onPressed: () {
              
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,  
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'add_letter', arguments: widget.walletId);
            },
          )
        ],
      ),
      body: _lettersContent(),
    );
  }

  Widget _lettersContent() {
    if (isLoaded) {
      if (letterList.length == 0) {
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
                      image: AssetImage('lib/images/emptywallet.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Divider(),
                Container(
                  width: 400,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: Text("Parece que aún no tienes letras en esta cartera. ¡Puedes añadir una!",
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
              ],
            ),
       );
      }
      else {
       return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
             _letterList(),
             Divider(),
             Center(
               child: TextButton(
                 onPressed: () {
                   setState(() {
                     valorTotalRecibir = makeOperation();
                   });
                 },
                 child: Text("Hacer operación"),
                ),
              ),
              Divider(),
              Text('Valor total a recibir por la cartera: S/. $valorTotalRecibir'),
              // Divider(), 
              // Text('TCEA de la cartera: 0%'),
          ],
        ),
      );
      }
    }
    else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _letterList() {  
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: (letterList != null)? letterList.length : 0,
        itemBuilder: (BuildContext context, i){
          return ListTile(
            title: Text("Letra " + letterList[i]['id'].toString()),
            subtitle: Text("Valor nominal: S/. " + letterList[i]['valNom'].toString()),
            leading: CircleAvatar(
              backgroundImage: AssetImage('lib/images/letra.jpg'),
              backgroundColor: Colors.blue,
            ),
            onTap: (){
              // Navigator.pop(context),
              Navigator.pushNamed(context, 'letter_details', arguments: letterList[i]['id']);
            },
          );
        },
      );
  }
}
