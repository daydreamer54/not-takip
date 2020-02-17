import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalDegisken {
  static const Color appBarColor = Colors.black;
  static const Color iptalButon = Colors.red;
  static const Color tamamButon = Colors.green;
  static const Color copKutusu = Colors.red;
  static const Color kategoriIcon = Colors.red;
}

Widget loadingMessage() {
  return Center(
    child: Text(
      "Yükleniyor...",
      style: TextStyle(fontSize: 22.0, color: Colors.white),
    ),
  );
}

Widget errorMessage(var message) {
  return Center(
      child: Text(
    message,
    style: TextStyle(fontSize: 22.0, color: Colors.white),
  ));
}

Widget noSaved(var message) {
  return Center(
    child: Text(
      message,
      style: TextStyle(fontSize: 22.0, color: Colors.white),
    ),
  );
}

/*Platform destekli navigasyon*/
class NavigasyonIslemi {
  void navigate(BuildContext context, Widget route) {
    Navigator.push(
        context,
        Platform.isAndroid
            ? MaterialPageRoute(builder: (context) => route)
            : Navigator.push(
                context, CupertinoPageRoute(builder: (context) => route)));
  }
}
