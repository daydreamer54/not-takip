import 'package:flutter/material.dart';
import 'package:not_sepeti_ea/main.dart';
import 'package:not_sepeti_ea/models/kategori.dart';
import 'package:not_sepeti_ea/responsive/responsive.dart';
import 'package:not_sepeti_ea/utils/db_helper.dart';
import 'package:not_sepeti_ea/yardimci_widget/appbar_text.dart' as helper;
import 'package:not_sepeti_ea/global/global.dart' as global;
import 'package:not_sepeti_ea/yardimci_widget/text_form_field.dart';

class Kategorilerim extends StatefulWidget {
  Kategorilerim({Key key}) : super(key: key);

  @override
  _KategorilerimState createState() => _KategorilerimState();
}

class _KategorilerimState extends State<Kategorilerim> {
  List<Kategori> tumKategorilerim;
  DatabaseHelper databaseHelper;
  bool donenDeger = false;
  bool otoKontrol = false;
  List<Kategori> kategorilerim = [];
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (tumKategorilerim == null) {
      tumKategorilerim = List<Kategori>();
      kategoriListesiniGuncelle();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: global.GlobalDegisken.appBarColor,
        centerTitle: true,
        title: helper.AppbarText(
          baslik: 'Kategorilerim',
        ),
      ),
      body: tumKategorilerim.length == 0
          ? Container(
              color: Colors.black.withOpacity(0.8),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  global.noSaved("Kayıtlı kategoriniz yoktur."),
                  SizedBox(
                    height: 15.0,
                  ),
                  geriDon(context),
                ],
              ),
            )
          : Container(
              color: Colors.black.withOpacity(0.6),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: tumKategorilerim.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            _kategoriGuncelleDialog(tumKategorilerim[index]);
                          },
                          leading: Icon(
                            Icons.category,
                            color: global.GlobalDegisken.kategoriIcon,
                          ),
                          title: Text(
                            tumKategorilerim[index].kategoriBASLIK,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal * 5.5),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: global.GlobalDegisken.copKutusu,
                              size: 35.0,
                            ),
                            onPressed: () {
                              _kategoriSil(tumKategorilerim[index].kategoriID,
                                  tumKategorilerim[index].kategoriBASLIK);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      geriDon(context),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void kategoriListesiniGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((gelenListe) {
      setState(() {
        tumKategorilerim = gelenListe;
      });
    });
  }

  void _kategoriSil(int kategoriID, String baslik) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Text(
              "Emin misiniz?",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Kategoriye bağlı olan tüm notlar silinecektir",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: SizeConfig.safeBlockHorizontal * 4.4),
                ),
                SizedBox(height: 15.0),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        onPressed: () {
                          databaseHelper
                              .kategoriSil(kategoriID)
                              .then((silinenId) {
                            if (silinenId != 0) {
                              setState(() {
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Container(
                                      height: 30,
                                      child: Text(
                                        baslik + " silindi",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    4.5,
                                            color: Colors.black),
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                kategoriListesiniGuncelle();
                              });
                            }
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "SİL",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                    SizedBox(width: 15.0),
                    OutlineButton(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "VAZGEÇ",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _kategoriGuncelleDialog(Kategori tumKategorilerim) {
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
                kontroller: controller,
                sifreyiGoster: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => controller.clear());
                      setState(() {});
                    }),
                label: tumKategorilerim.kategoriBASLIK,
                autoValidate: false,
                validatorFonksiyon: (value) {
                  if (value.length < 3) {
                    return "En az 3 karakter giriniz";
                  }
                  return null;
                },
                onsavedGelenDeger: (value) {
                  tumKategorilerim.kategoriBASLIK = value;
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ButtonBar(
              children: <Widget>[
                Container(
                  height: SizeConfig.safeBlockVertical * 7,
                  child: OutlineButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                            color: Colors.black),
                      )),
                ),
                Container(
                  height: SizeConfig.safeBlockVertical * 7,
                  child: OutlineButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      borderSide: BorderSide(color: Colors.red),
                      onPressed: () {
                        otoKontrol = true;
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          databaseHelper
                              .kategoriGuncelle(Kategori.withID(
                                  tumKategorilerim.kategoriID,
                                  tumKategorilerim.kategoriBASLIK))
                              .then((guncellenenDeger) {
                            if (guncellenenDeger != 0) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Container(
                                    height: 30,
                                    child: Text(
                                      tumKategorilerim.kategoriBASLIK +
                                          " güncellendi.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  4.5,
                                          color: Colors.black),
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 750),
                                ),
                              );
                            } else {
                              print("Güncellenemedi");
                            }
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
                        'Güncelle',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            color: Colors.black),
                      )),
                ),
              ],
            ),
          ],
          title: Text(
            "Kategori Güncelle",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 5.5),
          ),
        );
      },
    );
  }

  geriDon(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      height: SizeConfig.safeBlockVertical * 10,
      width: SizeConfig.safeBlockHorizontal * 50,
      child: OutlineButton.icon(
        borderSide: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NotlarListesi()),
              (_) => false);
        },
        icon: Icon(
          Icons.arrow_back,
          size: 35.0,
          color: Colors.white,
        ),
        label: Text(
          "Geri Dön",
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.safeBlockVertical * 4.5,
          ),
        ),
      ),
    );
  }
}
