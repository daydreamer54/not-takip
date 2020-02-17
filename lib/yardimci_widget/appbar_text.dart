import 'package:flutter/material.dart';
import 'package:not_sepeti_ea/responsive/responsive.dart';

class AppbarText extends StatelessWidget {
  final String baslik;
  const AppbarText({Key key, @required this.baslik}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Text(
        baslik,
        style: TextStyle(
          fontFamily: 'Baslik',
          fontSize: SizeConfig.blockSizeHorizontal * 6.5,
        ),
      ),
    );
  }
}
