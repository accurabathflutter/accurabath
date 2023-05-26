import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/Clients/BlueTone/Inquiry/Product/bluetone_inquiry_product_list.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/bluetone_inquiry_product.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inqiory_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_to_delete_product.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/closer_reason_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_list_reponse.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/models/common/inquiry_product_model.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_request.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/customer_search/customer_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class AddUpdateBlueToneInquiryScreenArguments {
  InquiryDetails editModel;

  AddUpdateBlueToneInquiryScreenArguments(this.editModel);
}

class BlueToneInquiryAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/BlueToneInquiryAddEditScreen';
  final AddUpdateBlueToneInquiryScreenArguments arguments;

  BlueToneInquiryAddEditScreen(this.arguments);

  @override
  _BlueToneInquiryAddEditScreenState createState() =>
      _BlueToneInquiryAddEditScreenState();
}

class _BlueToneInquiryAddEditScreenState
    extends BaseState<BlueToneInquiryAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  int _pageNo = 0;
  bool expanded = true;
  double sizeboxsize = 12;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  //CustomerSourceResponse _offlineCustomerSource;
  //InquiryStatusListResponse _offlineInquiryLeadStatusData;

  int CompanyID = 0;
  String LoginUserID = "";
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController edt_InquiryDate = TextEditingController();
  final TextEditingController edt_ReverseInquiryDate = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();
  final TextEditingController edt_LeadStatusID = TextEditingController();
  final TextEditingController edt_LeadSource = TextEditingController();
  final TextEditingController edt_LeadSourceID = TextEditingController();
  final TextEditingController edt_Reference_Name = TextEditingController();
  final TextEditingController edt_Reference_No = TextEditingController();
  final TextEditingController edt_Description = TextEditingController();
  final TextEditingController edt_FollowupNotes = TextEditingController();

  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_ReverseNextFollowupDate =
      TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadSource = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_CloserReasonStatusType = [];

  InquiryDetails _editModel;
  bool _isForUpdate;
  String InquiryNo = "";
  int pkID = 0;
  List<InquiryProductModel> _inquiryProductList = [];
  FocusNode ReferenceFocusNode;

  // SearchInquiryListResponse _searchInquiryListResponse;
  // SearchInquiryCustomer _searchInquiryListResponse;
  SearchDetails _searchInquiryListResponse;

  final TextEditingController edt_CloserReasonStatusType =
      TextEditingController();
  final TextEditingController edt_CloserReasonStatusTypepkID =
      TextEditingController();
  bool ISDisQualified = false;
  bool ISDisQualifiedEmpty = false;
  FCMNotificationRequest fcmNotificationRequest;

  String ReportToToken = "";

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    // _offlineCustomerSource = SharedPrefHelper.instance.getCustomerSourceData();
    //  _offlineInquiryLeadStatusData = SharedPrefHelper.instance.getInquiryLeadStatus();
    // _onLeadSourceListTypeCallSuccess(_offlineCustomerSource);
    //_onLeadStatusListTypeCallSuccess(_offlineInquiryLeadStatusData);
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _inquiryBloc = InquiryBloc(baseBloc);
    ReferenceFocusNode = FocusNode();
    FetchInquiryPriorityDetails();
    edt_LeadSource.addListener(() {
      ReferenceFocusNode.requestFocus();
    });
    edt_LeadStatus.addListener(() {
      setState(() {
        if (edt_LeadStatus.text == "Close - Lost") {
          ISDisQualified = true;
        } else {
          ISDisQualified = false;
        }
      });
    });

    fcmNotificationRequest = new FCMNotificationRequest();

    // FCMNotificationRequest().notification.body = Notification;
    /* fcmNotificationRequest.notification.title = "Inquiry Save Success";
    fcmNotificationRequest.data.body = "NOV03-2022";
    fcmNotificationRequest.data.title = "Inquiry Save Success";
    fcmNotificationRequest.data.clickAction = "FLUTTER_NOTIFICATION_CLICK";
*/

    _inquiryBloc.add(GetReportToTokenRequestEvent(GetReportToTokenRequest(
        CompanyId: CompanyID.toString(),
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString())));

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_InquiryDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseInquiryDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_NextFollowupDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();

      edt_ReverseNextFollowupDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_PreferedTime.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          if (state is GetReportToTokenResponseState) {
            _onGetTokenfromReportopersonResult(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetReportToTokenResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {
          if (state is InquiryHeaderSaveResponseState) {
            _OnHeaderSuccessResponse(state);
          }
          if (state is BluetoneInquiryProductSaveResponseState) {
            _OnInquiryProductSaveResponse(state);
          }
          if (state is BluetoneInquiryNotoProductResponseState) {
            _OnInquiryNoToProductListResponse(state);
          }
          if (state is InquiryNotoDeleteProductResponseState) {
            _OnInquiryNoTodeleteAllProduct(state);
          }
          if (state is InquiryLeadStatusListCallResponseState) {
            _onLeadStatusListTypeCallSuccess(state);
          }
          if (state is CustomerSourceCallEventResponseState) {
            _onLeadSourceListTypeCallSuccess(state);
          }
          if (state is CloserReasonListCallResponseState) {
            _onCloserReasonStatusListTypeCallSuccess(state);
          }

          if (state is FCMNotificationResponseState) {
            _onRecevedNotification(state);
          }

          /* if (state is SearchInquiryListByNameCallResponseState) {
            _onSearchInquiryListCallSuccess(state);
          }*/
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is InquiryHeaderSaveResponseState ||
              currentState is BluetoneInquiryProductSaveResponseState ||
              currentState is BluetoneInquiryNotoProductResponseState ||
              currentState is InquiryLeadStatusListCallResponseState ||
              currentState is CustomerSourceCallEventResponseState ||
              currentState is CloserReasonListCallResponseState ||
              currentState is FCMNotificationResponseState) {
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
          title: Text('BlueTone Inquiry Details'),
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
                onPressed: () async {
                  //_onTapOfLogOut();
                  await _onTapOfDeleteALLProduct();
                  await _onTapOfDeleteALLPrice();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(Constant.CONTAINERMARGIN),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFollowupDate(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        _buildSearchView(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        CustomDropDown1("Priority",
                            enable1: false,
                            title: "Lead Priority ",
                            hintTextvalue: "Tap to Select Lead Priority",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Priority,
                            Custom_values1:
                                arr_ALL_Name_ID_For_Folowup_Priority),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        showcustomdialogWithID1("Lead Status",
                            enable1: false,
                            title: "Lead Status",
                            hintTextvalue: "Tap to Select Lead Status",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_LeadStatus,
                            controllerpkID: edt_LeadStatusID,
                            Custom_values1: arr_ALL_Name_ID_For_LeadStatus),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        showcustomdialogWithID1("Lead Source",
                            enable1: false,
                            title: "Lead Source *",
                            hintTextvalue: "Tap to Select Lead Source",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_LeadSource,
                            controllerpkID: edt_LeadSourceID,
                            Custom_values1: arr_ALL_Name_ID_For_LeadSource),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        RefernceName(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        /* Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Description * ",
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
                            controller: edt_Description,
                            minLines: 2,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Tap to Enter Description',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),*/
                        _isForUpdate == false ? FollowupFields() : Container(),
                        ISDisQualified == true
                            ? Column(
                                children: [
                                  //edt_LeadStatus
                                  showcustomdialogWithID1("Closure Reason",
                                      enable1: false,
                                      title: "Closure Reason *",
                                      hintTextvalue:
                                          "Tap to Select Closer Reason",
                                      icon: Icon(Icons.arrow_drop_down),
                                      controllerForLeft:
                                          edt_CloserReasonStatusType,
                                      controllerpkID:
                                          edt_CloserReasonStatusTypepkID,
                                      Custom_values1:
                                          arr_ALL_Name_ID_For_CloserReasonStatusType),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.bottomCenter,
                          child: getCommonButton(baseTheme, () {
                            //  _onTapOfDeleteALLContact();
                            //  navigateTo(context, InquiryProductListScreen.routeName);
                            print("INWWWE" + InquiryNo.toString());
                            navigateTo(context,
                                BlueToneInquiryProductListScreen.routeName,
                                arguments:
                                    AddBluetoneProductListArgument("", ""));
                          }, "Add Product + ",
                              width: 600, backGroundColor: Color(0xff4d62dc)),
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.bottomCenter,
                          child: getCommonButton(baseTheme, () {
                            if (ISDisQualified == true) {
                              if (edt_CloserReasonStatusType.text != "") {
                                ISDisQualifiedEmpty = true;
                              } else {
                                ISDisQualifiedEmpty = false;
                              }
                            } else {
                              ISDisQualifiedEmpty = true;
                            }

                            _onTapToSaveHeaderDetails();
                          }, "Save", width: 600),
                        ),
                        /* Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.bottomCenter,
                          child: getCommonButton(baseTheme, () {


                          }, "Save & Send Email", width: 600),
                        ),*/
                      ]))),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _isForUpdate == false
            ? _selectDate(context, edt_InquiryDate)
            : Container();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Inquiry Date *",
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
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_InquiryDate.text == null || edt_InquiryDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_InquiryDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_InquiryDate.text == null ||
                                  edt_InquiryDate.text == ""
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_InquiryDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseInquiryDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Search Customer *",
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
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_CustomerName,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search customer",
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

  Future<void> _onTapOfSearchView() async {
    if (_isForUpdate == false) {
      navigateTo(context, SearchInquiryCustomerScreen.routeName).then((value) {
        if (value != null) {
          _searchInquiryListResponse = value;
          edt_CustomerName.text = _searchInquiryListResponse.label;
          edt_CustomerpkID.text = _searchInquiryListResponse.value.toString();
          /* _inquiryBloc.add(SearchInquiryListByNameCallEvent(
              SearchInquiryListByNameRequest(word:  edt_CustomerName.text,CompanyId:CompanyID.toString(),LoginUserID: LoginUserID,needALL: "1")));
*/
          //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));
        }
      });
    }
  }

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    await _onTapOfDeleteALLPrice();

    navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
  }

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
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
                    height: 60,
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

  FetchInquiryPriorityDetails() {
    if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
        "dol2-6uh7-ph03-in5h") {
      arr_ALL_Name_ID_For_Folowup_Priority.clear();
      for (var i = 0; i < 3; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        if (i == 0) {
          all_name_id.Name = "Hot";
        } else if (i == 1) {
          all_name_id.Name = "Cold";
        } else if (i == 2) {
          all_name_id.Name = "Warm";
        }
        arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
      }
    } else {
      arr_ALL_Name_ID_For_Folowup_Priority.clear();
      for (var i = 0; i < 3; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        if (i == 0) {
          all_name_id.Name = "High";
        } else if (i == 1) {
          all_name_id.Name = "Medium";
        } else if (i == 2) {
          all_name_id.Name = "Low";
        }
        arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
      }
    }
  }

  Widget showcustomdialogWithID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
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
                    CreateDialogDropdown(Category),
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
                    height: 60,
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

  void _onLeadStatusListTypeCallSuccess(
      InquiryLeadStatusListCallResponseState state) {
    if (state.inquiryStatusListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_LeadStatus.clear();
      for (var i = 0; i < state.inquiryStatusListResponse.details.length; i++) {
        print("InquiryStatus : " +
            state.inquiryStatusListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.inquiryStatusListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.inquiryStatusListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_LeadStatus,
          context1: context,
          controller: edt_LeadStatus,
          controllerID: edt_LeadStatusID,
          lable: "Select Status");
    }
  }

  void _onLeadSourceListTypeCallSuccess(
      CustomerSourceCallEventResponseState state) {
    if (state.sourceResponse.details.length != 0) {
      arr_ALL_Name_ID_For_LeadSource.clear();
      for (var i = 0; i < state.sourceResponse.details.length; i++) {
        print(
            "InquiryStatus : " + state.sourceResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.sourceResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.sourceResponse.details[i].pkID;
        arr_ALL_Name_ID_For_LeadSource.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_LeadSource,
          context1: context,
          controller: edt_LeadSource,
          controllerID: edt_LeadSourceID,
          lable: "Select Source");
    }
  }

  Widget RefernceName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Reference Name",
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
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      textInputAction: TextInputAction.next,
                      focusNode: ReferenceFocusNode,
                      controller: edt_Reference_Name,
                      decoration: InputDecoration(
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

  Widget RefernceNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Reference No",
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
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_Reference_No,
                      decoration: InputDecoration(
                        hintText: "Tap to enter Ref.No",
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

  void fillData() async {
    pkID = _editModel.pkID;
    edt_InquiryDate.text = _editModel.inquiryDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseInquiryDate.text = _editModel.inquiryDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_CustomerName.text = _editModel.customerName.toString();
    edt_CustomerpkID.text = _editModel.customerID.toString();
    edt_Priority.text = _editModel.priority;
    edt_LeadStatus.text = _editModel.inquiryStatus.toString();
    edt_LeadStatusID.text = _editModel.inquiryStatusID.toString();
    edt_LeadSourceID.text = _editModel.inquirySource.toString();
    edt_LeadSource.text = _editModel.InquirySourceName.toString();
    edt_Reference_Name.text = _editModel.referenceName.toString();
    edt_Description.text = _editModel.meetingNotes.toString();
    edt_ReverseNextFollowupDate.text = "";
    edt_PreferedTime.text = "";
    edt_FollowupNotes.text = "";
    InquiryNo = _editModel.inquiryNo;
    edt_CloserReasonStatusType.text = _editModel.closureReason;
    edt_CloserReasonStatusTypepkID.text = _editModel.closureReasonID.toString();

    if (InquiryNo != '') {
      await _onTapOfDeleteALLProduct();

      await _onTapOfDeleteALLPrice();

      _inquiryBloc.add(BluetoneInquiryNotoProductCallEvent(
          InquiryNoToProductListRequest(
              InquiryNo: InquiryNo,
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID)));

      /*_inquiryBloc.add(InquiryNoToFetchProductSizedListRequestEvent(InquiryNoToFetchProductSizedListRequest(
         InquiryNo : InquiryNo,
         ProductID :"0",
         LoginUserID :LoginUserID,
         CompanyId:CompanyID.toString()
      )));*/
    }
  }

  _onTapToSaveHeaderDetails() async {
    await getInquiryProductDetails();

    if (edt_InquiryDate.text.toString().trim() != '') {
      if (edt_CustomerName.text.toString().trim() != '') {
        if (edt_LeadSource.text.toString().trim() != '') {
          if (ISDisQualifiedEmpty == true) {
            if (_inquiryProductList.length != 0) {
              print("HeaderDetailsRequestParam" +
                  "InquiryDate" +
                  edt_InquiryDate.text +
                  "ReverseInquiryDate" +
                  edt_ReverseInquiryDate.text +
                  "CustomerID" +
                  edt_CustomerpkID.text +
                  " CustomerName" +
                  edt_CustomerName.text +
                  "InquiryNo " +
                  InquiryNo +
                  "MeetingNotes" +
                  edt_Description.text +
                  "InquirySourceID" +
                  edt_LeadSourceID.text +
                  "InquirySource" +
                  edt_LeadSource.text +
                  "ReferenceName" +
                  edt_Reference_Name.text +
                  "InquiryStatusID" +
                  edt_LeadStatusID.text +
                  "LoginUserID" +
                  LoginUserID +
                  "Priority" +
                  edt_Priority.text +
                  "CompanyId" +
                  CompanyID.toString());

              showCommonDialogWithTwoOptions(
                  context, "Are you sure you want to Save this Inquiry?",
                  negativeButtonTitle: "No",
                  positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
                if (InquiryNo != '') {
                  _inquiryBloc.add(InquiryNotoDeleteProductCallEvent(
                      InquiryNo,
                      InquiryNoToDeleteProductRequest(
                          InquiryNo: InquiryNo,
                          CompanyId: CompanyID.toString())));
                }
                _inquiryBloc.add(InquiryHeaderSaveNameCallEvent(
                    pkID,
                    InquiryHeaderSaveRequest(
                        pkID: pkID.toString(),
                        FollowupDate:
                            edt_ReverseNextFollowupDate.text.toString(),
                        CustomerID: edt_CustomerpkID.text.toString(),
                        InquiryNo: InquiryNo,
                        InquiryDate: edt_ReverseInquiryDate.text.toString(),
                        MeetingNotes: "",
                        InquirySource: edt_LeadSource.text.toString(),
                        //edt_LeadSourceID.text.toString(),
                        ReferenceName: edt_Reference_Name.text.toString(),
                        FollowupNotes: edt_FollowupNotes.text.toString(),
                        InquiryStatusID: edt_LeadStatusID.text.toString(),
                        LoginUserID: LoginUserID,
                        Latitude: SharedPrefHelper.instance.getLatitude(),
                        Longitude: SharedPrefHelper.instance.getLongitude(),
                        FollowupTypeID: "5",
                        PreferredTime: edt_PreferedTime.text.toString(),
                        Priority: edt_Priority.text.toString(),
                        CompanyId: CompanyID.toString(),
                        ClosureReason: edt_CloserReasonStatusTypepkID.text
                                    .toString() ==
                                null
                            ? 0
                            : edt_CloserReasonStatusTypepkID.text.toString())));
              });
            } else {
              showCommonDialogWithSingleOption(
                  context, "Product Details are required!",
                  positiveButtonTitle: "OK");
            }
          } else {
            showCommonDialogWithSingleOption(
                context, "Closer Reason is required!",
                positiveButtonTitle: "OK");
          }
        } else {
          showCommonDialogWithSingleOption(context, "Lead Source is required!",
              positiveButtonTitle: "OK");
        }
      } else {
        showCommonDialogWithSingleOption(context, "Customer Name is required!",
            positiveButtonTitle: "OK");
      }
    } else {
      showCommonDialogWithSingleOption(context, "LeadDate is required!",
          positiveButtonTitle: "OK");
    }
  }

  void _OnHeaderSuccessResponse(InquiryHeaderSaveResponseState state) async {
    print("InquiryHeaderResponse" +
        state.inquiryHeaderSaveResponse.details[0].column2 +
        "\n" +
        state.inquiryHeaderSaveResponse.details[0].column3);
    String updatemsg = _isForUpdate == true ? " Updated " : " Created ";

    updateRetrunInquiryNoToDB(
        state.inquiryHeaderSaveResponse.details[0].column3);

    String notiTitle = "Inquiry";

    ///state.inquiryHeaderSaveResponse.details[0].column3;
    String notibody = "Inquiry " +
        state.inquiryHeaderSaveResponse.details[0].column3 +
        updatemsg +
        " For " +
        edt_CustomerName.text +
        " By " +
        _offlineLoggedInData.details[0].employeeName;

    var request123 = {
      "to": ReportToToken,
      "notification": {"body": notibody, "title": notiTitle},
      "data": {
        "body": notibody,
        "title": notiTitle,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    print("Notificationdf" + request123.toString());
    _inquiryBloc.add(FCMNotificationRequestEvent(request123));

    List<PriceModel> dbarraysizedlist =
        await OfflineDbHelper.getInstance().getAllProductPriceList();

    List<PriceModel> tempwithtruesizedlist = [];

    for (int y = 0; y < dbarraysizedlist.length; y++) {
      if (dbarraysizedlist[y].isChecked == "true") {
        tempwithtruesizedlist.add(dbarraysizedlist[y]);
      }
    }

    _inquiryBloc.add(BluetoneInquiryProductSaveCallEvent(
        _inquiryProductList, tempwithtruesizedlist));
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<BlueToneProductModel> temp =
        await OfflineDbHelper.getInstance().getBlueTonProductList();

    for (int i = 0; i < temp.length; i++) {
      _inquiryProductList.add(InquiryProductModel(
          LoginUserID,
          CompanyID.toString(),
          "",
          temp[i].ProductName,
          temp[i].ProductID,
          "1",
          temp[i].UnitPrice,
          temp[i].UnitPrice));
    }
    //_inquiryProductList.addAll(temp);
    setState(() {});
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteAllBlueToneProductItems();
  }

  Future<void> _onTapOfDeleteALLPrice() async {
    await OfflineDbHelper.getInstance().deleteAllProductPriceList();
  }

  //deleteAllBlueToneProductItems

  void updateRetrunInquiryNoToDB(String ReturnInquiryNo) {
    _inquiryProductList.forEach((element) {
      element.InquiryNo = ReturnInquiryNo;
      element.LoginUserID = LoginUserID;
      element.CompanyId = CompanyID.toString();
    });
  }

  _OnInquiryProductSaveResponse(
      BluetoneInquiryProductSaveResponseState state) async {
    print("InquiryHeaderResponse " +
        state.inquiryProductSaveResponse.details[0].column2);
    String Msg = _isForUpdate == true
        ? "Inquiry Updated Successfully"
        : "Inquiry Added Successfully";

    await OfflineDbHelper.getInstance().deleteAllProductPriceList();

    /* showCommonDialogWithSingleOption(context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
        });*/

    await showCommonDialogWithSingleOption(
        Globals.context, Msg + "\n" + state.sizedListInsUpdateApiResponse,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
    });
  }

  _OnInquiryNoToProductListResponse(
      BluetoneInquiryNotoProductResponseState state) async {
    await OfflineDbHelper.getInstance().deleteAllProductPriceList();

    for (var i = 0; i < state.inquiryNoToProductResponse.details.length; i++) {
      String ProductName =
          state.inquiryNoToProductResponse.details[i].productName;
      String ProductID =
          state.inquiryNoToProductResponse.details[i].productID.toString();
      String Quantity =
          state.inquiryNoToProductResponse.details[i].quantity.toString();
      String UnitPrice =
          state.inquiryNoToProductResponse.details[i].unitPrice.toString();
      double totamnt = double.parse(Quantity) * double.parse(UnitPrice);
      String TotalAmount = totamnt.toString();
      _onTapOfAdd(ProductName, ProductID, Quantity, UnitPrice, TotalAmount);

      /// ongetProductPrice(ProductID);
    }

    for (int i = 0;
        i < state.inquiryProductWithTwoSizedListDetails.length;
        i++) {
      for (int j = 0;
          j <
              state.inquiryProductWithTwoSizedListDetails[i]
                  .all_sized_with_productID.length;
          j++) {
        print("AllSizedwithProduct" +
            state.inquiryProductWithTwoSizedListDetails[i]
                .all_sized_with_productID[j].sizeName);

        await OfflineDbHelper.getInstance().insertProductPriceList(PriceModel(
            state.inquiryProductWithTwoSizedListDetails[i]
                .all_sized_with_productID[j].productID
                .toString(),
            state.inquiryProductWithTwoSizedListDetails[i]
                .all_sized_with_productID[j].productName
                .toString(),
            state.inquiryProductWithTwoSizedListDetails[i]
                .all_sized_with_productID[j].sizeID
                .toString(),
            state.inquiryProductWithTwoSizedListDetails[i]
                .all_sized_with_productID[j].sizeName
                .toString(),
            "false"));
      }

      List<PriceModel> sizedListArray = await OfflineDbHelper.getInstance()
          .getProductPriceList(state
              .inquiryProductWithTwoSizedListDetails[i].productID
              .toString());
      //

      for (int l = 0; l < sizedListArray.length; l++) {
        print("arrayfromdb" + sizedListArray[l].SizeName);

        for (int k = 0;
            k <
                state.inquiryProductWithTwoSizedListDetails[i]
                    .custom_sized_with_InquiryNo.length;
            k++) {
          if (sizedListArray[l].SizeID.toString() ==
              state.inquiryProductWithTwoSizedListDetails[i]
                  .custom_sized_with_InquiryNo[k].sizeID
                  .toString()) {
            await OfflineDbHelper.getInstance().updateProductPriceItem(
                PriceModel(
                    sizedListArray[l].ProductID.toString(),
                    sizedListArray[l].ProductName.toString(),
                    sizedListArray[l].SizeID.toString(),
                    sizedListArray[l].SizeName.toString(),
                    "true",
                    id: sizedListArray[l].id));
          }
        }
      }
    }
  }

  _onTapOfAdd(String productName, String ProductID, String Quantity,
      String UnitPrice, String TotalAmount) async {
    /*await OfflineDbHelper.getInstance()
        .insertInquiryProduct(InquiryProductModel(
      "test",
      "0",
      "abc",
      productName,
      ProductID,
      Quantity,
      UnitPrice,
      TotalAmount,
    ));*/

    _inquiryBloc.add(BlueToneProductModelInsertEvent(
        context,
        BlueToneProductModel(
          "",
          LoginUserID,
          CompanyID.toString(),
          productName,
          ProductID,
          UnitPrice,
        )));
  }

  _OnInquiryNoTodeleteAllProduct(InquiryNotoDeleteProductResponseState state) {
    print("InquiryHeaderResponse " +
        state.inquiryNoToDeleteProductResponse.details[0].column2);
  }

  Widget FollowupFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Followup Notes",
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
            controller: edt_FollowupNotes,
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter Notes',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
          ),
        ),
        SizedBox(
          width: 20,
          height: 15,
        ),
        InkWell(
          onTap: () {
            _selectNextFollowupDate(context, edt_NextFollowupDate);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("Next FollowUp Date *",
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
                  height: 60,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          edt_NextFollowupDate.text == null ||
                                  edt_NextFollowupDate.text == ""
                              ? "DD-MM-YYYY"
                              : edt_NextFollowupDate.text,
                          style: baseTheme.textTheme.headline3.copyWith(
                              color: edt_NextFollowupDate.text == null ||
                                      edt_NextFollowupDate.text == ""
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
        ),
        SizedBox(
          width: 20,
          height: 15,
        ),
        InkWell(
          onTap: () {
            _selectTime(context, edt_PreferedTime);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("Preferred Time",
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
                  height: 60,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          edt_PreferedTime.text == null ||
                                  edt_PreferedTime.text == ""
                              ? "HH:MM:SS"
                              : edt_PreferedTime.text,
                          style: baseTheme.textTheme.headline3.copyWith(
                              color: edt_PreferedTime.text == null ||
                                      edt_PreferedTime.text == ""
                                  ? colorGrayDark
                                  : colorBlack),
                        ),
                      ),
                      Icon(
                        Icons.watch_later_outlined,
                        color: colorGrayDark,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 20,
          height: 15,
        ),
      ],
    );
  }

  Future<void> _selectNextFollowupDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_NextFollowupDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseNextFollowupDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController F_datecontroller) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;

        String AM_PM =
            selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
        String beforZeroHour = selectedTime.hourOfPeriod <= 9
            ? "0" + selectedTime.hourOfPeriod.toString()
            : selectedTime.hourOfPeriod.toString();
        String beforZerominute = selectedTime.minute <= 9
            ? "0" + selectedTime.minute.toString()
            : selectedTime.minute.toString();

        edt_PreferedTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }

  CreateDialogDropdown(String category) {
    if (category == "Lead Status") {
      _inquiryBloc.add(InquiryLeadStatusTypeListByNameCallEvent(
          FollowupInquiryStatusTypeListRequest(
              CompanyId: CompanyID.toString(),
              pkID: "",
              StatusCategory: "Inquiry",
              LoginUserID: LoginUserID,
              SearchKey: "")));
    } else if (category == "Closure Reason") {
      _inquiryBloc
        ..add(CloserReasonTypeListByNameCallEvent(CloserReasonTypeListRequest(
            CompanyId: CompanyID.toString(),
            pkID: "",
            StatusCategory: "DisQualifiedReason",
            LoginUserID: LoginUserID,
            SearchKey: "")));
    } else {
      _inquiryBloc.add(CustomerSourceCallEvent(CustomerSourceRequest(
          pkID: "0",
          StatusCategory: "InquirySource",
          companyId: CompanyID,
          LoginUserID: LoginUserID,
          SearchKey: "")));
    }
  }

  void _onSearchInquiryListCallSuccess(
      SearchInquiryListByNameCallResponseState state) {
    if (state.response.details.isNotEmpty) {
      for (int i = 0; i < state.response.details.length; i++) {
        int empID = state.response.details[i].createdEmployeeID;
        if (_offlineLoggedInData.details[0].employeeID == empID) {
          showCommonDialogWithSingleOption(
              context, "Customer is Already Created by ",
              positiveButtonTitle: "OK");
        }
      }
    }
  }

  void _onCloserReasonStatusListTypeCallSuccess(
      CloserReasonListCallResponseState state) {
    if (state.closerReasonListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_CloserReasonStatusType.clear();
      for (var i = 0; i < state.closerReasonListResponse.details.length; i++) {
        print("CloserReasonStatus : " +
            state.closerReasonListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.closerReasonListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.closerReasonListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_CloserReasonStatusType.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_CloserReasonStatusType,
          context1: context,
          controller: edt_CloserReasonStatusType,
          controllerID: edt_CloserReasonStatusTypepkID,
          lable: "Select DisQualified Reason");
    }
  }

  void _onRecevedNotification(FCMNotificationResponseState state) {
    print("fcm_notification" +
        state.response.canonicalIds.toString() +
        state.response.failure.toString() +
        state.response.multicastId.toString() +
        state.response.success.toString() +
        state.response.results[0].messageId);
    String Msg = _isForUpdate == true
        ? "Inquiry Updated Successfully"
        : "Inquiry Added Successfully";

    showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
    });
  }

  void _onGetTokenfromReportopersonResult(GetReportToTokenResponseState state) {
    ReportToToken = state.response.details[0].reportPersonTokenNo;
  }

  void ongetProductPrice(String productID) async {}
}
