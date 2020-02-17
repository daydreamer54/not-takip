import 'package:flutter/material.dart';

/*Bu metod text-form field içindeki alanlarda ileri gitme butonu çalışması için oluşturuldu*/
fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
