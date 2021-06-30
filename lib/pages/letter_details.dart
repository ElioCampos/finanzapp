import 'package:finanzapp/utils/dbhelper.dart';
import 'package:finanzapp/utils/finance_math.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';


class LetterDetails extends StatefulWidget {
  final int letterId;
  const LetterDetails({ Key? key, required this.letterId}) : super(key: key);
  
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
        valorNominal = letter[0]['valNom']+.0;
        tasaEfec = wallet[0]['tasaEfec']+.0;
        gastosIni = wallet[0]['gastosInic']+.0;
        gastosFin = wallet[0]['gastosFin']+.0;
      });
      // print("FECHA GIRO: " + letter[0]['fechaGiro'].toString());
      // var a = DateTime.parse(letter[0]['fechaGiro'].toString());
      // print(a);
    }

  void makeOperation() {
    data = letterOperation(fechaVenc, fechaDesc, tasaEfec, valorNominal, gastosIni, gastosFin);
    tcea = roundDouble(data[0],5);
    valorRecibir = roundDouble(data[1],2);
    valorEntregar = roundDouble(data[2],2);
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
      ),
      body: _letterDetails(),
    );
  }

  Widget _letterDetails() {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: ListView(
        children: [
          Text('Fecha de giro: ' + letter[0]['fechaGiro'].toString()),
          Divider(),
          Text('Fecha de vencimiento: ' + letter[0]['fechaVenc'].toString()),
          Divider(),
          Text('Fecha de descuento: ' + wallet[0]['fechaDesc'].toString()),
          Divider(),
          Text('Valor nominal: $valorNominal'),
          Divider(),
          Text('Tasa efectiva: $tasaEfec'),
          Divider(),
          Text('Gastos iniciales totales: $gastosIni'),
          Divider(),
          Text('Gastos finales totales: $gastosFin'),
          Divider(),
          TextButton(
            onPressed: (){
              setState(() {
                makeOperation();
              });
            },
            child: Text("Hacer operación")
          ),
          Divider(),
          Text('Valor total a recibir: $valorRecibir'),
          Divider(),
          Text('Valor total a entregar: $valorEntregar'),
          Divider(),
          Text('TCEA: $tcea%'),
        ],
      ),
    );
  }

  
}


// DateTime selectedDate = DateTime.now();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text("${selectedDate.toLocal()}".split(' ')[0]),
//             SizedBox(height: 20.0,),
//             RaisedButton(
//               onPressed: () => _selectDate(context),
//               child: Text('Select date'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }