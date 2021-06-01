class AppData {
  static const version = 0.6;

  static const playStoreLink =
      "https://play.google.com/store/apps/details?id=com.pravegak.vachankosh";

  static const statesAndUtList = <String>[
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "New Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Ladakh",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  static const welcomeMessage = '''
VachanKosh is a promise bank where people promise to help others.

There are a couple of types of promises you can make.

A monetary promise is where you promise an amount of money that you be will help with. This money will only be used to help needy people with medicines.

Apart from the monetary promise, one can also promise anything like sanitary napkins, books, notebooks, teaching hours, meals, etc.

The app stores the promise and it will reach out to you whenever help is required.

You will be directly connected with the person needing help once verification is done by the ground volunteers.

You can also make a promise regarding blood donation and opt-in to be a ground volunteer in your city.

VachanKosh does not accept any donations.
You make promises, we help you connect with ones who need them.
''';
}

class AppImages {
  static const String imagesPath = "assets/images/";
  static const String logo = imagesPath + "logo.jpg";
  static const String defaultAvatar = imagesPath + "avatars.jpg";
  static const String welcome = imagesPath + "welcome.png";
  static const String otp = imagesPath + "otp.png";
  static const String medRequestBackground = imagesPath + "meds1.jpg";
  static const String joinedHands = imagesPath + "hands_joined.png";
}

class RequestStatus {
  static const NEW = 'New';
  static const UNDER_VERIFICATION = 'Under Verification';
  static const VERIFIED = 'Verified';
  static const IN_PROGRESS = 'In Progress';
  static const COMPLETED = 'Completed';
}
