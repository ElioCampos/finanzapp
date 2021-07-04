import 'package:finanzapp/pages/add_letter.dart';
import 'package:finanzapp/pages/add_wallet.dart';
import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/finance_math.dart';
import 'package:finanzapp/utils/stylish.dart';
import 'package:flutter/material.dart';

class WalletDetails extends StatefulWidget {
  final int walletId;
  const WalletDetails({Key? key, required this.walletId}) : super(key: key);

  @override
  _WalletDetailsState createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails> {
  DbHelper helper = DbHelper();
  var letterList;
  var wallet;
  var tceaCartera;
  String tipoMoneda = '';
  List valoresRecibir = [];
  var valorTotalRecibir = 0.0;
  bool isLoaded = false;

  Future getData() async {
    letterList = await helper.getLettersByWalletId(widget.walletId);
    wallet = await helper.getWalletById(widget.walletId);
    setState(() {
      letterList = letterList;
    });
    if (wallet[0]['tipoMoneda'] == 0) {
      tipoMoneda = "S/.";
    } else {
      tipoMoneda = "\$";
    }
    isLoaded = true;
  }

  List<dynamic> makeOperation() {
    List datosTCEA = [];
    var data;
    var result;
    var fechaVenc;
    var fechaDesc = DateTime.parse(wallet[0]['fechaDesc'].toString());
    var suma = 0.0;
    var retenciones = 0.0;
    for (var letter in letterList) {
      fechaVenc = DateTime.parse(letter['fechaVenc'].toString());
      data = letterOperation(
          fechaVenc,
          fechaDesc,
          wallet[0]['tasaEfec'] + .0,
          letter['valNom'] + .0,
          wallet[0]['gastosInic'] + .0,
          wallet[0]['gastosFin'] + .0,letter['retencion'] + .0);
      retenciones += letter['retencion'] + .0;
      print("OEEEEEE");
      print(data);
      suma += data['valorRecibir'];
      datosTCEA.add([-data['valorEntregar'], data['numDias']]);
    }
    print(datosTCEA);
    print(retenciones);
    result = tceaWallet(datosTCEA, suma, 0);
    return [roundDouble(suma, 2), roundDouble(result * 100, 5)];
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddWallet(
                            userId: wallet[0]['userId'],
                            isEditing: true,
                            walletId: wallet[0]['id'],
                          )));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLetter(
                      walletId: wallet[0]['id'], isEditing: false, letterId: 0),
                ),
              );
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
                    child: Text(
                      "Parece que aún no tienes letras en esta cartera. ¡Puedes añadir una!",
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              _letterList(),
              Divider(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    setState(() {
                      var operation = makeOperation();
                      valorTotalRecibir = operation[0];
                      tceaCartera = operation[1];
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child:
                                      stylish("Valor total a recibir", 20, 1),
                                ),
                                Divider(),
                                Text(
                                  "$tipoMoneda $valorTotalRecibir",
                                  style: TextStyle(fontSize: 30),
                                ),
                                Divider(),
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: stylish("TCEA de la cartera", 20, 1),
                                ),
                                Divider(),
                                Text(
                                  "$tceaCartera%",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  child: Text("Calcular valores de cartera"),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _letterList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: (letterList != null) ? letterList.length : 0,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          title: Text("Letra " + letterList[i]['id'].toString()),
          subtitle:
              Text("Valor nominal: $tipoMoneda " + letterList[i]['valNom'].toString()),
          leading: CircleAvatar(
            backgroundImage: AssetImage('lib/images/letra.jpg'),
            backgroundColor: Colors.blue,
          ),
          onTap: () {
            // Navigator.pop(context),
            Navigator.pushNamed(context, 'letter_details',
                arguments: letterList[i]['id']);
          },
        );
      },
    );
  }
}
