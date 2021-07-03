import 'package:finanzapp/pages/add_letter.dart';
import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/finance_math.dart';
import 'package:finanzapp/utils/stylish.dart';
import 'package:flutter/material.dart';

class LetterDetails extends StatefulWidget {
  final int letterId;
  const LetterDetails({Key? key, required this.letterId}) : super(key: key);

  @override
  _LetterDetailsState createState() => _LetterDetailsState();
}

class _LetterDetailsState extends State<LetterDetails> {
  DbHelper helper = DbHelper();
  List<dynamic> letter = [{}];
  List<dynamic> wallet = [{}];
  var fechaGiro = DateTime.now();
  var fechaVenc = DateTime.now();
  var fechaDesc = DateTime.now();
  var valorNominal = 0.0;
  var tasaEfec = 0.0;
  var gastosIni = 0.0;
  var gastosFin = 0.0;
  var data;
  var tcea = 0.0;
  var valorRecibir = 0.0;
  var valorEntregar = 0.0;

  Future getData() async {
    await helper.openDb();
    letter = await helper.getLetterById(widget.letterId);
    wallet = await helper.getWalletById(letter[0]['walletId']);
    setState(() {
      letter = letter;
      wallet = wallet;
      fechaGiro = DateTime.parse(letter[0]['fechaGiro'].toString());
      fechaVenc = DateTime.parse(letter[0]['fechaVenc'].toString());
      fechaDesc = DateTime.parse(wallet[0]['fechaDesc'].toString());
      valorNominal = letter[0]['valNom'] + .0;
      tasaEfec = wallet[0]['tasaEfec'] + .0;
      gastosIni = wallet[0]['gastosInic'] + .0;
      gastosFin = wallet[0]['gastosFin'] + .0;
    });
  }

  void makeOperation() {
    data = letterOperation(
        fechaVenc, fechaDesc, tasaEfec, valorNominal, gastosIni, gastosFin);
    tcea = roundDouble(data[0], 5);
    valorRecibir = roundDouble(data[1], 2);
    valorEntregar = roundDouble(data[2], 2);
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
          title: Text('Detalles de letra'),
          backgroundColor: Colors.green[300],
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLetter(
                        walletId: wallet[0]['id'],
                        isEditing: true,
                        letterId: widget.letterId),
                  ),
                );
              },
            ),
          ]),
      body: _letterDetails(),
    );
  }

  Widget _letterDetails() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20.0),
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
                child: stylish("Valor nominal", 20, 1),
              ),
            ),
            Divider(),
            Center(
                child: Text(
              "S/. $valorNominal",
              style: TextStyle(fontSize: 25),
            )),
            Divider(),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: stylish("Fecha de giro", 20, 1),
              ),
            ),
            Divider(),
            Center(
                child: Text(
              "${readDatefromString(letter[0]['fechaGiro'])}",
              style: TextStyle(fontSize: 25),
            )),
            Divider(),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: stylish("Fecha de vencimiento", 20, 1),
              ),
            ),
            Divider(),
            Center(
                child: Text(
              "${readDatefromString(letter[0]['fechaVenc'])}",
              style: TextStyle(fontSize: 25),
            )),
            Divider(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  setState(() {
                    makeOperation();
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child:
                                    stylish("Valor a recibir por letra", 20, 1),
                              ),
                              Divider(),
                              Text(
                                "S/. $valorRecibir",
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: stylish(
                                    "Valor a entregar por letra", 20, 1),
                              ),
                              Divider(),
                              Text(
                                "S/. ${-valorEntregar}",
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: stylish("TCEA de la letra", 20, 1),
                              ),
                              Divider(),
                              Text(
                                "$tcea%",
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
                child: Text("Calcular valores de letra"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
