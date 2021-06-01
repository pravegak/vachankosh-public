import 'package:get_it/get_it.dart';
import 'package:vachankosh/services/admin_service.dart';
import 'package:vachankosh/services/cloud_storage_service.dart';
import 'package:vachankosh/services/edit_profile_service.dart';
import 'package:vachankosh/services/location_search_service.dart';
import 'package:vachankosh/services/push_notification_service.dart';
import 'package:vachankosh/ui/views/user_account/user_profile_view.dart';
import 'package:vachankosh/utils/image_selector.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/admin.dart';
import 'package:vachankosh/viewmodels/create_issue_model.dart';
import 'package:vachankosh/viewmodels/help_request_detail_model.dart';
import 'package:vachankosh/viewmodels/login_model.dart';
import 'package:vachankosh/viewmodels/profile_image_widget_model.dart';
import 'package:vachankosh/viewmodels/userhome.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';
import 'services/help_request_service.dart';

GetIt locator = GetIt.I;
void setupLocator() {
  locator.registerLazySingleton(() => User());
  //Register ViewModels
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => AdminModel());
  locator.registerFactory(() => VolunteerQuizModel());
  locator.registerFactory(() => ProfileImageWidgetModel());
  locator.registerFactory(() => CreateIssueModel());
  locator.registerFactory(() => UserHomeModel());
  locator.registerFactory(() => MedicineRequestDetailModel());

  //Register Services
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => LocationSearchService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => MedicineRequestService());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => EditProfileService());
  locator.registerLazySingleton(() => AdminService());
}
