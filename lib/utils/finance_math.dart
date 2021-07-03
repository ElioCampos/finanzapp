import 'dart:math';

String readableDate(DateTime date) {
  String aux = "${date.toLocal()}".split(' ')[0];
  return aux.split("-")[2] + '-' + aux.split("-")[1] + '-' + aux.split("-")[0];
}

String readDatefromString(String date) {
  if (date == null) {
    return '';
  }
  return date.split("-")[2] +
      '-' +
      date.split("-")[1] +
      '-' +
      date.split("-")[0];
}

double roundDouble(double value, int places) {
  num mod = pow(10.00, places);
  return ((value * mod).round().toDouble() / mod);
}

List letterOperation(DateTime fechaVenc, DateTime fechaDesc, double tea,
    double valorNominal, double costesIni, double costesFin) {
  double tcea = 0;
  costesIni = -costesIni;
  costesFin = -costesFin;
  print("COSTES FIN: $costesFin");
  print("COSTES INI: $costesIni");
  var numDias = fechaVenc.difference(fechaDesc).inDays;
  print("NUM DIAS: $numDias");
  var tep = pow(1 + (tea / 100), (numDias / 360)) - 1;
  print("TEP: $tep");
  var d = tep / (1 + tep);
  print("d: $d");
  var descuento = -valorNominal * d;
  print("DESCUENTO: $descuento");
  var valorNeto = valorNominal + descuento;
  print("VALOR NETO: $valorNeto");
  var valorRecibir = valorNeto + costesIni;
  print("VALOR A RECIBIR: $valorRecibir");
  var flujo = -valorNominal + costesFin;
  print("FLUJO: $flujo");
  tcea = pow(-flujo / valorRecibir, 360 / numDias) - 1;
  print("TCEA: $tcea");
  return [tcea * 100, valorRecibir, flujo, numDias];
}

double tceaWallet(List lista, double valorTotalRecibir) {
  print("Ejecutando...");
  var f = 1;
  var a = 0.0;
  var b = 2 * f / 360;
  var tirP = 0.0;
  var tcea = 0.0;
  var tirA = 0.0;
  var i = -1;
  var valc;
  var c;
  while (i < 0) {
    valc = 0;
    c = (a + b) / 2;
    for (var j = 0; j <= (lista.length - 1); j++) {
      valc += lista[j][0] / pow(1 + c, lista[j][1]);
    }
    if (valc < valorTotalRecibir) {
      b = c;
    } else {
      a = c;
    }
    if ((valc - valorTotalRecibir).abs() < 0.0001) {
      tirP = c;
      tirA = tirP * 360 / f;
      tcea = pow(1 + (tirA * f) / 360, 360 / f) - 1;
      i = 1;
    }
  }
  print(tcea);
  return tcea;
}
