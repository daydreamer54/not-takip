class Notlar {
  int notID;
  int kategoriID;
  String kategoriBASLIK;
  String notBASLIK;
  String notICERIK;
  String notTARIH;
  int notONCELIK;

  Notlar(this.kategoriID, this.notBASLIK, this.notICERIK, this.notTARIH,
      this.notONCELIK);

  Notlar.withID(this.notID, this.kategoriID, this.notBASLIK, this.notICERIK,
      this.notTARIH, this.notONCELIK);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notID'] = notID;
    map['kategoriID'] = kategoriID;
    map['notBASLIK'] = notBASLIK;
    map['notICERIK'] = notICERIK;
    map['notTARIH'] = notTARIH;
    map['notONCELIK'] = notONCELIK;
    return map;
  }

  Notlar.fromJson(Map<String, dynamic> map) {
    this.notID = map['notID'];
    this.kategoriID = map['kategoriID'];
    this.kategoriBASLIK = map['kategoriBASLIK'];
    this.notBASLIK = map['notBASLIK'];
    this.notICERIK = map['notICERIK'];
    this.notTARIH = map['notTARIH'];
    this.notONCELIK = map['notONCELIK'];
  }
}
