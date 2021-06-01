import 'package:flutter/foundation.dart';
import 'package:vachankosh/enums.dart';
import 'package:vachankosh/utils/objects/promise.dart';

class VolunteerQuizModel extends ChangeNotifier {
  bool _bloodDonor;
  bool _groundVolunteer;
  bool _monetaryPromise;
  bool _otherPromise;
  bool _autoValidatePromiseForm = false;

  bool get isBloodDonor => _bloodDonor;
  bool get isGroundVolunteer => _groundVolunteer;
  bool get madeMonetaryPromise => _monetaryPromise;
  bool get madeOtherPromise => _otherPromise;
  bool get autoValidatePromiseForm => _autoValidatePromiseForm;

  String _bloodGroup;
  String _monetaryAmount;
  String _monetaryPromisePlan;
  String _otherPromisePlan;

  List<Promise> _otherPromises = [];
  List<Promise> get otherPromises => _otherPromises;

  String get bloodGroup => _bloodGroup;
  String get monetaryAmount => _monetaryAmount;
  String get monetaryPromisePlan => _monetaryPromisePlan;
  String get otherPromisePlan => _otherPromisePlan;

  bool primaryQuestionState(VolunteerQuestion question) {
    if (question == VolunteerQuestion.BloodDonor) {
      return _bloodDonor;
    }
    if (question == VolunteerQuestion.GroundVolunteer) {
      return _groundVolunteer;
    }
    if (question == VolunteerQuestion.MonetaryPromise) {
      return _monetaryPromise;
    }
    if (question == VolunteerQuestion.OtherPromise) {
      return _otherPromise;
    }
    return false;
  }

  changePrimaryQuestionState(VolunteerQuestion questionType, bool value) {
    switch (questionType) {
      case VolunteerQuestion.BloodDonor:
        _bloodDonor = value;
        if (value == false) {
          _bloodGroup = null;
        }
        notifyListeners();
        break;

      case VolunteerQuestion.GroundVolunteer:
        _groundVolunteer = value;
        notifyListeners();
        break;

      case VolunteerQuestion.MonetaryPromise:
        _monetaryPromise = value;
        notifyListeners();
        if (value == false) {
          _monetaryAmount = '';
          _monetaryPromisePlan = null;
        }
        break;

      case VolunteerQuestion.OtherPromise:
        _otherPromise = value;
        if (value == false) {
          otherPromises.clear();
        }
        notifyListeners();
    }
  }

  changeBloodGroup(String bloodGroup) {
    _bloodGroup = bloodGroup;
    notifyListeners();
  }

  setAutoValidateForm(bool value) {
    _autoValidatePromiseForm = value;
    notifyListeners();
  }

  changeMonetaryPromisePlan(String monetaryPromisePlan) {
    _monetaryPromisePlan = monetaryPromisePlan;
    notifyListeners();
  }

  changeOtherPromisePlan(String otherPromisePlan) {
    _otherPromisePlan = otherPromisePlan;
    notifyListeners();
  }

  addOtherPromise(Promise promise) {
    otherPromises.add(promise);
    notifyListeners();
  }

  removePromise(Promise promise) {
    otherPromises.remove(promise);
    notifyListeners();
  }

  setMonetaryAmount(String amount) {
    _monetaryAmount = amount;
    notifyListeners();
  }

  editPromise(Promise old, Promise updated) {
    otherPromises.remove(old);
    otherPromises.add(updated);
    notifyListeners();
  }
}
