import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/dealer/dealer_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/sales_bill/list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/sales_bill/other_charges/add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/sales_bill/product_details/list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotation_general_customer_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../models/api_responses/customer/customer_label_value_response.dart';
import '../../../../widgets/common_widgets.dart';

class AddUpdateDSaleBillAddEditScreenArguments {
  QuotationDetails editModel;

  AddUpdateDSaleBillAddEditScreenArguments(this.editModel);
}

class DSaleBillAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/DSaleBillAddEditScreen';
  final AddUpdateDSaleBillAddEditScreenArguments arguments;

  DSaleBillAddEditScreen(this.arguments);

  @override
  BaseState<DSaleBillAddEditScreen> createState() =>
      _DSaleBillAddEditScreenState();
}

class _DSaleBillAddEditScreenState extends BaseState<DSaleBillAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  DealerBloc _dealerBloc;

  final TextEditingController edt_ComplanitDate = TextEditingController();
  final TextEditingController edt_ReverseComplanitDate =
      TextEditingController();
  final TextEditingController edt_Dealer_Name = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  double CardViewHieght = 45;

  final TextEditingController edt_TermConditionHeader = TextEditingController();
  final TextEditingController edt_TermConditionHeaderID =
      TextEditingController();

  final TextEditingController edt_TermConditionFooter = TextEditingController();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TermConditionList = [];

  final TextEditingController edt_StateCode = TextEditingController();
  final TextEditingController edt_HeaderDisc = TextEditingController();

  final TextEditingController edt_PrviousBalance = TextEditingController();

  QuotationDetails _editModel;
  bool _isForUpdate;
  SearchDetails _searchInquiryListResponse;

  List<File> MultipleVideoList = [];
  final imagepicker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dealerBloc = DealerBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _dealerBloc = DealerBloc(baseBloc);
    edt_StateCode.text = _offlineLoggedInData.details[0].stateCode.toString();
    edt_HeaderDisc.text = "0.00";
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    edt_Dealer_Name.text = "Test customer";

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      // fillData();
    } else {
      edt_ComplanitDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseComplanitDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();
      edt_StateCode.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dealerBloc,
      child: BlocConsumer<DealerBloc, DealerStates>(
        builder: (BuildContext context, DealerStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, DealerStates state) {
          if (state is QuotationTermsCondtionResponseState) {
            _OnTermConditionListResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is QuotationTermsCondtionResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Sales Bill Details'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  top: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFollowupDate(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    Customer_Name(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    DelaerName(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    PreviousBalance(),
                    TermsConditionList("Select Term & Condition",
                        enable1: false,
                        title: "Select Term & Condition",
                        hintTextvalue: "Tap to Select Term & Condition",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_TermConditionHeader,
                        controllerpkID: edt_TermConditionHeaderID,
                        Custom_values1: arr_ALL_Name_ID_For_TermConditionList),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Term & Condition",
                          style: TextStyle(
                              fontSize: 12,
                              color: colorPrimary,
                              fontWeight: FontWeight
                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                          ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7, right: 7, top: 10),
                      child: TextFormField(
                        controller: edt_TermConditionFooter,
                        minLines: 2,
                        maxLines: 15,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Enter Notes',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        //  _onTapOfDeleteALLContact();
                        //  navigateTo(context, InquiryProductListScreen.routeName);
                        navigateTo(
                            context, DSaleBillProductListScreen.routeName,
                            arguments: AddDSaleBillProductListScreenArgument(
                                "",
                                _offlineLoggedInData.details[0].stateCode
                                    .toString(),
                                "0.00"));
                        /* if (edt_Dealer_Name.text == "") {
                          // print("INWWWE" + InquiryNo.toString());
                          navigateTo(
                              context, DSaleBillProductListScreen.routeName,
                              arguments: AddDSaleBillProductListScreenArgument(
                                  "",
                                  _offlineLoggedInData.details[0].stateCode
                                      .toString(),
                                  "0.00"));
                        } else {
                          showCommonDialogWithSingleOption(context,
                              "Customer name is required To view Product !",
                              positiveButtonTitle: "OK");
                        }*/
                      }, "Add Product + ",
                          width: 600,
                          backGroundColor: Color(0xff4d62dc),
                          radius: 15),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        // getContactarray();
                        // _onTapOfSaveCustomerAPICall();
                        // navigateTo(context, ContactsListScreen.routeName);
                        navigateTo(
                                context, DSaleBillOtherChargeScreen.routeName,
                                arguments: DSaleBillOtherChargeScreenArguments(
                                    int.parse(edt_StateCode.text == null
                                        ? 0
                                        : edt_StateCode.text),
                                    _editModel,
                                    edt_HeaderDisc.text))
                            .then((value) {
                          if (value == null) {
                            print("HeaderDiscount From QTOtherCharges 0.00");
                          } else {
                            print("HeaderDiscount From QTOtherCharges $value");
                            edt_HeaderDisc.text = value;
                          }
                        });
                        //DPurchaseOtherCharge_screen
                      }, "Other Charges",
                          backGroundColor: Color(0xff4d62dc),
                          width: 600,
                          radius: 15),
                    ),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    Attachments(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        // getContactarray();
                        // _onTapOfSaveCustomerAPICall();
                        // navigateTo(context, ContactsListScreen.routeName);
                      }, "Save", width: 600, radius: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _selectDate(context, edt_ComplanitDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Voucher Date *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
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
              height: CardViewHieght,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_ComplanitDate.text == null ||
                              edt_ComplanitDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_ComplanitDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_ComplanitDate.text == null ||
                                  edt_ComplanitDate.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Customer_Name() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Customer Name *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
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
              height: CardViewHieght,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        controller: edt_CustomerName,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.all(10),
                          hintText: "Tap to enter Name",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

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
      ),
    );
  }

  Widget DelaerName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Dealer Name *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
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
            height: CardViewHieght,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: false,
                      controller: edt_Dealer_Name,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.all(10),
                        hintText: "Tap to enter Name",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                Icon(
                  Icons.person,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget PreviousBalance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Previous Balance",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
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
            height: CardViewHieght,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: edt_PrviousBalance,
                      onTap: () => {
                            edt_PrviousBalance.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: edt_PrviousBalance.text.length,
                            )
                          },
                      decoration: InputDecoration(
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                /* Icon(
                  Icons.style,
                  color: colorGrayDark,
                )*/
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onTapOfSearchView() async {
    if (_isForUpdate == false) {
      //await _onTapOfDeleteALLProduct();

      navigateTo(context, SearchQuotationCustomerScreen.routeName)
          .then((value) {
        if (value != null) {
          _searchInquiryListResponse = value;
          edt_CustomerName.text = _searchInquiryListResponse.label;
          edt_CustomerpkID.text = _searchInquiryListResponse.value.toString();

          if (_searchInquiryListResponse.stateCode != 0) {
            edt_StateCode.text =
                _searchInquiryListResponse.stateCode.toString();
          } else {
            showCommonDialogWithSingleOption(context,
                "Customer State is Required !\nUpdate State From Customer Module",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              edt_CustomerName.text = "";
              Navigator.pop(context);
            });
          }
          //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));
        }
      });
    }
  }

  //edt_Customer_Name

  Widget TermsConditionList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap:
                () => /*showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerpkID,
                lable: "Select $Category")*/

                    _dealerBloc.add(QuotationTermsConditionCallEvent(
                        QuotationTermsConditionRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: colorPrimary,
                          fontWeight: FontWeight
                              .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHieght,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_ComplanitDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseComplanitDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  void _OnTermConditionListResponse(QuotationTermsCondtionResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_TermConditionList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].tNCHeader);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].tNCHeader;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].tNCContent;

        arr_ALL_Name_ID_For_TermConditionList.add(all_name_id);
      }
      showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_TermConditionList,
          context1: context,
          controller: edt_TermConditionHeader,
          controllerID: edt_TermConditionHeaderID,
          controller2: edt_TermConditionFooter,
          lable: "Select Term & Condition ");
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, DSaleBillListScreen.routeName, clearAllStack: true);
  }

  Attachments() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff4d62dc), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Attachment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: Container(child: Icon(Icons.attachment)),
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        AttachedFileList(),
                        SizedBox(
                          height: 5,
                        ),
                        getCommonButton(baseTheme, () async {
                          if (await Permission.storage.isDenied) {
                            //await Permission.storage.request();

                            checkPhotoPermissionStatus();
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SafeArea(
                                    child: Container(
                                      child: new Wrap(
                                        children: <Widget>[
                                          new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_library),
                                              title: new Text('Choose Files'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                FilePickerResult result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                    'jpg',
                                                    'pdf',
                                                    'doc',
                                                    'png'
                                                  ],
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  List<File> files = result
                                                      .paths
                                                      .map((path) => File(path))
                                                      .toList();
                                                  setState(() {
                                                    MultipleVideoList.addAll(
                                                        files);
                                                  });
                                                } else {
                                                  // User canceled the picker
                                                }
                                              }),
                                          new ListTile(
                                            leading:
                                                new Icon(Icons.photo_camera),
                                            title: new Text('Choose Image'),
                                            onTap: () async {
                                              Navigator.of(context).pop();

                                              XFile file =
                                                  await imagepicker.pickImage(
                                                source: ImageSource.camera,
                                              );
                                              setState(() {
                                                MultipleVideoList.add(
                                                    File(file.path));
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }, "Choose File",
                            radius: 20,
                            backGroundColor: Color(0xff02b1fc),
                            textColor: colorWhite)
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  AttachedFileList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this File ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();

                          // print("sdjdsfj" + MultipleVideoList[index].path);
                          // OpenFile.open(MultipleVideoList[index].path);
                          MultipleVideoList.removeAt(index);
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.delete_forever,
                        size: 32,
                        color: colorPrimary,
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: colorLightGray,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: 300,
                        /* decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: colorLightGray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),*/
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                OpenFile.open(MultipleVideoList[index].path);
                              },
                              child: Text(
                                MultipleVideoList[index].path.split('/').last,
                                softWrap: true,

                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10, color: colorPrimary),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              );

              // }
            },
            shrinkWrap: true,
            itemCount: MultipleVideoList.length,
          ),
        ],
      ),
    );
  }

  void checkPhotoPermissionStatus() async {
    bool granted = await Permission.storage.isGranted;
    bool Denied = await Permission.storage.isDenied;
    bool PermanentlyDenied = await Permission.storage.isPermanentlyDenied;
    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());
    if (Denied == true) {
      await Permission.storage.request();
    }
    if (await Permission.location.isRestricted) {
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      openAppSettings();
    }
    if (granted == true) {}
  }
}
