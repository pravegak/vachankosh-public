import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/error_dialog.dart';
import 'package:vachankosh/ui/dialogs/image_source_picker_dialog.dart';
import 'package:vachankosh/ui/views/medicine_request_quiz/widgets/input_box.dart';
import 'package:vachankosh/utils/image_selector.dart';
import 'package:vachankosh/viewmodels/create_issue_model.dart';

class RequestDetailsPage extends StatefulWidget {
  const RequestDetailsPage({
    Key key,
    @required this.formkey,
    this.pageController,
  }) : super(key: key);

  final GlobalKey<FormState> formkey;
  final PageController pageController;

  @override
  _RequestDetailsPageState createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateIssueModel>(context);
    return WillPopScope(
      onWillPop: () {
        print('Back pressed');
        //model.setPageTitle('Hospital Details');
        widget.pageController.previousPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);

        return Future.value(false);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    InputBox(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Kindly fill the name of the disease';
                        }
                        return null;
                      },
                      controller: model.editingControllers[6],
                      hintText: 'Disease Name',
                      icon: Icon(FontAwesomeIcons.stethoscope),
                    ),
                    InputBox(
                      maxLines: 4,
                      controller: model.editingControllers[7],
                      hintText: 'Treatment Requirements',
                      icon: Icon(FontAwesomeIcons.briefcaseMedical),
                      keyboard: TextInputType.multiline,
                    ),
                    InputBox(
                      controller: model.editingControllers[8],
                      hintText: 'Estimated Cost',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Kindly fill estimated amount required';
                        }
                        return null;
                      },
                      icon: Icon(FontAwesomeIcons.rupeeSign),
                      keyboard: TextInputType.numberWithOptions(),
                    ),
                    Stack(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                textColor: Colors.white,
                                color: Colors.blueGrey,
                                onPressed: () async {
                                  ImageSource imageSource = await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ImageSourcePickerDialog());
                                  var imageFile = await locator<ImageSelector>()
                                      .selectImage(
                                          imageSource: imageSource,
                                          aspectRatioPresets: [
                                        CropAspectRatioPreset.original
                                      ]);
                                  if (imageFile != null) {
                                    model.addImageFile(imageFile);
                                  }
                                },
                                child: Text('Choose Prescription Images'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (model.prescriptionImgFiles.isNotEmpty)
                      Container(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: model.prescriptionImgFiles
                              .map(
                                (imgFile) => Stack(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Image.file(imgFile)),
                                    Positioned(
                                        child: GestureDetector(
                                      onTap: () {
                                        model.removeImageFile(imgFile);
                                      },
                                      child: Container(
                                        color: Colors.black,
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton.icon(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              if (model.prescriptionImgFiles.isEmpty) {
                                Dialogs.showAppDialog(
                                    context,
                                    ErrorDialog(
                                      error: "Select Presciption Images",
                                      errorDescription:
                                          "Prescription images are must, cannot proceed without them.",
                                    ));
                              }
                              if (widget.formkey.currentState.validate() &&
                                  model.prescriptionImgFiles.isNotEmpty) {
                                model.setFormAutoValidate(false);
                                widget.pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.linearToEaseOut);
                                //model.setPageTitle('Point of Contact Details');
                              } else {
                                model.setFormAutoValidate(true);
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 16,
                            ),
                            label: Text('Next'))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
