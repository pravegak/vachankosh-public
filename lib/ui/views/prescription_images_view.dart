import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PrescriptionImagesView extends StatelessWidget {
  final List<String> prescriptionImageUrls;
  static const routeName = '/prescriptionImages';

  const PrescriptionImagesView({Key key, this.prescriptionImageUrls})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Images'),
      ),
      body: Container(
        child: PageView.builder(
            itemCount: prescriptionImageUrls.length,
            itemBuilder: (context, index) =>
                FullScreenImagePage(prescriptionImageUrls[index])),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  FullScreenImagePage(this.imageUrl);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoView(
        tightMode: true,
        backgroundDecoration: BoxDecoration(color: Colors.blue),
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
