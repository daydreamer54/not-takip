import 'package:flutter/material.dart';
import 'package:not_sepeti_ea/models/kategori.dart';
import 'package:not_sepeti_ea/not_detay.dart';
import 'package:not_sepeti_ea/utils/db_helper.dart';
import 'package:not_sepeti_ea/yardimci_widget/text_form_field.dart';
import 'kategoriler.dart';
import 'models/notlar.dart';
import 'responsive/responsive.dart';
import 'package:not_sepeti_ea/global/global.dart' as global;
import 'package:not_sepeti_ea/yardimci_widget/appbar_text.dart' as helper;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        buttonTheme: ButtonThemeData(
          minWidth: 11.0,
        ),
        textTheme: TextTheme(
          button: TextStyle(fontSize: 11.0),
        ),
        primarySwatch: Colors.red,
      ),
      home: NotlarListesi(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotlarListesi extends StatefulWidget {
  NotlarListesi({Key key}) : super(key: key);

  @override
  _NotlarListesiState createState() => _NotlarListesiState();
}

class _NotlarListesiState extends State<NotlarListesi> {
  bool otoKontrol = false;
  var kategoriController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Kategori> kategorilerim = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String yeniDeger;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Notlar> tumNotlar = [];

  @override
  void initState() {
    /*Map olarak geldiği için fromJson metodu ile bunları listeye çevirip elimizdeki listeye atıyoruz.*/
    super.initState();
    databaseHelper.notlariGetir().then((gelenNotunMapHali) {
      for (Map map in gelenNotunMapHali) {
        tumNotlar.add(Notlar.fromJson(map));
      }
      databaseHelper.kategorileriGetir().then((gelenVeriler) {
        for (Map map in gelenVeriler) {
          kategorilerim.add(Kategori.fromMap(map));
        }
        print("kategori sayısı : " + kategorilerim.length.toString());
        setState(() {});
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'KategoriEkle',
              tooltip: 'Kategori Ekle',
              mini: true,
              onPressed: () {
                kategoriEkleDialog(context);
              },
              child: Icon(
                Icons.category,
                size: 20.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            FloatingActionButton(
              heroTag: 'NotEkle',
              tooltip: 'Not Ekle',
              onPressed: () {
                kategorilerim.length <= 0
                    ? showSnackBar("Önce kategori ekleyiniz.")
                    : _notDetaySayfasinaGit(context);
              },
              child: Icon(
                Icons.add,
                size: 35.0,
              ),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: global.GlobalDegisken.appBarColor,
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      global.NavigasyonIslemi()
                          .navigate(context, Kategorilerim());
                    },
                    leading: Icon(
                      Icons.category,
                      color: global.GlobalDegisken.kategoriIcon,
                    ),
                    title: Text(
                      "Kategoriler",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.5),
                    ),
                  ),
                ),
              ];
            }),
          ],
          centerTitle: true,
          title: helper.AppbarText(
            baslik: 'Notlar Listesi',
          ),
        ),
        body: Container(
          color: Colors.black.withOpacity(0.8),
          child: FutureBuilder(
            builder: (context, AsyncSnapshot<List<Notlar>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return global.loadingMessage();
              } else if (!snapshot.hasError &&
                  snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                tumNotlar = snapshot.data;
                if (tumNotlar.length > 0) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: ExpansionTile(
                            trailing: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.teal.withOpacity(0.4),
                            leading: _oncelikDegeriAta(
                              tumNotlar[index].notONCELIK,
                            ),
                            title: Text(
                              tumNotlar[index].notBASLIK,
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                                  color: Colors.white),
                            ),
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                ),
                                padding: EdgeInsets.all(9),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: textWidget("Kategori"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: textWidget(
                                              tumNotlar[index].kategoriBASLIK),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: textWidget(
                                              'Oluşturulma Tarihi : '),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            databaseHelper.dateFormat(
                                                DateTime.parse(
                                                    tumNotlar[index].notTARIH)),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  4.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: textWidget(
                                          tumNotlar[index].notICERIK),
                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        silButonu(
                                            context,
                                            tumNotlar[index].notID,
                                            tumNotlar[index].notBASLIK),
                                        OutlineButton(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          onPressed: () =>
                                              _notDetaySayfasinaGitGuncelle(
                                                  context, tumNotlar[index]),
                                          child: Text(
                                            "GÜNCELLE",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    5,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: tumNotlar.length,
                    ),
                  );
                } else if (tumNotlar.length == 0) {
                  return global.noSaved("Kayıtlı notunuz yoktur.");
                }
              } else if (snapshot.hasError) {
                return global.errorMessage(
                    "Notlar yüklenirken bir hata oluştu. Tekrar deneyiniz.");
              }
            },
            future: databaseHelper.notlarListesi(),
          ),
        ),
      ),
    );
  }

  Widget textWidget(var icerik) {
    return Text(
      icerik,
      style: TextStyle(
          color: Colors.black, fontSize: SizeConfig.safeBlockHorizontal * 4.5),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.all(15.0),
          children: <Widget>[
            Form(
              autovalidate: otoKontrol,
              key: formKey,
              child: MyTextFormField(
                label: 'Kategori adı giriniz.',
                borderColor: Colors.black,
                onsavedGelenDeger: (value) {
                  yeniDeger = value;
                },
                validatorFonksiyon: (value) {
                  if (value.length < 2) {
                    return "En az 2 karakter giriniz";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ButtonBar(
              children: <Widget>[
                Container(
                  color: Colors.red.withOpacity(0.5),
                  height: SizeConfig.safeBlockVertical * 7,
                  width: SizeConfig.safeBlockVertical * 20,
                  child: OutlineButton.icon(
                      borderSide: BorderSide(color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Vazgeç',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  color: Colors.green.withOpacity(0.5),
                  height: SizeConfig.safeBlockVertical * 7,
                  width: SizeConfig.safeBlockVertical * 18,
                  child: OutlineButton.icon(
                    borderSide: BorderSide(color: Colors.green),
                    onPressed: () {
                      otoKontrol = true;
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniDeger))
                            .then((value) {
                          value > 0
                              ? showSnackBar("$yeniDeger eklendi.")
                              : showSnackBar("$yeniDeger eklenemedi");
                        });

                        databaseHelper.kategorileriGetir().then((gelenVeriler) {
                          for (Map map in gelenVeriler) {
                            kategorilerim.add(Kategori.fromMap(map));
                          }
                          setState(() {});
                          print("Toplam kategori sayısı : " +
                              kategorilerim.length.toString());
                        });

                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      Icons.save,
                      color: Colors.green,
                    ),
                    label: Text(
                      'Ekle',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
          title: Text(
            "Kategori Ekle",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        );
      },
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    return _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.withOpacity(0.4),
        content: Container(
          height: 30,
          child: Text(
            message,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 5.5,
                color: Colors.white),
          ),
        ),
        duration: Duration(milliseconds: 750),
      ),
    );
  }

  void _notDetaySayfasinaGit(BuildContext context) {
    global.NavigasyonIslemi()
        .navigate(context, NotDetay(baslik: "Not Detay Sayfası"));
  }

  void _notDetaySayfasinaGitGuncelle(BuildContext context, Notlar not) {
    global.NavigasyonIslemi().navigate(
        context,
        NotDetay(
          baslik: not.kategoriBASLIK,
          duzenlenecekNot: not,
        ));
  }

  _oncelikDegeriAta(int notONCELIK) {
    switch (notONCELIK) {
      case 0:
        return CircleAvatar(
          child: Text(
            "AZ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade100,
        );
        break;
      case 1:
        return CircleAvatar(
          child: Text("ORTA", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent.shade400,
        );
        break;
      case 2:
        return CircleAvatar(
          child: Text("ACİL", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent.shade700,
        );
        break;
    }
  }

  _notSil(int notID, String baslik) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Container(
              height: 30,
              child: Text(
                baslik + " silindi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21.0, color: Colors.black),
              ),
            ),
            duration: Duration(milliseconds: 750),
          ),
        );
        setState(() {});
      }
    });
  }

  silButonu(BuildContext context, var notID, var notBASLIK) {
    return OutlineButton(
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
      onPressed: () => _notSil(notID, notBASLIK),
      child: Text(
        "SİL",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: SizeConfig.safeBlockHorizontal * 5,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
