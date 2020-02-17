/*Bu sınıf sadece veritabanı işlemleri için tasarlanacaktır bunun amacı katmanlı mimariyi oluşturarak
sayfaların birbiri ile olan bağını en az düzeye indirmektir. Sadece bazı metodlar dışarıya açık olacaktır.*/

/*Singleton tasarım deseninin amacı tek bir nesne üzerinden işlemleri yapmak, araya herhangi bir başka işlem sokmamak bu sayede
olabilecek olan veri tutarsızlıklarına karşı önlem almış oluyoruz */

/*Statik sınıfa özgür bir kavramdır. Class adını yazdıkdan sonra erişim sağlayabiliriz, sınıfın nesnesini oluşturmak zorunda kalmayız*/

/*Constructor yapılarında return ifadesi var ise bunlarda factory kullanıyoruz, çalışma alanımızı genişletiyoruz.*/

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:not_sepeti_ea/models/kategori.dart';
import 'package:not_sepeti_ea/models/notlar.dart';
import 'package:sqflite/sqflite.dart'; /*Database import edildi.*/
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  /*Burada, _databaseHelper olan nesnenin var mı yok mu diye kontrol ediyoruz varsa aynı nesneyi kullanıyoruz
  başka bir tana oluşturup sistemi yormuyoruz fakat yoksa yeni bir tane oluşturmasını sağlıyoruz.*/
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database _db;

    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "appDB");
          print("VERİTABANI YOLU : $path");
          var file = new File(path);

          // check if file exists
          if (!await file.exists()) {
            // Copy from asset
            ByteData data = await rootBundle.load(join("assets", "notlar.db"));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          // open the database
          _db = await openDatabase(path);
        }
      });
    }

    return _db;
  }

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var listele = await db.query("kategori");
    return listele;
  }

  Future<List<Kategori>> kategoriListesiniGetir() async {
    var kategorileriListeyeAt = await kategorileriGetir();
    List<Kategori> kategorilerim = List<Kategori>();
    for (Map map in kategorileriListeyeAt) {
      kategorilerim.add(Kategori.fromMap(map));
    }
    return kategorilerim;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var ekle = await db.insert("kategori", kategori.toMap());
    return ekle;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var guncelle = await db.update("kategori", kategori.toMap(),
        where: 'kategoriID = ?', whereArgs: [kategori.kategoriID]);
    return guncelle;
  }

  Future<int> kategoriSil(int kategoriID) async {
    var db = await _getDatabase();
    var sil = await db
        .delete("kategori", where: 'kategoriID = ?', whereArgs: [kategoriID]);
    return sil;
  }

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var listele = await db.rawQuery(
        'select * from "not" inner join kategori on kategori.kategoriID = "not".kategoriID order by notID DESC;');
    return listele;
  }

  /*Map olarak döndürmektense direkt olarak liste şeklinde döndürüyoruz*/
  Future<List<Notlar>> notlarListesi() async {
    var notlariListeyeAt = await notlariGetir();
    List<Notlar> notlarListesi = List<Notlar>();
    for (Map map in notlariListeyeAt) {
      notlarListesi.add(Notlar.fromJson(map));
    }
    return notlarListesi;
  }

  Future<int> notEkle(Notlar not) async {
    var db = await _getDatabase();
    var ekle = await db.insert("not", not.toMap());
    return ekle;
  }

  Future<int> notGuncelle(Notlar notID) async {
    var db = await _getDatabase();
    var guncelle = await db.update("not", notID.toMap(),
        where: 'notID = ?', whereArgs: [notID.notID]);
    return guncelle;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var sil = await db.delete("not", where: 'notID = ?', whereArgs: [notID]);
    return sil;
  }

  String dateFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
