import 'package:finanzapp/utils/finance_math.dart';
import 'package:finanzapp/utils/stylish.dart';
import 'package:flutter/material.dart';
import 'package:finanzapp/utils/dbhelper.dart';

class AddWallet extends StatefulWidget {
  final int userId;
  final bool isEditing;
  final int walletId;
  const AddWallet(
      {Key? key,
      required this.userId,
      required this.isEditing,
      required this.walletId})
      : super(key: key);

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
  var wallet;
  bool isPressed = false;
  double tasa = 0.0;
  double gastosIni = 0.0;
  double gastosFin = 0.0;
  var fechaDesc;
  bool tasaValid = false;
  bool gIniValid = false;
  bool gFinValid = false;

  Future getData() async {
    await helper.openDb();
    wallet = await helper.getWalletById(widget.walletId);
    setState(() {
      wallet = wallet;
      tasaController.text = wallet[0]['tasaEfec'].toString();
      gastosIniController.text = wallet[0]['gastosInic'].toString();
      gastosFinController.text = wallet[0]['gastosFin'].toString();
      selectedDate = DateTime.parse(wallet[0]['fechaDesc'].toString());
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userId);
    return Scaffold(
      appBar: AppBar(
        title: widget.isEditing
            ? Text('Editar cartera')
            : Text('Añadir nueva cartera'),
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
                  hintText: 'TEA compensatoria',
                  errorText: _errorTasa(tasaController.text),
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
                  hintText: 'Gastos iniciales',
                  errorText: _errorGIni(gastosIniController.text),
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
                    hintText: 'Gastos finales',
                    errorText: _errorGFin(gastosFinController.text)),
                keyboardType: TextInputType.number,
                controller: gastosFinController,
              ),
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
                  child: stylish("Fecha de descuento", 20, 1),
                ),
              ),
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
                    labelText: readableDate(selectedDate),
                    suffixIcon: IconButton(
                        color: Colors.green,
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.date_range))),
                keyboardType: TextInputType.number,
                controller: fechaDescController,
              ),
              Divider(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () async {
                  setState(() {
                    isPressed = true;
                    try {
                      tasa = double.parse(tasaController.text);
                      if (tasa <= 100) {
                        tasaValid = true;
                      } else {
                        tasaValid = false;
                      }
                    } catch (e) {
                      tasaValid = false;
                      print(e);
                    }
                    try {
                      gastosIni = double.parse(gastosIniController.text);
                      if (gastosIni <= 10000) {
                        gIniValid = true;
                      } else {
                        gIniValid = false;
                      }
                    } catch (e) {
                      tasaValid = false;
                      print(e);
                    }
                    try {
                      gastosFin = double.parse(gastosFinController.text);
                      if (gastosFin <= 10000) {
                        gFinValid = true;
                      } else {
                        gFinValid = false;
                      }
                    } catch (e) {
                      tasaValid = false;
                      print(e);
                    }
                    fechaDesc = "${selectedDate.toLocal()}".split(' ')[0];
                  });
                  print("$tasaValid, $gIniValid, $gFinValid");
                  if (tasaValid && gIniValid && gFinValid) {
                    if (widget.isEditing) {
                      await helper.updateWallet(widget.walletId, tasa,
                          fechaDesc, gastosIni, gastosFin);
                    } else {
                      await helper.insertWallet(
                          widget.userId, tasa, fechaDesc, gastosIni, gastosFin);
                    }
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'wallets',
                        arguments: widget.userId);
                  }
                },
                child: widget.isEditing
                    ? Text('Actualizar cartera')
                    : Text('Añadir cartera'),
              ),
              _deleteButton(),
            ],
          )),
    );
  }

  String? _errorTasa(String tasaText) {
    if (isPressed) {
      if (!tasaValid) {
        try {
          var tasaAux = double.parse(tasaText);
          if (tasaAux > 100) {
            return "No puede tener una tasa mayor a 100%";
          }
        } catch (e) {
          if (tasaText == '') {
            return "Introduzca un valor";
          } else {
            return "Solo se admiten números";
          }
        }
      }
    }
    return null;
  }

  String? _errorGIni(String gIniText) {
    if (isPressed) {
      if (!gIniValid) {
        try {
          var gIniAux = double.parse(gIniText);
          if (gIniAux > 10000) {
            return "Valores muy altos no son aceptados.";
          }
        } catch (e) {
          if (gIniText == '') {
            return "Introduzca un valor";
          } else {
            return "Solo se admiten números";
          }
        }
      }
    }
    return null;
  }

  String? _errorGFin(String gFinText) {
    if (isPressed) {
      if (!gFinValid) {
        try {
          var gIniAux = double.parse(gFinText);
          if (gIniAux > 10000) {
            gFinValid = false;
            return "Valores muy altos no son aceptados.";
          }
        } catch (e) {
          if (gFinText == '') {
            return "Introduzca un valor";
          } else {
            return "Solo se admiten números";
          }
        }
      }
    }
    return null;
  }

  Widget _deleteButton() {
    if (widget.isEditing) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('¿Seguro que deseas eliminar esta cartera?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await helper.deleteWallet(widget.walletId);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'wallets',
                          arguments: widget.userId);
                    },
                    child: Text('Sí'),
                  ),
                ],
              ),
            );
          },
          child: Text('Eliminar cartera'));
    } else {
      return Divider();
    }
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
