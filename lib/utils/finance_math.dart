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

Map letterOperation(DateTime fechaVenc, DateTime fechaDesc, double tea,
    double
     valorNominal, double costesIni, double costesFin, double retencion) {
  double tcea = 0;
  // Los costes finales e iniciales son salidas de dinero
  costesIni = -costesIni;
  costesFin = -costesFin;
  print("COSTES FIN: $costesFin");
  print("COSTES INI: $costesIni");
  // Se calcula la cantidad de días de diferencia entre la fecha de descuento y la de vencimiento de la letra
  var numDias = fechaVenc.difference(fechaDesc).inDays;
  print("NUM DIAS: $numDias");
  // Se calcula la tasa efectiva del periodo. TEA se divide sobre 100 porque está en porcentaje
  var tep = pow(1 + (tea / 100), (numDias / 360)) - 1;
  print("TEP: $tep");
  // Calculando la tasa descontada para el periodo anterior
  var d = tep / (1 + tep);
  print("d: $d");

  var descuento = -valorNominal * d;
  print("DESCUENTO: $descuento");
  var valorNeto = valorNominal + descuento;
  print("VALOR NETO: $valorNeto");
  var valorRecibir = valorNeto + costesIni;
  valorRecibir -= retencion;
  print("VALOR A RECIBIR: $valorRecibir");
  var flujo = -valorNominal + costesFin;
  print("FLUJO: $flujo");
  tcea = pow(-flujo / valorRecibir, 360 / numDias) - 1;
  print("TCEA: $tcea");
  return {
    'tceaLetra': tcea * 100,
    'valorRecibir': valorRecibir,
    'valorEntregar': flujo,
    'numDias': numDias,
    'descuento': descuento,
    'tasaPeriodo': tep * 100,
    'tasaDesc': d * 100,
  };
  // return [tcea * 100, valorRecibir, flujo, numDias];
}

double tceaWallet(List lista, double valorTotalRecibir, double retencion) {
  
  // valorTotalRecibir -= retencion;
  print(valorTotalRecibir);
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

double nomAEfec(double tasaNom, int a, int b) {
  var m = a/b;
  tasaNom = tasaNom/100;
  print("VALORES NOMIN: $tasaNom, $m");
  double tep = pow((1 + (tasaNom / m)), m) - 1;
  return tep;
}

double calcTea(double tasa, int diasTep, bool isNominal, int diasNomin) {
  double tea = 0.0;
  print("$tasa, $diasTep, $isNominal, $diasNomin");
  if (isNominal) {
    double tep = nomAEfec(tasa, diasTep, diasNomin);
    tea = pow((1 + tep), 360 / diasTep) - 1;
  } else {
    tea = pow((1 + (tasa/100)), 360 / diasTep) - 1;
  }
  print("DESDE LA FUNC: $tea");
  return roundDouble(tea*100,5);
}
