import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/views/medicine_request_quiz/pages/request_details_page.dart';
import 'package:vachankosh/viewmodels/create_issue_model.dart';

import 'pages/hospital_details_page.dart';
import 'pages/patient_details_page.dart';
import 'pages/point_of_contact_details_page.dart';

class CreateMedicineRequestView extends StatefulWidget {
  static const routeName = '/createMedicineRequest';

  @override
  _CreateMedicineRequestViewState createState() =>
      _CreateMedicineRequestViewState();
}

class _CreateMedicineRequestViewState extends State<CreateMedicineRequestView> {
  final _formkey = GlobalKey<FormState>();

  final _pageController = PageController();

  String title = 'Patient Details';

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page == 0) {
        title = 'Patient Details';
      } else if (_pageController.page == 1) {
        title = 'Hospital Details';
      } else if (_pageController.page == 2) {
        title = 'Requirement Details';
      } else if (_pageController.page == 3) {
        title = 'Point of Contact Details';
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<CreateIssueModel>(),
      child: Consumer<CreateIssueModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Form(
            autovalidate: model.autoValidate,
            key: _formkey,
            child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  PatientDetailsPage(
                    formkey: _formkey,
                    pageController: _pageController,
                  ),
                  HospitalDetailsPage(
                    formkey: _formkey,
                    pageController: _pageController,
                  ),
                  RequestDetailsPage(
                    formkey: _formkey,
                    pageController: _pageController,
                  ),
                  PointOfContactDetailsPage(
                    formkey: _formkey,
                    pageController: _pageController,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
