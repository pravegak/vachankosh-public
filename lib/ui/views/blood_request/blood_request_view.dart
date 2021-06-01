import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BloodRequestView extends StatefulWidget {
  static const routeName = '/bloodRequest';

  @override
  _BloodRequestViewState createState() => _BloodRequestViewState();
}

class _BloodRequestViewState extends State<BloodRequestView> {
  int currentStep = 0;
  bool complete = false;

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  List _steps;

  next() {
    currentStep + 1 != _steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
    print(currentStep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Blood Request'),
      ),
      body: Container(
        child: Form(
          child: Stepper(
            steps: [
              Step(
                isActive: currentStep == 0,
                title: const Text('Patient'),
                content: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                   TextFormField(
                      decoration: InputDecoration(labelText: 'Date of Birth'),
                    ),
                  ],
                ),
              ),
              Step(
                  title: const Text('Hospital'),
                  isActive: currentStep == 1,
                  content: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Hospital Name'),
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Hospital Address'),
                      )
                    ],
                  )),
              Step(
                  title: const Text('Requirements'),
                  isActive: currentStep == 2,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BloodGroupSelector(),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Units'),
                      ),
                      CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        onChanged: (c) {},
                        title: const Text('Family Member'),
                      ),
                      CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        onChanged: (c) {},
                        title: const Text('Exchange Possible'),
                      ),
                      CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        onChanged: (c) {},
                        title: const Text('Platelets'),
                      ),
                    ],
                  )),
              Step(
                  title: const Text('Illness'),
                  isActive: currentStep == 3,
                  content: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Disease'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          FlatButton.icon(
                            padding: EdgeInsets.all(0),
                            icon: Icon(FontAwesomeIcons.folderPlus),
                            label: Text('Add prescription image'),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  )),
              Step(
                  title: const Text('Point of Contact'),
                  isActive: currentStep == 4,
                  content: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone No'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Alternate No'),
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Relation with Patient'),
                      ),
                    ],
                  )),
            ],
            currentStep: currentStep,
            onStepContinue: next,
            onStepTapped: (step) {
              setState(() {
                currentStep = step;
              });
            },
            onStepCancel: cancel,
          ),
        ),
      ),
    );
  }
}

class BloodGroupSelector extends StatelessWidget {
  final bloodGroups = {
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Blood Group',
            style: const TextStyle(color: Colors.blue, fontSize: 16)),
        Wrap(
          children: bloodGroups
              .map(
                (e) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(value: true, groupValue: false, onChanged: (t) {}),
                    Text(e),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
