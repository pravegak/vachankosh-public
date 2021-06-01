import 'package:flutter/material.dart';
import 'package:vachankosh/ui/views/about_app.dart';
import 'package:vachankosh/ui/views/admin/admin.dart';
import 'package:vachankosh/ui/views/admin/admin_user_info.dart';
import 'package:vachankosh/ui/views/admin/stats_view.dart';
import 'package:vachankosh/ui/views/blood_request/blood_request_view.dart';
import 'package:vachankosh/ui/views/choose_request_category.dart';
import 'package:vachankosh/ui/views/help_request_detail_view.dart';
import 'package:vachankosh/ui/views/medicine_request_quiz/create_issue_view.dart';
import 'package:vachankosh/ui/views/feedback_view.dart';
import 'package:vachankosh/ui/views/login_view.dart';
import 'package:vachankosh/ui/views/no_internet.dart';
import 'package:vachankosh/ui/views/not_completed.dart';
import 'package:vachankosh/ui/views/offer_help_view.dart';
import 'package:vachankosh/ui/views/personal_info_view.dart';
import 'package:vachankosh/ui/views/prescription_images_view.dart';
import 'package:vachankosh/ui/views/registration_reason_view.dart';
import 'package:vachankosh/ui/views/startup_view.dart';
import 'package:vachankosh/ui/views/update_app.dart';
import 'package:vachankosh/ui/views/user_account/user_profile_view.dart';
import 'package:vachankosh/ui/views/user_promises_view.dart';
import 'package:vachankosh/ui/views/dashboard/userhome.dart';
import 'package:vachankosh/ui/views/verify_request_view.dart';
import 'package:vachankosh/ui/views/volunteer_quiz/volunteer_quiz_view.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import '../ui/views/dashboard/ground_report_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginView.routeName:
        return MaterialPageRoute(builder: (context) => LoginView());
      case PersonalInfoView.routeName:
        return MaterialPageRoute(
            builder: (context) => PersonalInfoView(), settings: settings);
      case UserHomeView.routeName:
        return MaterialPageRoute(builder: (context) => UserHomeView());
      case VolunteerQuizView.routeName:
        return MaterialPageRoute(
            builder: (context) => VolunteerQuizView(
                  addressPrediction: settings.arguments,
                ));
      case AdminView.routeName:
        return MaterialPageRoute(builder: (context) => AdminView());
      case UpdateApp.routeName:
        return MaterialPageRoute(builder: (context) => UpdateApp());
      case NoInternetView.routeName:
        return MaterialPageRoute(builder: (context) => NoInternetView());
      case StartupView.routeName:
        return MaterialPageRoute(builder: (context) => StartupView());
      case FeedbackView.routeName:
        return MaterialPageRoute(builder: (context) => FeedbackView());
      case UserProfileView.routeName:
        return MaterialPageRoute(builder: (context) => UserProfileView());
      case AdminUserInfoView.routeName:
        return MaterialPageRoute(
            builder: (context) => AdminUserInfoView(), settings: settings);
      case CreateMedicineRequestView.routeName:
        return MaterialPageRoute(
            builder: (context) => CreateMedicineRequestView());
      case RegistrationReasonView.routeName:
        return MaterialPageRoute(
            builder: (context) => RegistrationReasonView(), settings: settings);
      case UserPromisesView.routeName:
        return MaterialPageRoute(builder: (context) => UserPromisesView());
      // return PageRouteBuilder(
      //     opaque: true,
      //     transitionDuration: const Duration(milliseconds: 250),
      //     pageBuilder: (BuildContext context, _, __) {
      //       return UserPromisesView();
      //     },
      //     transitionsBuilder:
      //         (_, Animation<double> animation, __, Widget child) {
      //       return new SlideTransition(
      //         child: child,
      //         position: new Tween<Offset>(
      //           begin: const Offset(0.1, 0),
      //           end: Offset.zero,
      //         ).animate(animation),
      //       );
      //     });
      case MedicineRequestDetailView.routeName:
        return MaterialPageRoute(
          builder: (context) => MedicineRequestDetailView(
              requestId: settings.arguments as String),
        );
      case PrescriptionImagesView.routeName:
        return MaterialPageRoute(
            builder: (context) => PrescriptionImagesView(
                  prescriptionImageUrls: settings.arguments as List<String>,
                ));
      case OfferHelpView.routeName:
        return MaterialPageRoute(
            builder: (context) => OfferHelpView(
                  helpRequest: settings.arguments as MedicineRequest,
                ));

      case VerifyRequestView.routeName:
        return MaterialPageRoute(
            builder: (context) => VerifyRequestView(
                  helpRequest: settings.arguments as MedicineRequest,
                ));
      case NotCompleteView.routeName:
        return MaterialPageRoute(builder: (context) => NotCompleteView());
      case ChooseRequestCategoryView.routeName:
        return MaterialPageRoute(
            builder: (context) => ChooseRequestCategoryView());
      case GroundReportView.routeName:
        return MaterialPageRoute(builder: (context) => GroundReportView());
      case AboutAppView.routeName:
        return MaterialPageRoute(builder: (context) => AboutAppView());
      case StatsView.routeName:
        return MaterialPageRoute(builder: (context) => StatsView());
      case BloodRequestView.routeName:
        return MaterialPageRoute(builder: (context) => BloodRequestView());
      default:
        return MaterialPageRoute(builder: (context) => LoginView());
    }
  }
}
