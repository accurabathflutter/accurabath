import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/InquiryShareModel.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class AddProductPriceListScreenArguments {
  // List<ALL_Name_ID> arr_inquiry_share_emp_list;
  String ModuleName;
  AddProductPriceListScreenArguments(
      /*this.arr_inquiry_share_emp_list,*/ this.ModuleName);
}

class ProductPriceListScreen extends BaseStatefulWidget {
  static const routeName = '/ProductPriceListScreen';
  final AddProductPriceListScreenArguments arguments;

  ProductPriceListScreen(this.arguments);

  @override
  _ProductPriceListScreenState createState() => _ProductPriceListScreenState();
}

class _ProductPriceListScreenState extends BaseState<ProductPriceListScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  InquiryShareModel inquiryShareModel;
  List<PriceModel> arrinquiryShareModel = [];
  String _ModuleName = "";

  //CustomerSourceResponse _offlineCustomerSource;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  String _InQNo;

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

      print("jdfjjfdfs" + _ModuleName);
      //   _arr_inquiry_share_emp_list = widget.arguments.arr_inquiry_share_emp_list;
      // arrinquiryShareModel = _arr_inquiry_share_emp_list;

      getPriceList();
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
    Navigator.of(context).pop(arrinquiryShareModel);

    // navigateTo(context, SalesBillListScreen.routeName, clearAllStack: true);

    /* for (var i = 0; i < arrinquiryShareModel.length; i++) {
      print("DDFDrdfdj" +
          arrinquiryShareModel[i].priceName +
          "Checked" +
          arrinquiryShareModel[i].isChecked.toString());
    }

    var value = arrinquiryShareModel
        .where((item) => item.isChecked == "true" ? true : false)
        .length;

    if (value == arrinquiryShareModel.length) {
      showCommonDialogWithSingleOption(
          context, "Select Any One " + _ModuleName + " No. !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.pop(context);
      });
    } else {
      // arrinquiryShareModel.removeWhere((item) => item.isChecked == false);

      List<PriceModel> temparray = [];
      temparray.addAll(arrinquiryShareModel);
      temparray.removeWhere((item) => item.isChecked == "true" ? true : false);
      Navigator.of(context).pop(arrinquiryShareModel);
      // _inquiryBloc.add(InquiryShareModelCallEvent(arrinquiryShareModel));
    }*/
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return getCommonButton(baseTheme, () async {
      print("ChekLst" + "IS Check : " + "ggeggddffgdfgdgdgf");

      for (int i = 0; i < arrinquiryShareModel.length; i++) {
        print("ChekLst" + "IS Check : " + arrinquiryShareModel[i].isChecked);
      }
      /* var value = arrinquiryShareModel
          .where((item) => item.isChecked == "true" ? true : false)
          .length;

      if (value == arrinquiryShareModel.length) {
        showCommonDialogWithSingleOption(
            context, "Select Any One " + _ModuleName + " No. !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      } else {
        // arrinquiryShareModel.removeWhere((item) => item.isChecked == false);

        for (var i = 0; i < arrinquiryShareModel.length; i++) {
          print("arrinquiryShareModel" +
              arrinquiryShareModel[i].priceName +
              "Checked" +
              arrinquiryShareModel[i].isChecked.toString());
        }
        List<PriceModel> temparray = [];
        temparray.addAll(arrinquiryShareModel);
        temparray
            .removeWhere((item) => item.isChecked == "true" ? true : false);

        Navigator.of(context).pop(temparray);
        // _inquiryBloc.add(InquiryShareModelCallEvent(arrinquiryShareModel));
      }*/
      Navigator.of(context).pop(arrinquiryShareModel);
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
    PriceModel model = arrinquiryShareModel[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(model);
        },
        child: CheckboxListTile(
          value: /*model.isChecked == null ? false : */
              model.isChecked.toString() == "true" ? true : false,
          onChanged: (value) {
            setState(
              () {
                model.isChecked =
                    value.toString(); //== true ? "true" : "false";
                arrinquiryShareModel[index] = model;
              },
            );
          },
          title: Text(model.SizeName),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }

  void getPriceList() {
    getdetails();
  }

  void getdetails() async {
    arrinquiryShareModel = await OfflineDbHelper.getInstance()
        .getProductPriceList(widget.arguments.ModuleName);
    setState(() {});
  }
}
