import 'package:flutter/material.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';

import 'contacts_list_screen.dart';

class ContactsCrudDemo extends BaseStatefulWidget {
  static const routeName = '/contactsCrudDemo';

  @override
  _ContactsCrudDemoState createState() => _ContactsCrudDemoState();
}

class _ContactsCrudDemoState extends BaseState<ContactsCrudDemo>
    with BasicScreen, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        getCommonAppBar(context, baseTheme, "Contacts crud demo",
            showBack: false),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.bottomCenter,
                child: getCommonButton(baseTheme, () {
                  //  _onTapOfDeleteALLContact();
                  navigateTo(context, ContactsListScreen.routeName);
                }, "Add Contact", width: 200),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onTapOfDeleteALLContact() async {
    await OfflineDbHelper.getInstance().deleteContactTable();
  }
}
