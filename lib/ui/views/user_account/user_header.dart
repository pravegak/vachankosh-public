import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/services/edit_profile_service.dart';
import 'package:vachankosh/ui/dialogs/image_source_picker_dialog.dart';
import 'package:vachankosh/ui/views/user_account/user_profile_view.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/profile_image_widget_model.dart';
import 'package:vachankosh/viewmodels/user_profile_model.dart';

import '../../../locator.dart';

class UserHeader extends StatelessWidget {
  UserHeader({
    Key key,
  }) : super(key: key);

  final user = locator<User>();
  final service = locator<EditProfileService>();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<UserProfileModel>(context);
    return Card(
      elevation: 1.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            ProfilePictureWidget(),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                showEditFieldBottomSheet(context,
                    previousValue: user.name,
                    heading: 'Edit your name',
                    model: model, validator: (String value) {
                  if (value.length < 3)
                    return 'Name field length cannot be less than 3 characters';
                  return null;
                }, field: 'name');
              },
              child: Text(
                user.name,
                style: AppStyles.k20BlackHeading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePictureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<ProfileImageWidgetModel>(),
      child: Consumer<ProfileImageWidgetModel>(
        builder: (context, model, child) => Stack(
          children: <Widget>[
            Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: locator<User>().imageUrl == null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(AppImages.defaultAvatar),
                    )
                  : CachedNetworkImage(
                      imageUrl: locator<User>().imageUrl,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 40,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue[50],
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(AppImages.defaultAvatar)),
                    ),
            ),
            Positioned(
              left: 55,
              top: 55,
              child: GestureDetector(
                onTap: () async {
                  final source = await showDialog(
                      context: context,
                      builder: (context) => ImageSourcePickerDialog());
                  model.selectImage(source, context);
                },
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
