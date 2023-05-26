import 'package:flutter/material.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class TaskCategoryScreenArgument {
  List<ALL_Name_ID> editModel;

  TaskCategoryScreenArgument(this.editModel);
}

class TaskCategoryScreen extends BaseStatefulWidget {
  static const routeName = '/TaskCategoryScreen';
  final TaskCategoryScreenArgument arguments;
  TaskCategoryScreen(this.arguments);

  @override
  _TaskCategoryScreenState createState() => _TaskCategoryScreenState();
}

class _TaskCategoryScreenState extends BaseState<TaskCategoryScreen>
    with BasicScreen, WidgetsBindingObserver {
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Category = [];
  List<ALL_Name_ID> _allUsers = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    arr_ALL_Name_ID_For_Category = widget.arguments.editModel;
    _allUsers = widget.arguments.editModel;
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        NewGradientAppBar(
          title: Text('Task Category'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              top: 25,
            ),
            child: Column(
              children: [
                _buildSearchView(),
                Expanded(child: _buildInquiryList())
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 20),
          child: Text("Min. 3 chars to search TaskCategory",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _runFilter(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Tap to enter Category",
                      border: InputBorder.none,
                    ),
                    style: baseTheme.textTheme.subtitle2
                        .copyWith(color: colorBlack),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    return arr_ALL_Name_ID_For_Category.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              return _buildSearchInquiryListItem(index);
            },
            shrinkWrap: true,
            itemCount: arr_ALL_Name_ID_For_Category.length,
          )
        : Text(
            'No results found',
            style: TextStyle(fontSize: 24),
          );
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    ALL_Name_ID model = arr_ALL_Name_ID_For_Category[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(model);
        },
        child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
            child: Text(
              model.Name,
              style: baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
          ),
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  void _runFilter(String query) {
    List<ALL_Name_ID> temp = [];
    _allUsers.forEach((item) {
      if (item.Name.toLowerCase().contains(query.toLowerCase())) {
        temp.add(item);
      }
    });
    setState(() {
      arr_ALL_Name_ID_For_Category = temp;
    });
  }
}
