class Kategori {
  int kategoriID;
  String kategoriBASLIK;

  /*Ekleme yaparken*/
  Kategori(this.kategoriBASLIK);

  /*Listeleme yaparken*/
  Kategori.withID(this.kategoriID, this.kategoriBASLIK);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['kategoriID'] = kategoriID;
    map['kategoriBASLIK'] = kategoriBASLIK;
    return map;
  }

  /*İsimlendirilmiş constructorlara return ifadesi yazamıyoruz*/
  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriID = map['kategoriID'];
    this.kategoriBASLIK = map['kategoriBASLIK'];
  }

  
}
