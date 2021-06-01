calculateAge({int birthYear, int birthMonth, int birthDay}) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthYear;
  int month1 = currentDate.month;
  int month2 = birthMonth;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDay;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

getDateString(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
}
