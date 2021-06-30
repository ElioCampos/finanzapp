import 'package:flutter/material.dart';
import 'package:finanzapp/utils/dbhelper.dart';

class AddLetter extends StatefulWidget {
  final int walletId;
  const AddLetter({ Key? key, required this.walletId}) : super(key: key);

  @override
  _AddLetterState createState() => _AddLetterState();
}

class _AddLetterState extends State<AddLetter> {
  DbHelper helper = DbHelper();
  DateTime dateGiro = DateTime.now();
  DateTime dateVenc = DateTime.now();
  TextEditingController valNomController = TextEditingController();
  TextEditingController retencionController = TextEditingController();
  TextEditingController fechaVencController = TextEditingController();
  TextEditingController fechaGiroController = TextEditingController();
  double valorNominal = 0.0;
  double retencion = 0.0;
  double gastosFin = 0.0;
  var fechaGiro;
  var fechaVenc;
// print('INSERT INTO letters VALUES (${lastId+1}, $walletId, "2021-04-11", "2021-07-10", $valorNom, $retencion)');
  // FocusNode focus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir nueva letra'),
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
                labelText: 'Introduzca el valor nominal de la letra (S/.)',
                // labelStyle: TextStyle(color: Colors.green),
                hintText: 'Valor nominal',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
              ),
              keyboardType: TextInputType.number,
              controller: valNomController,
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
                labelText: 'Introduzca la cantidad de retención',
                // labelStyle: TextStyle(color: Colors.green),
                hintText: 'Retención',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
              ),
              keyboardType: TextInputType.number,
              controller: retencionController,
            ),
            Divider(),
            Text("Fecha de giro de la letra"),
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
                labelText: "${dateGiro.toLocal()}".split(' ')[0],
                // labelStyle: TextStyle(color: Colors.green),
                // hintText: 'Gastos finales',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
                // errorText: 'La fecha de giro es mayor a la de vencimiento.',
                suffixIcon: IconButton(
                  color: Colors.green,
                  onPressed: () => _selectDate(context, 'giro'),
                  icon: Icon(Icons.date_range))
              ),
              keyboardType: TextInputType.number,
              controller: fechaGiroController,
            ),
            Divider(),
            Text("Fecha de vencimiento de la letra"),
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
                labelText: "${dateVenc.toLocal()}".split(' ')[0],
                // labelStyle: TextStyle(color: Colors.green),
                // hintText: 'Gastos finales',
                // errorText: isValid ? null : 'La publicación no puede estar vacía',
                // errorText: 'La fecha de vencimiento es menor a la de descuento.',
                suffixIcon: IconButton(
                  color: Colors.green,
                  onPressed: () => _selectDate(context, 'venc'),
                  icon: Icon(Icons.date_range))
              ),
              keyboardType: TextInputType.number,
              controller: fechaVencController,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green),
              onPressed: () async {
                valorNominal = double.parse(valNomController.text);
                retencion = double.parse(retencionController.text);
                // gastosFin = double.parse(gastosFinController.text);
                fechaGiro = "${dateGiro.toLocal()}".split(' ')[0];
                fechaVenc = "${dateVenc.toLocal()}".split(' ')[0];
                // await helper.insertWallet(valorNominal, fechaGiro, retencion, gastosFin);
                await helper.insertLetter(widget.walletId, fechaGiro, fechaVenc, valorNominal, retencion);
                Navigator.pop(context);
                // print('INSERT INTO wallets VALUES (2, $valorNominal, "$fechaGiro", $retencion, $gastosFin)');
              },
              child: Text('Añadir letra'),
              // print('INSERT INTO wallets VALUES (${lastId+1}, $valorNominal, "$dateString", $retencion, $gastosFin)');
            ),
          ],
        )
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String data) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: data == 'giro' ? dateGiro : dateVenc,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (data == 'giro') {
      if (picked != null && picked != dateGiro)
        setState(() {
          dateGiro = picked;
        });
    }
    else {
      if (picked != null && picked != dateVenc)
        setState(() {
          dateVenc = picked;
        });
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}