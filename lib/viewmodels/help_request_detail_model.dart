import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';

import '../locator.dart';

class MedicineRequestDetailModel extends ChangeNotifier {
  final helpRequestService = locator<MedicineRequestService>();

  // Future<bool> assignRequestVerification(
  //     String userId, String helpRequestId, BuildContext context) async {
  //   Dialogs.showAppDialog(
  //       context,
  //       LoadingDialog(
  //         message: 'Assigning...',
  //       ));
  //   // var result = await helpRequestService.assignRequestVerification(
  //   //    helpRequestId, userId);
  //   Navigator.pop(context);
  //   if (result is bool) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<bool> verifyRequest(String helpRequestId, BuildContext context) async {
  //   Dialogs.showAppDialog(
  //       context,
  //       LoadingDialog(
  //         message: 'Verifying...',
  //       ));
  //   var result = await helpRequestService.verifyRequest(helpRequestId);
  //   Navigator.pop(context);
  //   if (result is bool) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
