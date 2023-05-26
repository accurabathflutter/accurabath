import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/InquiryShareModel.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class AddModuleNoScreenArguments {
  List<ALL_Name_ID> arr_inquiry_share_emp_list;
  String ModuleName;
  AddModuleNoScreenArguments(this.arr_inquiry_share_emp_list, this.ModuleName);
}

class ModuleNoListScreen extends BaseStatefulWidget {
  static const routeName = '/ModuleNoListScreen';
  final AddModuleNoScreenArguments arguments;

  ModuleNoListScreen(this.arguments);

  @override
  _ModuleNoListScreenState createState() => _ModuleNoListScreenState();
}

class _ModuleNoListScreenState extends BaseState<ModuleNoListScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  InquiryShareModel inquiryShareModel;
  List<ALL_Name_ID> arrinquiryShareModel = [];
  String _ModuleName = "";

  //CustomerSourceResponse _offlineCustomerSource;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  String _InQNo;
  List<ALL_Name_ID> _arr_inquiry_share_emp_list = [];

  List<bool> _isChecked;
  bool isselected = false;
  GroupController controller = GroupController();

  List<String> OnlyEMPLIST = [];
  List<int> OnlyEMPLISTINT = [];
  ALL_EmployeeList_Response _offlineALLEmployeeListData;

  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      _ModuleName = widget.arguments.ModuleName;
      _arr_inquiry_share_emp_list.clear();
      _arr_inquiry_share_emp_list = widget.arguments.arr_inquiry_share_emp_list;
      arrinquiryShareModel = _arr_inquiry_share_emp_list;
    }
    screenStatusBarColor = colorPrimaryLight;
    // _offlineCustomerSource= SharedPrefHelper.instance.getCustomerSourceData();
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _inquiryBloc = InquiryBloc(baseBloc);
    /* _inquiryBloc.add(FollowerEmployeeListCallEvent(FollowerEmployeeListRequest(
        CompanyId: CompanyID.toString(), LoginUserID: "admin")));*/
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Column(
        children: [
          getCommonAppBar(context, baseTheme, _ModuleName, showBack: false),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(
                    left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                    right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                    top: 25,
                  ),
                  child: Column(
                    children: [
                      Expanded(child: _buildProductList()),
                      _buildSearchView(),
                    ],
                  ))),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    // navigateTo(context, SalesBillListScreen.routeName, clearAllStack: true);

    var value =
        arrinquiryShareModel.where((item) => item.isChecked == false).length;

    if (value == arrinquiryShareModel.length) {
      showCommonDialogWithSingleOption(
          context, "Select Any One " + _ModuleName + " No. !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.pop(context);
      });
    } else {
      // arrinquiryShareModel.removeWhere((item) => item.isChecked == false);

      for (var i = 0; i < arrinquiryShareModel.length; i++) {
        print("DDFDr" +
            arrinquiryShareModel[i].Name +
            "Checked" +
            arrinquiryShareModel[i].isChecked.toString());
      }
      List<ALL_Name_ID> temparray = [];
      temparray.addAll(arrinquiryShareModel);
      temparray.removeWhere((item) => item.isChecked == false);
      Navigator.of(context).pop(temparray);
      // _inquiryBloc.add(InquiryShareModelCallEvent(arrinquiryShareModel));
    }
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return getCommonButton(baseTheme, () {
      var value =
          arrinquiryShareModel.where((item) => item.isChecked == false).length;

      if (value == arrinquiryShareModel.length) {
        showCommonDialogWithSingleOption(
            context, "Select Any One " + _ModuleName + " No. !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      } else {
        // arrinquiryShareModel.removeWhere((item) => item.isChecked == false);

        for (var i = 0; i < arrinquiryShareModel.length; i++) {
          print("DDFDr" +
              arrinquiryShareModel[i].Name +
              "Checked" +
              arrinquiryShareModel[i].isChecked.toString());
        }
        List<ALL_Name_ID> temparray = [];
        temparray.addAll(arrinquiryShareModel);
        temparray.removeWhere((item) => item.isChecked == false);

        Navigator.of(context).pop(temparray);
        // _inquiryBloc.add(InquiryShareModelCallEvent(arrinquiryShareModel));
      }

      //
    }, "Submit");
  }

  ///builds product list
  Widget _buildProductList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildSearchProductListItem(index);
      },
      shrinkWrap: true,
      itemCount: arrinquiryShareModel.length,
    );
  }

  ///builds row item view of inquiry list
  Widget _buildSearchProductListItem(int index) {
    ALL_Name_ID model = arrinquiryShareModel[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(model);
        },
        child: CheckboxListTile(
          value: model.isChecked == null ? false : model.isChecked,
          onChanged: (value) {
            setState(
              () {
                model.isChecked = value;
                arrinquiryShareModel[index] = model;
              },
            );
          },
          title: Text(model.Name),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }
}
