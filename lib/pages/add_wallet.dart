import 'package:flutter/material.dart';
import 'package:finanzapp/utils/dbhelper.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({ Key? key }) : super(key: key);

  @override
  _AddWalletState createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  DbHelper helper = DbHelper();
  DateTime selectedDate = DateTime.now();
  TextEditingController tasaController = TextEditingController();
  TextEditingController gastosIniController = TextEditingController();
  TextEditingController gastosFinController = TextEditingController();
  TextEditingController fechaDescController = TextEditingController();
  double tasa = 0.0;
  double gastosIni = 0.0;
  double gastosFin = 0.0;
  var fechaDesc;

  // FocusNode focus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir nueva cartera'),
        backgroundColor: Colors.green[300],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.green,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                labelText: 'Introduzca la tasa efectiva anual compensatoria',
                // labelStyle: TextStyle(color: Colors.green),
                hintText: 'TEA compensatoria',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
              ),
              keyboardType: TextInputType.number,
              controller: tasaController,
            ),
            Divider(),
            TextField(
              cursorColor: Colors.green,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                labelText: 'Introduzca gastos iniciales totales',
                // labelStyle: TextStyle(color: Colors.green),
                hintText: 'Gastos iniciales',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
              ),
              keyboardType: TextInputType.number,
              controller: gastosIniController,
            ),
            Divider(),
            TextField(
              cursorColor: Colors.green,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                labelText: 'Introduzca gastos finales totales',
                // labelStyle: TextStyle(color: Colors.green),
                hintText: 'Gastos finales',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
              ),
              keyboardType: TextInputType.number,
              controller: gastosFinController,
            ),
            Divider(),
            Text("Fecha de descuento"),
            Divider(),
            TextField(
              focusNode: AlwaysDisabledFocusNode(),
              cursorColor: Colors.green,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                labelText: "${selectedDate.toLocal()}".split(' ')[0],
                // labelStyle: TextStyle(color: Colors.green),
                // hintText: 'Gastos finales',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
                suffixIcon: IconButton(
                  color: Colors.green,
                  onPressed: () => _selectDate(context),
                  icon: Icon(Icons.date_range))
              ),
              keyboardType: TextInputType.number,
              controller: fechaDescController,
            ),
            Divider(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green),
              onPressed: () async {
                tasa = double.parse(tasaController.text);
                gastosIni = double.parse(gastosIniController.text);
                gastosFin = double.parse(gastosFinController.text);
                fechaDesc = "${selectedDate.toLocal()}".split(' ')[0];
                await helper.insertWallet(tasa, fechaDesc, gastosIni, gastosFin);
                Navigator.pop(context);
                Navigator.pushNamed(context, 'wallets');
                // print('INSERT INTO wallets VALUES (2, $tasa, "$fechaDesc", $gastosIni, $gastosFin)');
              },
              child: Text('Añadir cartera'),
              // print('INSERT INTO wallets VALUES (${lastId+1}, $tasa, "$dateString", $gastosIni, $gastosFin)');
            ),
          ],
        )
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       Text("${selectedDate.toLocal()}".split(' ')[0]),
      //       SizedBox(height: 20.0,),
      //       ElevatedButton(
      //         onPressed: () => _selectDate(context),
      //         child: Text('Select date'),
      //         // print('INSERT INTO wallets VALUES (${lastId+1}, $tasa, "$dateString", $gastosIni, $gastosFin)');
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}