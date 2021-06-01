import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_constants.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/ui/shared/divider_without_padding.dart';
import 'package:vachankosh/ui/views/admin/admin.dart';
import 'package:vachankosh/ui/views/personal_info_view.dart';
import 'package:vachankosh/ui/views/user_account/select_blood_group_sheet.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/user_profile_model.dart';

import '../../../locator.dart';

class VolunteeringProfileCard extends StatelessWidget {
  VolunteeringProfileCard({
    Key key,
  }) : super(key: key);
  final user = locator<User>();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<UserProfileModel>(context);
    print(user.bloodGroup);

    return Card(
      elevation: 1.0,
      child: Container(
        padding: EdgeInsets.only(top: 16, left: 16),
        child: user.volunteer == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Volunteering Profile', style: AppStyles.k16BlueHeading),
                  ListTile(
                    leading: Icon(Icons.accessibility_new),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text('On-Ground Volunteering'),
                    trailing: Switch(
                        value: user.onGroundVolunteer,
                        onChanged: (bool value) {
                          model.changeProfileField(
                              AppConstants.kFirestoreUserOnGVField, value);
                        }),
                  ),
                  DividerWithoutPadding(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.tint),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text('Blood Donation'),
                    trailing: Switch(
                        value: model.isBloodDonor,
                        onChanged: (bool value) {
                          if (!value) {
                            model.changeProfileField(
                                AppConstants.kFirestoreUserBloodGroupField,
                                null);
                          } else {
                            showModalBottomSheet(
                                isDismissible: false,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return SelectBloodGroupSheet(model: model);
                                });
                          }
                        }),
                  ),
                  DividerWithoutPadding(),
                  if (model.isBloodDonor == true)
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return SelectBloodGroupSheet(model: model);
                            });
                      },
                      leading: Icon(FontAwesomeIcons.atom),
                      contentPadding: EdgeInsets.only(left: 8),
                      title: Text(
                          user.bloodGroup == null ? 'N/A' : user.bloodGroup),
                      subtitle: Text('Blood Group'),
                    ),
                  DividerWithoutPadding(),
                  if (user.admin == true)
                    ListTile(
                       trailing: Icon(Icons.arrow_forward_ios),
                      leading: Icon(FontAwesomeIcons.userShield),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      title: Text('Admin Panel'),
                      onTap: () =>
                          Navigator.pushNamed(context, AdminView.routeName),
                    ),
                  DividerWithoutPadding(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Volunteering Profile', style: AppStyles.k16BlueHeading),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, PersonalInfoView.routeName);
                    },
                    contentPadding: EdgeInsets.only(left: 8),
                    title: Text('Become a volunteer'),
                  ),
                  DividerWithoutPadding(),
                ],
              ),
      ),
    );
  }
}
