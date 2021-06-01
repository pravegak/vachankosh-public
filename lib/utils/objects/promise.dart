class Promise {
  final String monetary = 'monetary';

  // object which the person is promising
  // monetary, or anything else
  String object;

  // Quantity which is promised
  int quantity;

  // whether the promise if montly or yearly
  String time;

  // unit of the promise offered
  String unit;

  // map of expenditures which user has made of this promise
  // contains a map where quantity is the key
  // and value is a map which conatins request ID of the request
  // where expense was made and time when it was done
  Map<String, Map> expenses;

  // represents the current State of the promise i.e. how much
  // quantity is left and when will the quantity be refilled
  Map<String, int> currentState;

  Promise(String object, int quantity, String time, String unit) {
    if (object == null) {
      object = monetary;
    }
    this.object = object;
    this.quantity = quantity;
    this.time = time;
    this.unit = unit;
    this.expenses = {};
    this.currentState = {};
    this.currentState['quantityLeft'] = quantity;
    if (time == 'Monthly') {
      this.currentState['nextRefill'] = 30;
    } else if (time == 'Quarterly') {
      this.currentState['nextRefill'] = 120;
    } else {
      this.currentState['nextRefill'] = 365;
    }
  }

  Map<String, dynamic> toMap() {
    var res = Map<String, dynamic>();
    res['object'] = this.object;
    res['quantity'] = this.quantity;
    res['time'] = this.time;
    res['unit'] = this.unit;
    res['expenses'] = {};
    this.expenses.forEach((key, value) {
      res['expenses'][key] = value;
    });
    res['currentState'] = this.currentState;
    return res;
  }

  Promise.fromMap(Map data) {
    this.object = data['object'];
    this.quantity = data['quantity'];
    this.time = data['time'];
    this.unit = data['unit'];
    this.expenses = {};
    if (data['expenses'] == null) {
      return;
    }
    data['expenses'].forEach((k, v) {
      this.expenses[k] = v;
    });
    this.currentState = Map<String, int>.from(data['currentState']);
  }

  // deep copies a promise object in current one
  void clone(Promise p) {
    this.object = p.object;
    this.quantity = p.quantity;
    this.time = p.time;
    this.unit = p.unit;
    this.expenses = p.expenses;
    this.currentState = p.currentState;
  }
}
