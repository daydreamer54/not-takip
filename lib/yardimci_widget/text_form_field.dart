import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*TextForm fieldin kullanılacağı yerlerde base sınıf olarak yazıldı*/
class MyTextFormField extends StatelessWidget {
  final String label;
  final TextInputType textInputType;
  final TextStyle textStyle;
  final Function validatorFonksiyon;
  final Function onsavedGelenDeger;
  final TextEditingController kontroller;
  final int satirSayisi;
  final String kaydedilecekDeger;
  final bool password;
  final int karakterSayisi;
  final FontWeight fontWeight;
  final TextInputAction ileriTusu;
  final IconButton sifreyiGoster;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final bool autoFocus;
  final bool autoValidate;
  final Function onTap;
  final String baslangicTexti;
  final Color borderColor;

  MyTextFormField(
      {Key key,
      this.label,
      this.focusNode,
      this.onFieldSubmitted,
      this.ileriTusu,
      this.sifreyiGoster,
      this.textStyle,
      this.fontWeight,
      this.textInputType,
      this.kaydedilecekDeger,
      this.password,
      this.kontroller,
      this.satirSayisi,
      this.validatorFonksiyon,
      this.karakterSayisi,
      this.onsavedGelenDeger,
      this.autoFocus,
      this.autoValidate,
      this.onTap,
      this.baslangicTexti,
      this.borderColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: null ?? this.baslangicTexti,
      onTap: this.onTap,
      autovalidate: this.autoValidate ?? false,
      autofocus: this.autoFocus ?? false,
      focusNode: this.focusNode,
      onFieldSubmitted: this.onFieldSubmitted,
      textInputAction: this.ileriTusu,
      obscureText: this.password ?? false,
      maxLines: this.satirSayisi,
      maxLength: this.karakterSayisi,
      controller: this.kontroller,
      validator: this.validatorFonksiyon,
      onSaved: this.onsavedGelenDeger,
      style: this.textStyle,
      keyboardType: this.textInputType,
      decoration: InputDecoration(
        suffixIcon: this.sifreyiGoster,
        hintText: this.label,
        hintStyle: TextStyle(fontWeight: this.fontWeight,color: this.borderColor ?? Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: this.borderColor ?? Colors.white,
              width: MediaQuery.of(context).size.width * (0.001)),
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * (0.02),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * (0.003)),
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * (0.02),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * (0.003)),
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * (0.02),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * (0.003)),
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * (0.02),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: this.borderColor ?? Colors.white,
              width: MediaQuery.of(context).size.width * (0.003)),
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * (0.02),
          ),
        ),
      ),
    );
  }
}
