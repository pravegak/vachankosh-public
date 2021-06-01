import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourcePickerDialog extends StatelessWidget {
  const ImageSourcePickerDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Align(child: Text('Pick a source')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton.icon(
              icon: Icon(
                FontAwesomeIcons.camera,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              label: Text(
                'Camera',
                style: TextStyle(color: Colors.blue),
              )),
          FlatButton.icon(
              icon: Icon(
                FontAwesomeIcons.solidImages,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              label: Text(
                'Gallery',
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
    );
  }
}
