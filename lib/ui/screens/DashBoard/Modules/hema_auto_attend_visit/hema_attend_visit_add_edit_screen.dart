import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/attend_visit/attend_visit_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_no_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/models/hema_automation/api_request/quick_complaint/quick_complaint_save_request.dart';
import 'package:for_practice_the_app/models/hema_automation/api_response/quick_complaint/quick_complaint_list_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Complaint/search_customer_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/hema_auto_attend_visit/hema_attend_visit_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class QuickAddUpdateComplaintScreenArguments {
  QucikComplaintListResponseDetails editModel;
  bool futureflag;
  String PunchStatus;

  QuickAddUpdateComplaintScreenArguments(
      this.editModel, this.futureflag, this.PunchStatus);
}

class HemaAttendVisitAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/HemaAttendVisitAddEditScreen';
  final QuickAddUpdateComplaintScreenArguments arguments;

  HemaAttendVisitAddEditScreen(this.arguments);

  @override
  BaseState<HemaAttendVisitAddEditScreen> createState() =>
      _HemaAttendVisitAddEditScreenState();
}

class _HemaAttendVisitAddEditScreenState
    extends BaseState<HemaAttendVisitAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  AttendVisitBloc _complaintScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController edt_FollowUpDate = TextEditingController();
  final TextEditingController edt_ReverseFollowUpDate = TextEditingController();
  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_ReverseNextFollowupDate =
      TextEditingController();
  final TextEditingController edt_ComplaintNo = TextEditingController();
  final TextEditingController edt_Complaint_NoID = TextEditingController();

  final TextEditingController edt_satus = TextEditingController();
  final TextEditingController edt_satusID = TextEditingController();
  final TextEditingController edt_Type = TextEditingController();
  final TextEditingController edt_ComplaintNotes = TextEditingController();
  final TextEditingController edt_VisitNotes = TextEditingController();

  final TextEditingController edt_TransectionName = TextEditingController();
  final TextEditingController edt_TransectionID = TextEditingController();
  final TextEditingController edt_Amount = TextEditingController();
  final TextEditingController edt_CustomerID = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();

  final TextEditingController edt_SrNo = TextEditingController();
  final TextEditingController edt_Product = TextEditingController();
  final TextEditingController edt_ProductID = TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();

  TextEditingController _eventControllerIn_Time = TextEditingController();
  TextEditingController _eventControllerOut_Time = TextEditingController();

//
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ComplaintNo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadSource = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Charge_Type = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TransectionMode = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ComplaintNoList = [];

  //
  bool IsCharged = false;
  bool _isForUpdate = false;
  bool isvisible_Out_time = false;
  String _PunchStatus;

  SearchDetails _searchDetails;
  Position _currentPosition;

  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;
  String MapAPIKey;
  String Latitude = "";
  String Longitude = "";
  String Address = "";
  String Address_IN = "";
  String Address_OUT = "";
  String editableLatitude = "";
  String editableLongitude = "";
  String editableAddress = "";
  QucikComplaintListResponseDetails _editModel;

  bool _futureflag;
  int savepkID = 0;

  bool is_LocationService_Permission;
  Location location = new Location();

  final TextEditingController edt_FromTime = TextEditingController();
  final TextEditingController edt_ToTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    fetchComplaintNodetails();
    FetchTypeDetails();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _complaintScreenBloc = AttendVisitBloc(baseBloc);

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      _futureflag = widget.arguments.futureflag;
      _PunchStatus = widget.arguments.PunchStatus;

      fillData();
    } else {
      _PunchStatus = "PunchIn";
      selectedDate = DateTime.now();
      edt_FollowUpDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
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

      _eventControllerIn_Time.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;

      isvisible_Out_time = false;
      setState(() {});
    }

    TimeOfDay selectedTime1234 = TimeOfDay.now();
    String AM_PM123 =
        selectedTime1234.periodOffset.toString() == "12" ? "PM" : "AM";
    String beforZeroHour123 = selectedTime1234.hourOfPeriod <= 9
        ? "0" + selectedTime1234.hourOfPeriod.toString()
        : selectedTime1234.hourOfPeriod.toString();
    String beforZerominute123 = selectedTime1234.minute <= 9
        ? "0" + selectedTime1234.minute.toString()
        : selectedTime1234.minute.toString();
    edt_FromTime.text = beforZeroHour123 +
        ":" +
        beforZerominute123 +
        " " +
        AM_PM123; //picked_s.periodOffset.toString();

    TimeOfDay selectedToTime =
        TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
    String AM_PMToTime =
        selectedToTime.periodOffset.toString() == "12" ? "PM" : "AM";
    String beforZeroHourToTime = selectedToTime.hourOfPeriod <= 9
        ? "0" + selectedToTime.hourOfPeriod.toString()
        : selectedToTime.hourOfPeriod.toString();
    String beforZerominuteToTime = selectedToTime.minute <= 9
        ? "0" + selectedToTime.minute.toString()
        : selectedToTime.minute.toString();
    edt_ToTime.text = beforZeroHourToTime +
        ":" +
        beforZerominuteToTime +
        " " +
        AM_PMToTime; //picked_s.periodOffset.toString();

    edt_Type.addListener(() {
      if (edt_Type.text == "Charged") {
        IsCharged = true;
      } else {
        IsCharged = false;
      }

      setState(() {});
    });
  }

  void fillData() {
    ///FollowupDate

    edt_FollowUpDate.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();
    edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    ///Next FollowupDate
    selectedDate = DateTime.now();
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

    ///CustomerName AND CustomerID
    edt_CustomerName.text = "Banseedhar Krushi Evam"; //_editModel.customerName;
    edt_CustomerID.text = "21027"; //_editModel.customerID.toString();

    edt_ComplaintNo.text = _editModel.complaintNo.toString();
    edt_satus.text = _editModel.complaintStatus;

    ///SavePKID
    savepkID = _editModel.pkID.toInt();

    ///FollowupNotes
    edt_VisitNotes.text = _editModel.visitNotes;

    ///Prefred Time
    String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
    String beforZeroHour = selectedTime.hourOfPeriod <= 9
        ? "0" + selectedTime.hourOfPeriod.toString()
        : selectedTime.hourOfPeriod.toString();
    String beforZerominute = selectedTime.minute <= 9
        ? "0" + selectedTime.minute.toString()
        : selectedTime.minute.toString();
    edt_PreferedTime.text = beforZeroHour + ":" + beforZerominute + " " + AM_PM;

    ///InTime
    if (_editModel.timeIn.toString() == "") {
      _eventControllerIn_Time.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      isvisible_Out_time = false;
    } else {
      _eventControllerIn_Time.text = getTime(_editModel.timeIn);
      isvisible_Out_time = true;
    }

    ///Out Time
    _eventControllerOut_Time.text =
        beforZeroHour + ":" + beforZerominute + " " + AM_PM;

    ///Latitude
    editableLatitude = _editModel.latitudeIN;
    editableLongitude = _editModel.longitudeIN;

    ///Address
    editableAddress = _editModel.locationAddressIN;

    if (_futureflag == true) {
      isvisible_Out_time = false;
      _eventControllerIn_Time.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
    }

    print("ddfdf566" + isvisible_Out_time.toString());
  }

  getTime(String time) {
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));

    String beforZeroHour = _startTime.hourOfPeriod <= 9
        ? "0" + _startTime.hourOfPeriod.toString()
        : _startTime.hourOfPeriod.toString();
    String beforZerominute = _startTime.minute <= 9
        ? "0" + _startTime.minute.toString()
        : _startTime.minute.toString();
    /*selectedTime.hourOfPeriod <= 9
        ? "0" + selectedTime.hourOfPeriod*/
    return "${beforZeroHour}:${beforZerominute} ${_startTime.period == DayPeriod.pm ? "PM" : "AM"}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _complaintScreenBloc,
      child: BlocConsumer<AttendVisitBloc, AttendVisitStates>(
        builder: (BuildContext context, AttendVisitStates state) {
          //handle states

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called

          return false;
        },
        listener: (BuildContext context, AttendVisitStates state) {
          if (state is CustomerSourceCallEventResponseState) {
            _onLeadSourceListTypeCallSuccess(state);
          }

          if (state is TransectionModeResponseState) {
            _OnTransectionModeSucess(state);
          }
          if (state is ComplaintNoListCallResponseState) {
            _OnComplaintNoListResponseSucess(state);
          }
          if (state is QuickComplaintSaveResponseState) {
            _OnVisitSaveSucess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is AttendVisitDeleteResponseState ||
              currentState is CustomerSourceCallEventResponseState ||
              currentState is TransectionModeResponseState ||
              currentState is ComplaintNoListCallResponseState ||
              currentState is QuickComplaintSaveResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    //throw UnimplementedError();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Attend Visit Details'),
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
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Visit Timing *",
                        style: TextStyle(
                            fontSize: 12,
                            color: colorPrimary,
                            fontWeight: FontWeight
                                .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                        ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: GestureDetector(
                                onTap: () {
                                  _selectFromTime(context, edt_FromTime);
                                },
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsets.only(left: 20, right: 10),
                                  alignment: Alignment.center,
                                  child: Row(children: [
                                    Expanded(
                                      child: TextField(
                                          enabled: false,
                                          controller: edt_FromTime,
                                          decoration: InputDecoration(
                                            hintText: "hh:mm",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15,
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
                                Icons.watch_later_outlined,
                                color: colorGrayDark,
                              )*/
                                  ]),
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: GestureDetector(
                                onTap: () {
                                  _selectToTime(context, edt_ToTime);
                                },
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsets.only(left: 20, right: 10),
                                  alignment: Alignment.center,
                                  child: Row(children: [
                                    Expanded(
                                      child: TextField(
                                          enabled: false,
                                          controller: edt_ToTime,
                                          decoration: InputDecoration(
                                            hintText: "hh:mm",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15,
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
                                Icons.watch_later_outlined,
                                color: colorGrayDark,
                              )*/
                                  ]),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                    height: 15,
                  ),
                  _buildBankACSearchView(),
                  SizedBox(
                    width: 20,
                    height: 15,
                  ),
                  ComplaintDropDown("Complaint # *",
                      enable1: false,
                      title: "Complaint # *",
                      hintTextvalue: "Tap to Select Complaint No.",
                      icon: Icon(Icons.arrow_drop_down),
                      controllerForLeft: edt_ComplaintNo,
                      controllerpkID: edt_Complaint_NoID,
                      Custom_values1: arr_ALL_Name_ID_For_TransectionMode),
                  SizedBox(
                    width: 20,
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Complaint Notes *",
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
                      enabled: false,
                      controller: edt_ComplaintNotes,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Complaint Notes',
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
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Sr No.",
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
                      controller: edt_SrNo,
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Enter No.',
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
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Product",
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
                      controller: edt_Product,
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Select Product',
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
                  showcustomdialogWithID1("Status",
                      enable1: false,
                      title: "Status",
                      hintTextvalue: "Tap to Select Status",
                      icon: Icon(Icons.arrow_drop_down),
                      controllerForLeft: edt_satus,
                      controllerpkID: edt_satusID,
                      Custom_values1: arr_ALL_Name_ID_For_LeadSource),
                  CustomDropDownVisitType("Visit Type",
                      enable1: false,
                      title: "Visit Type",
                      hintTextvalue: "Tap to Select Type",
                      icon: Icon(Icons.arrow_drop_down),
                      controllerForLeft: edt_Type,
                      Custom_values1: arr_ALL_Name_ID_For_Charge_Type),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Visit Notes *",
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
                      controller: edt_VisitNotes,
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
                  Visibility(
                    visible: IsCharged,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showcustomdialogWithID1ChargeType("Charge Type *",
                            enable1: false,
                            title: "Charge Type *",
                            hintTextvalue: "Tap to Select Charge Type",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_TransectionName,
                            controllerpkID: edt_TransectionID,
                            Custom_values1:
                                arr_ALL_Name_ID_For_TransectionMode),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Visit Charge *",
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
                            controller: edt_Amount,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter Amount',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isvisible_Out_time == true
                      ? SizedBox(
                          width: 20,
                          height: 15,
                        )
                      : Container(),
                  isvisible_Out_time == true
                      ? _buildNextFollowupDate()
                      : Container(),
                  isvisible_Out_time == true
                      ? SizedBox(
                          width: 20,
                          height: 15,
                        )
                      : Container(),
                  /*_isForUpdate == true
                            ? _buildPreferredTime()
                            : Container(),*/

                  InkWell(
                    onTap: () {
                      // _selectFromTime(context, _eventControllerIn_Time);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text("In-Time",
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
                                      _eventControllerIn_Time.text == null ||
                                              _eventControllerIn_Time.text == ""
                                          ? "HH:MM:SS"
                                          : _eventControllerIn_Time.text,
                                      style: baseTheme.textTheme.headline3
                                          .copyWith(
                                              color: _eventControllerIn_Time
                                                              .text ==
                                                          null ||
                                                      _eventControllerIn_Time
                                                              .text ==
                                                          ""
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: isvisible_Out_time,
                    child: InkWell(
                      onTap: () {
                        //_selectToTime(context, _eventControllerOut_Time);
                      },
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text("Out-Time",
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
                                        _eventControllerOut_Time.text == null ||
                                                _eventControllerOut_Time.text ==
                                                    ""
                                            ? "HH:MM:SS"
                                            : _eventControllerOut_Time.text,
                                        style: baseTheme.textTheme.headline3
                                            .copyWith(
                                                color: _eventControllerOut_Time
                                                                .text ==
                                                            null ||
                                                        _eventControllerOut_Time
                                                                .text ==
                                                            ""
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
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    height: 15,
                  ),
                  getCommonButton(baseTheme, () async {
                    print("fdsfjk" + "Latttkf : " + _PunchStatus);

                    if (_isForUpdate == true) {
                      if (edt_CustomerName.text != "") {
                        if (isvisible_Out_time == false) {
                          if (edt_NextFollowupDate.text != "") {
                            if (is_LocationService_Permission == true) {
                              bool serviceLocation = await Permission
                                  .locationWhenInUse.serviceStatus.isDisabled;

                              if (serviceLocation == false) {
                                DateTime FbrazilianDate =
                                    new DateFormat("dd-MM-yyyy")
                                        .parse(edt_FollowUpDate.text);
                                DateTime NbrazilianDate =
                                    new DateFormat("dd-MM-yyyy")
                                        .parse(edt_NextFollowupDate.text);

                                if (FbrazilianDate.isBefore(NbrazilianDate)) {
                                  showCommonDialogWithTwoOptions(context,
                                      "Are you sure you want to Save this Visit?",
                                      negativeButtonTitle: "No",
                                      positiveButtonTitle: "Yes",
                                      onTapOfPositiveButton: () {
                                    Navigator.of(context).pop();
                                    String Msg = _isForUpdate == true
                                        ? "Visit Information. Updated Successfully"
                                        : "Visit Information. Added Successfully";
                                    _complaintScreenBloc
                                        .add(QuickComplaintSaveRequestCallEvent(
                                            savepkID,
                                            QuickComplaintSaveRequest(
                                              pkID: savepkID.toString(),
                                              ComplaintNo:
                                                  edt_Complaint_NoID.text,
                                              CustomerID: edt_CustomerID.text,
                                              VisitDate:
                                                  edt_ReverseFollowUpDate.text,
                                              TimeFrom: edt_FromTime.text,
                                              TimeTo: edt_ToTime.text,
                                              VisitNotes: edt_VisitNotes.text,
                                              VisitType: "Visit",
                                              VisitChargeType: edt_Type.text,
                                              VisitCharge:
                                                  edt_TransectionName.text,
                                              ComplaintStatus: edt_satus.text,
                                              TimeIn:
                                                  _eventControllerIn_Time.text,
                                              TimeOut:
                                                  isvisible_Out_time == false
                                                      ? ""
                                                      : _eventControllerOut_Time
                                                          .text,
                                              Latitude_IN: SharedPrefHelper
                                                  .instance
                                                  .getLatitude(),
                                              Longitude_IN: SharedPrefHelper
                                                  .instance
                                                  .getLongitude(),
                                              Latitude_OUT: SharedPrefHelper
                                                  .instance
                                                  .getLatitude(),
                                              Longitude_OUT: SharedPrefHelper
                                                  .instance
                                                  .getLongitude(),
                                              LocationAddress_IN: Address_IN,
                                              LocationAddress_OUT: Address_OUT,
                                              NextVisitDate:
                                                  edt_ReverseNextFollowupDate
                                                      .text,
                                              LoginUserID: LoginUserID,
                                              CompanyId: CompanyID.toString(),
                                            )));
                                  });
                                } else {
                                  if (FbrazilianDate.isAtSameMomentAs(
                                      NbrazilianDate)) {
                                    showCommonDialogWithTwoOptions(context,
                                        "Are you sure you want to Save this Visit?",
                                        negativeButtonTitle: "No",
                                        positiveButtonTitle: "Yes",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context).pop();
                                      String Msg = _isForUpdate == true
                                          ? "Followup Information. Updated Successfully"
                                          : "Followup Information. Added Successfully";

                                      _complaintScreenBloc.add(
                                          QuickComplaintSaveRequestCallEvent(
                                              savepkID,
                                              QuickComplaintSaveRequest(
                                                pkID: savepkID.toString(),
                                                ComplaintNo:
                                                    edt_Complaint_NoID.text,
                                                CustomerID: edt_CustomerID.text,
                                                VisitDate:
                                                    edt_ReverseFollowUpDate
                                                        .text,
                                                TimeFrom: edt_FromTime.text,
                                                TimeTo: edt_ToTime.text,
                                                VisitNotes: edt_VisitNotes.text,
                                                VisitType: "Visit",
                                                VisitChargeType: edt_Type.text,
                                                VisitCharge:
                                                    edt_TransectionName.text,
                                                ComplaintStatus: edt_satus.text,
                                                TimeIn: _eventControllerIn_Time
                                                    .text,
                                                TimeOut: isvisible_Out_time ==
                                                        false
                                                    ? ""
                                                    : _eventControllerOut_Time
                                                        .text,
                                                Latitude_IN: SharedPrefHelper
                                                    .instance
                                                    .getLatitude(),
                                                Longitude_IN: SharedPrefHelper
                                                    .instance
                                                    .getLongitude(),
                                                Latitude_OUT: SharedPrefHelper
                                                    .instance
                                                    .getLatitude(),
                                                Longitude_OUT: SharedPrefHelper
                                                    .instance
                                                    .getLongitude(),
                                                LocationAddress_IN: Address_IN,
                                                LocationAddress_OUT:
                                                    Address_OUT,
                                                NextVisitDate:
                                                    edt_ReverseNextFollowupDate
                                                        .text,
                                                LoginUserID: LoginUserID,
                                                CompanyId: CompanyID.toString(),
                                              )));
                                    });
                                  } else {
                                    showCommonDialogWithSingleOption(context,
                                        "Next Followup Date Should be greater than Followup Date !",
                                        positiveButtonTitle: "OK");
                                  }
                                }
                              } else {
                                location.requestService();
                                await Future.delayed(
                                    const Duration(seconds: 3), () {});
                                baseBloc
                                    .emit(ShowProgressIndicatorState(false));
                              }
                            } else {
                              checkPermissionStatus();
                            }
                          } else {
                            showCommonDialogWithSingleOption(
                                context, "Next FollowupDate is required!",
                                positiveButtonTitle: "OK");
                          }
                        } else {
                          if (edt_VisitNotes.text != "") {
                            if (edt_NextFollowupDate.text != "") {
                              baseBloc.emit(ShowProgressIndicatorState(true));

                              if (is_LocationService_Permission == true) {
                                bool serviceLocation = await Permission
                                    .locationWhenInUse.serviceStatus.isDisabled;

                                if (serviceLocation == false) {
                                  baseBloc
                                      .emit(ShowProgressIndicatorState(false));

                                  DateTime FbrazilianDate =
                                      new DateFormat("dd-MM-yyyy")
                                          .parse(edt_FollowUpDate.text);
                                  DateTime NbrazilianDate =
                                      new DateFormat("dd-MM-yyyy")
                                          .parse(edt_NextFollowupDate.text);

                                  if (FbrazilianDate.isBefore(NbrazilianDate)) {
                                    showCommonDialogWithTwoOptions(context,
                                        "Are you sure you want to Save this Visit?",
                                        negativeButtonTitle: "No",
                                        positiveButtonTitle: "Yes",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context).pop();
                                      String Msg = _isForUpdate == true
                                          ? "Visit Information. Updated Successfully"
                                          : "Visit Information. Added Successfully";

                                      _complaintScreenBloc.add(
                                          QuickComplaintSaveRequestCallEvent(
                                              savepkID,
                                              QuickComplaintSaveRequest(
                                                pkID: savepkID.toString(),
                                                ComplaintNo:
                                                    edt_Complaint_NoID.text,
                                                CustomerID: edt_CustomerID.text,
                                                VisitDate:
                                                    edt_ReverseFollowUpDate
                                                        .text,
                                                TimeFrom: edt_FromTime.text,
                                                TimeTo: edt_ToTime.text,
                                                VisitNotes: edt_VisitNotes.text,
                                                VisitType: "Visit",
                                                VisitChargeType: edt_Type.text,
                                                VisitCharge:
                                                    edt_TransectionName.text,
                                                ComplaintStatus: edt_satus.text,
                                                TimeIn: _eventControllerIn_Time
                                                    .text,
                                                TimeOut: isvisible_Out_time ==
                                                        false
                                                    ? ""
                                                    : _eventControllerOut_Time
                                                        .text,
                                                Latitude_IN: SharedPrefHelper
                                                    .instance
                                                    .getLatitude(),
                                                Longitude_IN: SharedPrefHelper
                                                    .instance
                                                    .getLongitude(),
                                                Latitude_OUT: SharedPrefHelper
                                                    .instance
                                                    .getLatitude(),
                                                Longitude_OUT: SharedPrefHelper
                                                    .instance
                                                    .getLongitude(),
                                                LocationAddress_IN: Address_IN,
                                                LocationAddress_OUT:
                                                    Address_OUT,
                                                NextVisitDate:
                                                    edt_ReverseNextFollowupDate
                                                        .text,
                                                LoginUserID: LoginUserID,
                                                CompanyId: CompanyID.toString(),
                                              )));
                                    });
                                  } else {
                                    if (FbrazilianDate.isAtSameMomentAs(
                                        NbrazilianDate)) {
                                      showCommonDialogWithTwoOptions(context,
                                          "Are you sure you want to Save this Visit?",
                                          negativeButtonTitle: "No",
                                          positiveButtonTitle: "Yes",
                                          onTapOfPositiveButton: () {
                                        Navigator.of(context).pop();
                                        String Msg = _isForUpdate == true
                                            ? "Visit Information. Updated Successfully"
                                            : "Visit Information. Added Successfully";
                                        _complaintScreenBloc.add(
                                            QuickComplaintSaveRequestCallEvent(
                                                savepkID,
                                                QuickComplaintSaveRequest(
                                                  pkID: savepkID.toString(),
                                                  ComplaintNo:
                                                      edt_Complaint_NoID.text,
                                                  CustomerID:
                                                      edt_CustomerID.text,
                                                  VisitDate:
                                                      edt_ReverseFollowUpDate
                                                          .text,
                                                  TimeFrom: edt_FromTime.text,
                                                  TimeTo: edt_ToTime.text,
                                                  VisitNotes:
                                                      edt_VisitNotes.text,
                                                  VisitType: "Visit",
                                                  VisitChargeType:
                                                      edt_Type.text,
                                                  VisitCharge:
                                                      edt_TransectionName.text,
                                                  ComplaintStatus:
                                                      edt_satus.text,
                                                  TimeIn:
                                                      _eventControllerIn_Time
                                                          .text,
                                                  TimeOut: isvisible_Out_time ==
                                                          false
                                                      ? ""
                                                      : _eventControllerOut_Time
                                                          .text,
                                                  Latitude_IN: SharedPrefHelper
                                                      .instance
                                                      .getLatitude(),
                                                  Longitude_IN: SharedPrefHelper
                                                      .instance
                                                      .getLongitude(),
                                                  Latitude_OUT: SharedPrefHelper
                                                      .instance
                                                      .getLatitude(),
                                                  Longitude_OUT:
                                                      SharedPrefHelper.instance
                                                          .getLongitude(),
                                                  LocationAddress_IN:
                                                      Address_IN,
                                                  LocationAddress_OUT:
                                                      Address_OUT,
                                                  NextVisitDate:
                                                      edt_ReverseNextFollowupDate
                                                          .text,
                                                  LoginUserID: LoginUserID,
                                                  CompanyId:
                                                      CompanyID.toString(),
                                                )));
                                      });
                                    } else {
                                      showCommonDialogWithSingleOption(context,
                                          "Next Followup Date Should be greater than Followup Date !",
                                          positiveButtonTitle: "OK");
                                    }
                                  }
                                } else {
                                  location.requestService();
                                  await Future.delayed(
                                      const Duration(seconds: 3), () {});
                                  baseBloc
                                      .emit(ShowProgressIndicatorState(false));
                                }
                              } else {
                                checkPermissionStatus();
                              }
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "Next FollowupDate is required!",
                                  positiveButtonTitle: "OK");
                            }
                          } else {
                            showCommonDialogWithSingleOption(
                                context, "Meeting Notes is required!",
                                positiveButtonTitle: "OK");
                          }
                        }
                      } else {
                        showCommonDialogWithSingleOption(
                            context, "Select Proper Customer From List!",
                            positiveButtonTitle: "OK",
                            onTapOfPositiveButton: () {
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      if (edt_CustomerName.text != "") {
                        if (is_LocationService_Permission == true) {
                          bool serviceLocation = await Permission
                              .locationWhenInUse.serviceStatus.isDisabled;

                          if (serviceLocation == false) {
                            // _getCurrentLocation();

                            DateTime FbrazilianDate =
                                new DateFormat("dd-MM-yyyy")
                                    .parse(edt_FollowUpDate.text);
                            DateTime NbrazilianDate =
                                new DateFormat("dd-MM-yyyy")
                                    .parse(edt_NextFollowupDate.text);

                            if (FbrazilianDate.isBefore(NbrazilianDate)) {
                              showCommonDialogWithTwoOptions(context,
                                  "Are you sure you want to Save this Visit?",
                                  negativeButtonTitle: "No",
                                  positiveButtonTitle: "Yes",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                                String Msg = _isForUpdate == true
                                    ? "Visit Information. Updated Successfully"
                                    : "Visit Information. Added Successfully";
                                _complaintScreenBloc
                                    .add(QuickComplaintSaveRequestCallEvent(
                                        savepkID,
                                        QuickComplaintSaveRequest(
                                          pkID: savepkID.toString(),
                                          ComplaintNo: edt_Complaint_NoID.text,
                                          CustomerID: edt_CustomerID.text,
                                          VisitDate:
                                              edt_ReverseFollowUpDate.text,
                                          TimeFrom: edt_FromTime.text,
                                          TimeTo: edt_ToTime.text,
                                          VisitNotes: edt_VisitNotes.text,
                                          VisitType: "Visit",
                                          VisitChargeType: edt_Type.text,
                                          VisitCharge: edt_TransectionName.text,
                                          ComplaintStatus: edt_satus.text,
                                          TimeIn: _eventControllerIn_Time.text,
                                          TimeOut: "",
                                          Latitude_IN: SharedPrefHelper.instance
                                              .getLatitude(),
                                          Longitude_IN: SharedPrefHelper
                                              .instance
                                              .getLongitude(),
                                          Latitude_OUT: SharedPrefHelper
                                              .instance
                                              .getLatitude(),
                                          Longitude_OUT: SharedPrefHelper
                                              .instance
                                              .getLongitude(),
                                          LocationAddress_IN: Address_IN,
                                          LocationAddress_OUT: Address_OUT,
                                          NextVisitDate:
                                              edt_ReverseNextFollowupDate.text,
                                          LoginUserID: LoginUserID,
                                          CompanyId: CompanyID.toString(),
                                        )));
                              });
                            } else {
                              if (FbrazilianDate.isAtSameMomentAs(
                                  NbrazilianDate)) {
                                showCommonDialogWithTwoOptions(context,
                                    "Are you sure you want to Save this Visit?",
                                    negativeButtonTitle: "No",
                                    positiveButtonTitle: "Yes",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context).pop();
                                  String Msg = _isForUpdate == true
                                      ? "Visit Information. Updated Successfully"
                                      : "Visit Information. Added Successfully";
                                  _complaintScreenBloc
                                      .add(QuickComplaintSaveRequestCallEvent(
                                          savepkID,
                                          QuickComplaintSaveRequest(
                                            pkID: savepkID.toString(),
                                            ComplaintNo:
                                                edt_Complaint_NoID.text,
                                            CustomerID: edt_CustomerID.text,
                                            VisitDate:
                                                edt_ReverseFollowUpDate.text,
                                            TimeFrom: edt_FromTime.text,
                                            TimeTo: edt_ToTime.text,
                                            VisitNotes: edt_VisitNotes.text,
                                            VisitType: "Visit",
                                            VisitChargeType: edt_Type.text,
                                            VisitCharge:
                                                edt_TransectionName.text,
                                            ComplaintStatus: edt_satus.text,
                                            TimeIn:
                                                _eventControllerIn_Time.text,
                                            TimeOut: "",
                                            Latitude_IN: SharedPrefHelper
                                                .instance
                                                .getLatitude(),
                                            Longitude_IN: SharedPrefHelper
                                                .instance
                                                .getLongitude(),
                                            Latitude_OUT: SharedPrefHelper
                                                .instance
                                                .getLatitude(),
                                            Longitude_OUT: SharedPrefHelper
                                                .instance
                                                .getLongitude(),
                                            LocationAddress_IN: Address_IN,
                                            LocationAddress_OUT: Address_OUT,
                                            NextVisitDate:
                                                edt_ReverseNextFollowupDate
                                                    .text,
                                            LoginUserID: LoginUserID,
                                            CompanyId: CompanyID.toString(),
                                          )));
                                });
                              } else {
                                showCommonDialogWithSingleOption(context,
                                    "Next Followup Date Should be greater than Followup Date !",
                                    positiveButtonTitle: "OK");
                              }
                            }
                          } else {
                            location.requestService();
                            await Future.delayed(
                                const Duration(seconds: 3), () {});
                            baseBloc.emit(ShowProgressIndicatorState(false));
                          }
                        } else {
                          checkPermissionStatus();
                        }
                      } else {
                        showCommonDialogWithSingleOption(
                            context, "Select Proper Customer From List!",
                            positiveButtonTitle: "OK",
                            onTapOfPositiveButton: () {
                          Navigator.pop(context);
                        });
                      }
                    }
                  }, "Save"),
                  SizedBox(
                    width: 20,
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        //_selectDate(context, edt_FollowUpDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Attended On *",
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
                      edt_FollowUpDate.text == null ||
                              edt_FollowUpDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_FollowUpDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_FollowUpDate.text == null ||
                                  edt_FollowUpDate.text == ""
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

  Widget _buildNextFollowupDate() {
    return InkWell(
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

  Widget ComplaintDropDown(String Category,
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
            onTap: () => arr_ALL_Name_ID_For_ComplaintNoList.length != 0
                ? showcustomdialogWithComplaintID(
                    values: arr_ALL_Name_ID_For_ComplaintNoList,
                    context1: context,
                    controller: edt_ComplaintNo,
                    controllerID: edt_Complaint_NoID,
                    lable: "Select Complaint No.")
                : Container(),
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

  showcustomdialogWithComplaintID(
      {List<ALL_Name_ID> values,
      BuildContext context1,
      TextEditingController controller,
      TextEditingController controllerID,
      String lable}) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    lable,
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context1).pop();
                                  controller.text = values[index].Name;
                                  controllerID.text =
                                      values[index].pkID.toString();

                                  _complaintScreenBloc.add(
                                      ComplaintSearchByIDCallEvent(
                                          values[index].pkID,
                                          ComplaintSearchByIDRequest(
                                              CompanyId: CompanyID.toString(),
                                              LoginUserID: LoginUserID)));

                                  print("IDSS : " +
                                      values[index].pkID.toString());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorPrimary), //Change color
                                        width: 10.0,
                                        height: 10.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          values[index].Name,
                                          style: TextStyle(
                                              color: colorPrimary,
                                              fontSize: 12),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              /* return SimpleDialogOption(
                              onPressed: () => {
                                controller.text = values[index].Name,
                                controller2.text = values[index].Name1,
                              Navigator.of(context1).pop(),


                            },
                              child: Text(values[index].Name),
                            );*/
                            },
                            itemCount: values.length,
                          ),
                        ])),
                  ],
                )),
            /*Center(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Color(0xFFF27442),
                  borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFF27442))),
              //color: Color(0xFFF27442),
              child: GestureDetector(
                child: Text(
                  "Close",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),*/
          ],
        );
      },
    );
  }

  fetchComplaintNodetails() {
    for (var i = 0; i <= 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "TK-OCT22-001";
      } else if (i == 1) {
        all_name_id.Name = "TK-OCT22-002";
      } else if (i == 2) {
        all_name_id.Name = "TK-OCT22-003";
      } else if (i == 3) {
        all_name_id.Name = "TK-OCT22-004";
      }
      arr_ALL_Name_ID_For_ComplaintNo.add(all_name_id);
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
            onTap: () => _complaintScreenBloc.add(CustomerSourceCallEvent(
                CustomerSourceRequest(
                    pkID: "0",
                    StatusCategory: "ComplaintStatus",
                    companyId: CompanyID,
                    LoginUserID: LoginUserID,
                    SearchKey: ""))),
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
          controller: edt_satus,
          controllerID: edt_satusID,
          lable: "Select Status");
    }
  }

  FetchTypeDetails() {
    arr_ALL_Name_ID_For_Charge_Type.clear();
    for (var i = 0; i <= 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Free";
      } else if (i == 1) {
        all_name_id.Name = "Charged";
      }
      arr_ALL_Name_ID_For_Charge_Type.add(all_name_id);
    }
  }

  Widget CustomDropDownVisitType(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_For_Charge_Type,
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

  Widget showcustomdialogWithID1ChargeType(String Category,
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
            onTap: () => _complaintScreenBloc.add(TransectionModeCallEvent(
                TransectionModeListRequest(CompanyID: CompanyID.toString()))),
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

  void _OnTransectionModeSucess(TransectionModeResponseState state) {
    if (state.transectionModeListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_TransectionMode.clear();
      for (var i = 0;
          i < state.transectionModeListResponse.details.length;
          i++) {
        print("InquiryStatus : " +
            state.transectionModeListResponse.details[i].walletName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.transectionModeListResponse.details[i].walletName;
        all_name_id.pkID = state.transectionModeListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_TransectionMode.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_TransectionMode,
          context1: context,
          controller: edt_TransectionName,
          controllerID: edt_TransectionID,
          lable: "Select ChargeType");
    }
  }

  Widget _buildBankACSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfBankACSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Customer Name * ",
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
                          hintText: "Search Customer",
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

  Future<void> _onTapOfBankACSearchView() async {
    if (_isForUpdate == false) {
      navigateTo(context, SearchComplaintCustomerScreen.routeName)
          .then((value) {
        if (value != null) {
          _searchDetails = value;
          edt_CustomerID.text = _searchDetails.value.toString();
          edt_CustomerName.text = _searchDetails.label.toString();
          _complaintScreenBloc.add(ComplaintNoListCallEvent(
              ComplaintNoListRequest(
                  CustomerID: _searchDetails.value.toString(),
                  CompanyId: CompanyID.toString())));

          /*  _FollowupBloc.add(SearchBankVoucherCustomerListByNameCallEvent(
              CustomerLabelValueRequest(
                  CompanyId: CompanyID.toString(),
                  LoginUserID: "admin",
                  word: _searchDetails.value.toString())));*/
        }
        print("CustomerInfo : " +
            edt_CustomerName.text.toString() +
            " CustomerID : " +
            edt_CustomerID.text.toString());
      });
    }
  }

  void _OnComplaintNoListResponseSucess(
      ComplaintNoListCallResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_ComplaintNoList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].complaintNo);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].complaintNo;
        all_name_id.pkID = state.response.details[i].visitID;
        arr_ALL_Name_ID_For_ComplaintNoList.add(all_name_id);
      }
    }
  }

  /* Future<String> getAddressFromLatLng(
      String lat, String lng, String skey) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$skey&latlng=$lat,$lng';
    if (lat != "" && lng != "null") {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        //Address = _formattedAddress;
        print("response ==== $_formattedAddress");
        return _formattedAddress;
      } else
        return null;
    } else
      return null;
  }
*/
  Future<String> getAddressFromLatLngMapMyIndia(
      String lat, String lng, String skey) async {
    String _host =
        'https://apis.mapmyindia.com/advancedmaps/v1/$skey/rev_geocode';
    final url = '$_host?lat=$lat&lng=$lng';

    print("MapRequest" + url);
    if (lat != "" && lng != "null") {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        //Address = _formattedAddress;
        print("response ==== $_formattedAddress");
        return _formattedAddress;
      } else
        return null;
    } else
      return null;
  }

  void checkPermissionStatus() async {
    bool granted = await Permission.location.isGranted;
    bool Denied = await Permission.location.isDenied;
    bool PermanentlyDenied = await Permission.location.isPermanentlyDenied;

    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());

    if (Denied == true) {
      // openAppSettings();
      is_LocationService_Permission = false;
      /*showCommonDialogWithSingleOption(context,
          "Location permission is required , You have to click on OK button to Allow the location access !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
        await openAppSettings();
        Navigator.of(context).pop();
      });*/
      await Permission.storage.request();

      // await Permission.location.request();
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      is_LocationService_Permission = false;
      openAppSettings();
    }

    if (granted == true) {
      // The OS restricts access, for example because of parental controls.
      is_LocationService_Permission = true;
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HemaAttendVisitListScreen.routeName,
        clearAllStack: true);
  }

  void _OnVisitSaveSucess(QuickComplaintSaveResponseState state) {
    showCommonDialogWithSingleOption(
        Globals.context, state.response.details[0].column2,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, HemaAttendVisitListScreen.routeName,
          clearAllStack: true);
    });
  }

  Future<void> _selectFromTime(
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

        edt_FromTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }

  Future<void> _selectToTime(
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

        edt_ToTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }
}
