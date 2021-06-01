import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_data.dart';

class VachanKoshLogo extends StatefulWidget {
  const VachanKoshLogo({
    Key key,
  }) : super(key: key);

  @override
  _VachanKoshLogoState createState() => _VachanKoshLogoState();
}

class _VachanKoshLogoState extends State<VachanKoshLogo> {
  Image _logoImage;

  @override
  void initState() {
    super.initState();
    _logoImage = Image.asset(AppImages.logo);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_logoImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // CircleAvatar(
        //   backgroundImage: Image.asset(AppImages.logo).image,
        //   radius: 90,
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // Text(
        //   'presents',
        //   style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(colors: [Colors.orange, Colors.green])
                .createShader(rect);
          },
          child: Text(
            'VachanKosh',
            style: const TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ],
    );
  }
}
