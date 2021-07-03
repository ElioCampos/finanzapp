import 'package:finanzapp/utils/drawer.dart';
import 'package:finanzapp/utils/stylish.dart';
import 'package:flutter/material.dart';

enum tipoTasa { nominal, efectiva }
enum tipoMoneda { soles, dolares }

class OptionsPage extends StatefulWidget {
  final int userId;
  const OptionsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  tipoTasa? _tasa = tipoTasa.efectiva;
  tipoMoneda? _moneda = tipoMoneda.soles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Opciones'),
          backgroundColor: Colors.green[300],
        ),
        drawer: MyDrawer(userId: widget.userId,),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: stylish("Tipo de tasa", 20, 1)),
              RadioListTile<tipoTasa>(
                title: const Text('Tasa efectiva'),
                value: tipoTasa.efectiva,
                groupValue: _tasa,
                activeColor: Colors.green,
                onChanged: (tipoTasa? value) {
                  setState(() {
                    _tasa = value;
                  });
                },
              ),
              RadioListTile<tipoTasa>(
                title: const Text('Tasa nominal'),
                value: tipoTasa.nominal,
                groupValue: _tasa,
                activeColor: Colors.green,
                onChanged: (tipoTasa? value) {
                  setState(() {
                    _tasa = value;
                  });
                },
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
                  child: stylish("Tipo de moneda", 20, 1)),
              RadioListTile<tipoMoneda>(
                title: const Text('Soles (S/.)'),
                value: tipoMoneda.soles,
                groupValue: _moneda,
                activeColor: Colors.green,
                onChanged: (tipoMoneda? value) {
                  setState(() {
                    _moneda = value;
                  });
                },
              ),
              RadioListTile<tipoMoneda>(
                title: const Text('Dólares (\$)'),
                value: tipoMoneda.dolares,
                groupValue: _moneda,
                activeColor: Colors.green,
                onChanged: (tipoMoneda? value) {
                  setState(() {
                    _moneda = value;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
