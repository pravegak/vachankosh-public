import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/error_dialog.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';

enum ViewState { Idle, OtpSent, Success }

class LoginModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  final _firebaseAuth = FirebaseAuth.instance;
  String codeSent = "";
  ViewState get state => _state;

  authenticateWithPhoneNo(String phoneNo, BuildContext context) async {
    Dialogs.showAppDialog(
        context,
        LoadingDialog(
          message: 'Sending OTP...',
        ));
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo.trim(),
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential authCredential) async {
          var result = await _signInWithCredential(authCredential);
          if (result is bool) {
            if (result) {
              setState(ViewState.Success);
            } else {
              Dialogs.showAppDialog(
                  context,
                  ErrorDialog(
                    error: 'Login Error',
                    errorDescription:
                        "Couldn't login at this moment. Please try again later.",
                  ));
            }
          } else {
            Dialogs.showAppDialog(
                context,
                ErrorDialog(
                  error: 'Login Error',
                  errorDescription: result,
                ));
          }
        },
        verificationFailed: (AuthException exception) {
          Navigator.pop(context);
          print("Failed Callbac: ${exception.message}");
          Dialogs.showAppDialog(
              context,
              ErrorDialog(
                error: 'Login Error',
                errorDescription: exception.message,
              ));
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          Navigator.pop(context);
          setState(ViewState.OtpSent);
          codeSent = verificationId;
        },
        codeAutoRetrievalTimeout: (String msg) {
          Navigator.pop(context);
          print("Msg: $msg");
        });
  }

  verifyCodeAndSignIn(BuildContext context, String codeEntered) async {
    Dialogs.showAppDialog(
        context,
        LoadingDialog(
          message: 'Verifying...',
        ));
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: codeSent, smsCode: codeEntered);
    var result = await _signInWithCredential(authCredential);
    if (result is bool) {
      if (result) {
        setState(ViewState.Success);
      } else {
        Dialogs.showAppDialog(
            context,
            ErrorDialog(
              error: 'Login Error',
              errorDescription:
                  "Couldn't login at this moment. Please try again later.",
            ));
      }
    } else {
      Navigator.pop(context);
      Dialogs.showAppDialog(
          context,
          ErrorDialog(
            error: 'Login Error',
            errorDescription: result,
          ));
    }
  }

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  Future _signInWithCredential(AuthCredential authCredential) async {
    try {
      AuthResult authResult =
          await _firebaseAuth.signInWithCredential(authCredential);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }
}
