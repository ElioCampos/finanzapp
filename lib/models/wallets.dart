class Wallet {
  int id;
  double tasaEfec;
  DateTime fechaDesc;
  double gastosInic;
  double gastosFin;

  Wallet(this.id, this.tasaEfec, this.fechaDesc, this.gastosInic, this.gastosFin);

  Map<String, dynamic> toMap(){
    return {
      'id': (id==0)? null : id,
      'tasaEfec': tasaEfec,
      'fechaDesc': fechaDesc,
      'gastosInic': gastosInic,
      'gastosFin': gastosFin
    };
  }
}