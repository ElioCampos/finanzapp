class Letter {
  int id;
  int walletId;
  DateTime fechaGiro;
  DateTime fechaVenc;
  double valNom;
  double retencion;

  Letter(this.id, this.walletId, this.fechaGiro, this.fechaVenc, this.valNom, this.retencion);

  Map<String, dynamic> toMap(){
    return {
      'id': (id==0)? null : id,
      'walletId': walletId,
      'fechaGiro': fechaGiro,
      'fechaVenc': fechaVenc,
      'valNom': valNom,
      'retencion': retencion
    };
  }
}