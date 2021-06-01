import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/cloud_storage_service.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/address.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

class CreateIssueModel extends ChangeNotifier {
  final List<TextEditingController> _helpRequestEditingControllers =
      List.generate(12, (index) => TextEditingController());
  final MedicineRequest _helpRequest = MedicineRequest();
  // String _pageTitle = 'Patient Details';
  String _patientState = 'State';
  AddressModel _hospitalAddress;
  AddressModel get hospitalAddress => _hospitalAddress;
  String _patientIdProofType = 'ID Proof Type';
  String _dateOfBirth;
  List<File> _prescriptionImgFiles = <File>[];
  String get patientState => _patientState;
  String get patientIdProofType => _patientIdProofType;
  String get dateOfBirth => _dateOfBirth;
  List<File> get prescriptionImgFiles => _prescriptionImgFiles;
  // String get pageTitle => _pageTitle;
  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;

  setFormAutoValidate(bool value) {
    _autoValidate = value;
    notifyListeners();
  }

  // setPageTitle(String pageTitle) {
  //   _pageTitle = pageTitle;
  //   notifyListeners();
  // }

  setHospitalAddress(AddressModel address) {
    _hospitalAddress = address;
    print(_hospitalAddress);
  }

  setDateOfBirth(String dob) {
    _dateOfBirth = dob;
    notifyListeners();
  }

  addImageFile(File imageFile) {
    _prescriptionImgFiles.add(imageFile);
    notifyListeners();
  }

  removeImageFile(File imageFile) {
    _prescriptionImgFiles.remove(imageFile);
    notifyListeners();
  }

  setPatientState(String state) {
    _patientState = state;
    notifyListeners();
  }

  setPatientIdProofType(String type) {
    _patientIdProofType = type;
    notifyListeners();
  }

  createMedicineRequest() {
    _helpRequest
      ..patientName = editingControllers[0].text
      ..patientDOB = _dateOfBirth
      ..idProofNumber = editingControllers[1].text
      ..idProofType = _patientIdProofType == 'Other'
          ? editingControllers[2].text
          : _patientIdProofType
      ..patientState = _patientState
      ..patientCity = editingControllers[3].text
      ..hospitalName = editingControllers[4].text
      ..hospitalAddress = _hospitalAddress
      ..illness = editingControllers[6].text
      ..requirement = editingControllers[7].text
      ..cost = editingControllers[8].text
      ..pocName = editingControllers[9].text
      ..pocNumber = editingControllers[10].text
      ..status = RequestStatus.NEW
      ..pocRelation = editingControllers[11].text;
  }

  Future _uploadImages() async {
    CloudStorageService cs = new CloudStorageService();
    _helpRequest.prescriptionImages = new List();
    var len = _prescriptionImgFiles.length;
    var cur = 1;
    for (File img in _prescriptionImgFiles) {
      print("uploading ${cur.toString()} of ${len.toString()}");
      cur += 1;
      var res = await cs.uploadImage(
          imageToUpload: img,
          section: "PrescriptionImages",
          title: "${DateTime.now().toString()}");
      _helpRequest.prescriptionImages.add(res.imageUrl);
    }
  }

  Future _uploadRequest() async {
    addMedicineRequest(_helpRequest);
  }

  Future createAndUploadMedicineRequest(BuildContext context) async {
    createMedicineRequest();
    print(_helpRequest);
    print("uploading images");
    Dialogs.showAppDialog(
        context,
        LoadingDialog(
          message: "Uploading images...",
        ));
    await _uploadImages();
    Navigator.pop(context);
    print("Uploading request data");
    Dialogs.showAppDialog(
        context,
        LoadingDialog(
          message: "Sending your request...",
        ));
    await _uploadRequest();
    Navigator.pop(context);
    print("Uploaded");
  }

  Future<void> uploadThisUser(BuildContext context) async {
    bool exist = await existsUser();
    if (exist) {
      return;
    }
    User user = new User();
    user.name = _helpRequest.pocName;
    user.phoneNumber = _helpRequest.pocNumber;
    user.volunteer = false;
    Dialogs.showAppDialog(
        context,
        LoadingDialog(
          message: "Registering your account...",
        ));
    await addUser(user);
    var u = locator<User>();
    u.clone(user);
    Navigator.pop(context);
  }

  List<TextEditingController> get editingControllers =>
      _helpRequestEditingControllers;
}
