import 'dart:async';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/views/about_app.dart';
import 'package:vachankosh/ui/views/registration_reason_view.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/ui/views/dashboard/userhome.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/shared_preferences.dart';
import 'package:vachankosh/viewmodels/login_model.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'startup_view.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController phoneNoEditingController;
  StreamController _phoneNoValidator;
  String countryCode;
  @override
  void initState() {
    super.initState();
    phoneNoEditingController = TextEditingController();
    _phoneNoValidator = StreamController<String>.broadcast();
    countryCode = "91";
  }

  @override
  void dispose() {
    _phoneNoValidator.close();
    print("Stream closed");
    super.dispose();
  }

  showWelcomeDialog(BuildContext context) async {
    bool firstTimeLoaded = await getBoolFromShared('first_time_loaded');
    if (firstTimeLoaded == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              insetPadding: EdgeInsets.all(10),
              scrollable: true,
              title: Text("Welcome"),
              content: Text(AppData.welcomeMessage),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      storeBoolInShared('first_time_loaded', true);
                    },
                    child: Text("Sounds good!"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showWelcomeDialog(context));
    return ChangeNotifierProvider<LoginModel>(
      create: (context) => locator<LoginModel>(),
      child: Consumer<LoginModel>(
        builder: (context, model, child) => Scaffold(
          body: buildView(context, model),
        ),
      ),
    );
  }

  Widget buildView(BuildContext context, LoginModel model) {
    if (model.state == ViewState.OtpSent) {
      return OtpView();
    } else if (model.state == ViewState.Success) {
      User user = locator<User>();
      user.phoneNumber = "+$countryCode${phoneNoEditingController.text}";
      profileCompleted(user.phoneNumber).then((value) async {
        if (value != null && value) {
          var currentUser = await getCurrentUser();
          user.clone(currentUser);
          Navigator.pushNamedAndRemoveUntil(
              context, UserHomeView.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RegistrationReasonView.routeName, (route) => false);
        }
      });
    } else {
      return buildLogin(context, model);
    }
  }

  Widget buildLogin(BuildContext context, LoginModel model) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AboutAppView.routeName);
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(AppImages.welcome),
                    SizedBox(
                      height: 30,
                    ),
                    Neumorphic(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        border: NeumorphicBorder(
                          color: Colors.brown[50],
                          width: 0.8,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Enter Mobile Number',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    maxLength: 10,
                                    onChanged: (text) {
                                      _phoneNoValidator.sink.add(text);
                                    },
                                    controller: phoneNoEditingController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black38),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2),
                                      ),
                                      counterText: "",
                                      prefix: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                print('Country Code clicked!');
                                                showCountryCodePicker(context);
                                              },
                                              child: Text("+$countryCode ")),
                                          Container(
                                            height: 20,
                                            width: 1.5,
                                            color: Colors.black38,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(
                              "A 6-digit OTP will be send via SMS to verify your mobile number!",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black26),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: StreamBuilder(
                                stream: _phoneNoValidator.stream,
                                builder: (context, snapshot) {
                                  return RaisedButton(
                                    child: Text(
                                      'CONTINUE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    textColor: Colors.white,
                                    color: AppColors.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    // ignore: null_aware_before_operator
                                    onPressed: (snapshot.data == null ||
                                            ((countryCode == '91' &&
                                                    snapshot.data.length <
                                                        10) ||
                                                snapshot.data.length < 1))
                                        ? null
                                        : () {
                                            User user = locator<User>();
                                            user.phoneNumber = "+" +
                                                countryCode +
                                                phoneNoEditingController.text;
                                            model.authenticateWithPhoneNo(
                                                user.phoneNumber, context);
                                          },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showCountryCodePicker(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
              popOnPick: true,
              onValuePicked: (value) {
                setState(() {
                  countryCode = value.phoneCode;
                });
              },
              title: Text('Select your country code'),
              isSearchable: true,
              priorityList: [
                CountryPickerUtils.getCountryByIsoCode('IN'),
              ],
              itemBuilder: (country) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CountryPickerUtils.getDefaultFlagImage(country),
                      Text('  ${country.iso3Code}'),
                    ],
                  ),
                  Text('+${country.phoneCode}'),
                ],
              ),
            ));
  }
}

class OtpView extends StatelessWidget {
  final TextEditingController _otpEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context);
    User user = locator<User>();
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                      onPressed: () {
                        model.setState(ViewState.Idle);
                      },
                    ),
                  )
                ],
              ),
              Container(
                child: Image.asset(AppImages.otp),
                height: 300,
                width: 400,
              ),
              SizedBox(
                height: 40,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                  border: NeumorphicBorder(
                    color: Colors.blue[50],
                    width: 0.8,
                  ),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'OTP Verification',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Enter the OTP sent to ",
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: "${user.phoneNumber}",
                                style: TextStyle(color: Colors.black))
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _otpEditingController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RaisedButton(
                      child: Text(
                        'Verify & Proceed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textColor: Colors.white,
                      color: AppColors.primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        model.verifyCodeAndSignIn(
                            context, _otpEditingController.text);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Didn't receive the OTP?",
                      style: TextStyle(
                          color: Colors.black38, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                      future: Future.delayed(Duration(seconds: 30)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Resend in ",
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold),
                              ),
                              TimerWidget(30),
                            ],
                          );
                        }
                        return FlatButton(
                            onPressed:
                                snapshot.connectionState == ConnectionState.done
                                    ? () {
                                        model.authenticateWithPhoneNo(
                                            user.phoneNumber, context);
                                      }
                                    : null,
                            textColor: Colors.orange,
                            child: Text(
                              'RESEND OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  final int counter;
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
  const TimerWidget(this.counter);
}

class _TimerWidgetState extends State<TimerWidget> {
  int _counter;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _counter = widget.counter;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "00:" + _counter.toString().padLeft(2, '0'),
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
