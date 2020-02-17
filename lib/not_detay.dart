import 'package:flutter/material.dart';
import 'package:not_sepeti_ea/focus_node.dart';
import 'package:not_sepeti_ea/models/notlar.dart';
import 'package:not_sepeti_ea/responsive/responsive.dart';
import 'package:not_sepeti_ea/utils/db_helper.dart';
import 'package:not_sepeti_ea/yardimci_widget/appbar_text.dart' as helper;
import 'package:not_sepeti_ea/yardimci_widget/text_form_field.dart';
import 'models/kategori.dart';
import 'package:not_sepeti_ea/global/global.dart' as global;

class NotDetay extends StatefulWidget {
  final String baslik;
  final Notlar duzenlenecekNot;
  NotDetay({Key key, @required this.baslik, this.duzenlenecekNot})
      : super(key: key);

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  int kategoriID;
  List<int> kategoriler = [];
  String notBaslik, notIcerik;
  int secilenOncelik = 0;
  final formKey = GlobalKey<FormState>();
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode notBaslikFocus = FocusNode();
  final FocusNode notIcerikFocus = FocusNode();

  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = List<Kategori>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((kategoriIcerenMapListesi) {
      for (Map okunanMap in kategoriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot.kategoriID;
        secilenOncelik = widget.duzenlenecekNot.notONCELIK;
        print("kategori ID : " + kategoriID.toString());
        print("seçilen öncelik : " + secilenOncelik.toString());
      } else {
        kategoriElemanlariniOlustur();
        for (var item in tumKategoriler) {
          kategoriler.add(item.kategoriID);
        }
        print("Listede olan ilk kategori id  : " + kategoriler[0].toString());
        kategoriID = kategoriler.elementAt(0);
        secilenOncelik = 0;
        print("kategori ID : " + kategoriID.toString());
        print("seçilen öncelik : " + secilenOncelik.toString());
      }
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
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: global.GlobalDegisken.appBarColor,
          centerTitle: true,
          title: helper.AppbarText(
            baslik: 'Not Detay',
          ),
        ),
        body: tumKategoriler.length <= 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.black.withOpacity(0.6),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Kategori Seçiniz",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 3.1,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                            ),
                            iconSize: 35.0,
                            value: kategoriID,
                            items: kategoriElemanlariniOlustur(),
                            onChanged: (value) {
                              setState(() {
                                kategoriID = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(12.0),
                          child: MyTextFormField(
                            borderColor: Colors.white,
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                            label: 'Başlık ekleme alanı',
                            baslangicTexti: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot.notBASLIK
                                : "",
                            focusNode: notBaslikFocus,
                            onFieldSubmitted: (siradaki) {
                              fieldFocusChange(
                                  context, notBaslikFocus, notIcerikFocus);
                            },
                            validatorFonksiyon: (baslik) {
                              if (baslik.length <= 3) {
                                return "En az 3 karakter giriniz";
                              }
                              return null;
                            },
                            onsavedGelenDeger: (baslik) => notBaslik = baslik,
                            satirSayisi: 2,
                          )),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: MyTextFormField(
                          focusNode: notIcerikFocus,
                          onFieldSubmitted: (siradaki) {
                            fieldFocusChange(context, notIcerikFocus,
                                FocusScope.of(context));
                          },
                          satirSayisi: 2,
                          baslangicTexti: widget.duzenlenecekNot != null
                              ? widget.duzenlenecekNot.notICERIK
                              : "",
                          label: 'Not içerik ekleme alanı',
                          onsavedGelenDeger: (icerik) => notIcerik = icerik,
                        ),
                      ),
                      Text(
                        "Not Önceliği Seçiniz",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            iconSize: 45.0,
                            value: secilenOncelik,
                            items: _oncelik
                                .map(
                                  (oncelik) => DropdownMenuItem<int>(
                                    child: Text(
                                      oncelik,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  4.5),
                                    ),
                                    value: _oncelik.indexOf(oncelik),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                secilenOncelik = value;
                              });
                            },
                          ),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: Colors.red.withOpacity(0.5),
                            height: SizeConfig.safeBlockVertical * 9,
                            width: SizeConfig.safeBlockVertical * 22,
                            child: OutlineButton.icon(
                                borderSide: BorderSide(color: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                                label: Text(
                                  'Vazgeç',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal * 5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Container(
                            color: Colors.green.withOpacity(0.5),
                            height: SizeConfig.safeBlockVertical * 9,
                            width: SizeConfig.safeBlockVertical * 22,
                            child: kaydetButonu(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  kategoriElemanlariniOlustur() {
    return tumKategoriler
        .map(
          (kategori) => DropdownMenuItem<int>(
            value: kategori.kategoriID,
            child: Text(
              kategori.kategoriBASLIK,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5.5,
                  color: Colors.black),
            ),
          ),
        )
        .toList();
  }

  kaydetButonu(BuildContext context) {
    return OutlineButton.icon(
        borderSide: BorderSide(color: Colors.white),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();

            var suan = DateTime.now();

            if (widget.duzenlenecekNot == null) {
              databaseHelper
                  .notEkle(Notlar(kategoriID, notBaslik, notIcerik,
                      suan.toString(), secilenOncelik))
                  .then((kayitID) {
                if (kayitID != 0) {
                  Navigator.pop(context);
                }
              });
            } else {
              databaseHelper
                  .notGuncelle(Notlar.withID(
                      widget.duzenlenecekNot.notID,
                      kategoriID,
                      notBaslik,
                      notIcerik,
                      suan.toString(),
                      secilenOncelik))
                  .then((guncellenenId) {
                if (guncellenenId != 0) {
                  Navigator.pop(context);
                }
              });
            }
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.green,
        ),
        label: Text(
          'Kaydet',
          style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ));
  }
}
