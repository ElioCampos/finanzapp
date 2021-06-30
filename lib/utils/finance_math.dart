import 'dart:math';

double roundDouble(double value, int places) {
  num mod = pow(10.00, places);
  return ((value * mod).round().toDouble() / mod);
}

List letterOperation(DateTime fechaVenc, DateTime fechaDesc, double tea, double valorNominal, double costesIni, double costesFin){
  double tcea = 0;
  costesIni = -costesIni;
  costesFin = -costesFin;
  print("COSTES FIN: $costesFin");
  print("COSTES INI: $costesIni");
  var numDias = fechaVenc.difference(fechaDesc).inDays;
  print("NUM DIAS: $numDias");
  var tep = pow(1+(tea/100),(numDias/360)) - 1;
  print("TEP: $tep");
  var d = tep/(1+tep);
  print("d: $d");
  var descuento = -valorNominal * d;
  print("DESCUENTO: $descuento");
  var valorNeto = valorNominal + descuento;
  print("VALOR NETO: $valorNeto");
  var valorRecibir = valorNeto + costesIni;
  print("VALOR A RECIBIR: $valorRecibir");
  var flujo = -valorNominal + costesFin;
  print("FLUJO: $flujo");
  tcea = pow(-flujo/valorRecibir,360/numDias) - 1;
  print("TCEA: $tcea");
  return [tcea * 100, valorRecibir, flujo];
}