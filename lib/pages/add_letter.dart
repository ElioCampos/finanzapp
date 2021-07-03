import 'package:finanzapp/utils/finance_math.dart';
import 'package:finanzapp/utils/stylish.dart';
import 'package:flutter/material.dart';
import 'package:finanzapp/utils/dbhelper.dart';

class AddLetter extends StatefulWidget {
  final int walletId;
  final bool isEditing;
  final int letterId;
  const AddLetter(
      {Key? key,
      required this.walletId,
      required this.isEditing,
      required this.letterId})
      : super(key: key);

  @override
  _AddLetterState createState() => _AddLetterState();
}

class _AddLetterState extends State<AddLetter> {
  DbHelper helper = DbHelper();
  DateTime dateGiro = DateTime.now();
  DateTime dateVenc = DateTime.now();
  DateTime dateDesc = DateTime.now();

  TextEditingController valNomController = TextEditingController();
  TextEditingController retencionController = TextEditingController();
  TextEditingController fechaVencController = TextEditingController();
  TextEditingController fechaGiroController = TextEditingController();
  double valorNominal = 0.0;
  double retencion = 0.0;
  double gastosFin = 0.0;
  bool valNomValid = false;
  bool retValid = false;
  bool giroValid = false;
  bool vencValid = false;
  var fechaGiro;
  var fechaVenc;
  var letter;
  bool isPressed = false;

  Future getLetter() async {
    await helper.openDb();
    letter = await helper.getLetterById(widget.letterId);
    setState(() {
      letter = letter;
      valNomController.text = letter[0]['valNom'].toString();
      retencionController.text = letter[0]['retencion'].toString();
      dateGiro = DateTime.parse(letter[0]['fechaGiro'].toString());
      dateVenc = DateTime.parse(letter[0]['fechaVenc'].toString());
    });
  }

  Future getWalletInfo() async {
    await helper.openDb();
    var wallet = await helper.getWalletById(widget.walletId);
    setState(() {
      dateDesc = DateTime.parse(wallet[0]['fechaDesc'].toString());
      print("FECHAZA DESCUENTO: $dateDesc");
    });
  }

  @override
  void initState() {
    super.initState();
    getWalletInfo();
    if (widget.isEditing) {
      getLetter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEditing
            ? Text('Editar letra')
            : Text('Añadir nueva letra'),
        backgroundColor: Colors.green[300],
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
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
                  hintText: 'Valor nominal',
                  errorText: _valNomError(valNomController.text)
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
                  hintText: 'Retención',
                  errorText: _retError(retencionController.text, valNomController.text)
                ),
                keyboardType: TextInputType.number,
                controller: retencionController,
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
                child: stylish("Fecha de giro de la letra", 20, 1),
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
                    labelText: readableDate(dateGiro),
                    errorText: _giroError(),
                    suffixIcon: IconButton(
                        color: Colors.green,
                        onPressed: () => _selectDate(context, 'giro'),
                        icon: Icon(Icons.date_range))),
                keyboardType: TextInputType.number,
                controller: fechaGiroController,
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
                child: stylish("Fecha de vencimiento de la letra", 20, 1),
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
                    labelText: readableDate(dateVenc),
                    errorText: _vencError(),
                    suffixIcon: IconButton(
                        color: Colors.green,
                        onPressed: () => _selectDate(context, 'venc'),
                        icon: Icon(Icons.date_range))),
                keyboardType: TextInputType.number,
                controller: fechaVencController,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () async {
                  setState(() {
                    print("FECHA DESC: $dateDesc");
                    isPressed = true;
                    try {
                      valorNominal = double.parse(valNomController.text);
                      if (valorNominal <= 1000000) {
                        valNomValid = true;
                      } else {
                        valNomValid = false;
                      }
                    } catch (e) {
                      valNomValid = false;
                      print(e);
                    }
                    try {
                      retencion = double.parse(retencionController.text);
                      if (retencion >= valorNominal) {
                        retValid = false;
                      } else {
                        retValid = true;
                      }
                    } catch (e) {
                      retValid = false;
                      print(e);
                    }
                    if (dateGiro.compareTo(dateDesc) > 0) {
                      giroValid = false;
                    } else {
                      if (dateGiro.compareTo(dateVenc) > 0) {
                        giroValid = false;
                      } else {
                        giroValid = true;
                      }
                    }
                    if (dateVenc.compareTo(dateDesc) < 0) {
                      vencValid = false;
                    } else {
                      if (dateVenc.compareTo(dateGiro) < 0) {
                        vencValid = false;
                      } else {
                        vencValid = true;
                      }
                    }
                    fechaGiro = "${dateGiro.toLocal()}".split(' ')[0];
                    fechaVenc = "${dateVenc.toLocal()}".split(' ')[0];
                  });
                  print("$valNomValid, $retValid, $giroValid, $vencValid");
                  if (valNomValid && retValid && giroValid && vencValid) {
                    if (widget.isEditing) {
                      await helper.updateLetter(widget.letterId, fechaGiro,
                          fechaVenc, valorNominal, retencion);
                    } else {
                      await helper.insertLetter(widget.walletId, fechaGiro,
                          fechaVenc, valorNominal, retencion);
                    }
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'wallet_details',
                        arguments: widget.walletId);
                  }
                },
                child: widget.isEditing
                    ? Text('Editar letra')
                    : Text('Añadir letra'),
              ),
              _deleteButton(),
            ],
          )),
    );
  }

  Widget _deleteButton() {
    if (widget.isEditing) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('¿Seguro que deseas eliminar esta letra?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await helper.deleteLetter(widget.letterId);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'wallet_details',
                          arguments: widget.walletId);
                    },
                    child: Text('Sí'),
                  ),
                ],
              ),
            );
          },
          child: Text('Eliminar letra'));
    } else {
      return Divider();
    }
  }

  String? _valNomError(String valNomText) {
    if (isPressed) {
      if (!valNomValid) {
        try {
          var vnAux = double.parse(valNomText);
          if (vnAux >= 1000000) {
            return "Es un valor muy grande";
          }
        } catch (e) {
          if (valNomText == '') {
            return "Introduzca un valor";
          } else {
            return "Solo se admiten números";
          }
        }
      }
    }
    return null;
  }

  String? _retError(String retText, String vnText) {
    if (isPressed) {
      if (!retValid) {
        try {
          var retAux = double.parse(retText);
          var vnAux = double.parse(vnText);
          if (retAux >= vnAux) {
            return "La retención debe ser menor que el val. nom.";
          }
        } catch (e) {
          if (retText == '') {
            return "Introduzca un valor";
          } else {
            return "Solo se admiten números";
          }
        }
      }
    }
    return null;
  }

  String? _giroError() {
    if (isPressed) {
      if (!giroValid) {
        if (dateGiro.compareTo(dateDesc) > 0) {
          return "La fecha de giro es mayor a la de descuento";
        } else {
          if (dateGiro.compareTo(dateVenc) > 0) {
            return "La fecha de giro es mayor a la de vencimiento";
          }
        }
      }
    }
    return null;
  }

  String? _vencError() {
    if (isPressed) {
      if (!vencValid) {
        if (dateVenc.compareTo(dateDesc) < 0) {
          return "La fecha de vencimiento es menor a la de descuento";
        } else {
          if (dateVenc.compareTo(dateGiro) < 0) {
            return "La fecha de vencimiento es menor a la de giro";
          }
        }
      }
    }
    return null;
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
    } else {
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
