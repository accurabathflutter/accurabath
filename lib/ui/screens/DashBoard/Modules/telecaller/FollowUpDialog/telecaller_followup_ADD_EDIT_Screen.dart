import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/telecaller/telecaller_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_type_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/closer_reason_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/tele_caller_followup_save_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_status_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class AddUpdateFollowupFromTeleCallerScreenArguments {
  String editModel;

  AddUpdateFollowupFromTeleCallerScreenArguments(this.editModel);
}

class FollowUpFromTeleCallerddEditScreen extends BaseStatefulWidget {
  static const routeName = '/FollowUpFromTeleCallerAddEditScreen';
  final AddUpdateFollowupFromTeleCallerScreenArguments arguments;

  FollowUpFromTeleCallerddEditScreen(this.arguments);

  @override
  _FollowUpFromTeleCallerddEditScreenState createState() =>
      _FollowUpFromTeleCallerddEditScreenState();
}

class _FollowUpFromTeleCallerddEditScreenState
    extends BaseState<FollowUpFromTeleCallerddEditScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // FollowupTypeListResponse _offlineFollowupTypeListResponseData;
  // InquiryStatusListResponse _offlineInquiryLeadStatusData;

  final TextEditingController edt_FollowupType = TextEditingController();
  final TextEditingController edt_FollowupTypepkID = TextEditingController();

  final TextEditingController edt_FollowUpDate = TextEditingController();
  final TextEditingController edt_ReverseFollowUpDate = TextEditingController();

  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_FollowupInquiryStatusType =
      TextEditingController();
  final TextEditingController edt_FollowupInquiryStatusTypepkID =
      TextEditingController();

  final TextEditingController edt_CloserReasonStatusType =
      TextEditingController();
  final TextEditingController edt_CloserReasonStatusTypepkID =
      TextEditingController();

  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_InqNo = TextEditingController();
  final TextEditingController edt_FollowupNotes = TextEditingController();
  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_ReverseNextFollowupDate =
      TextEditingController();

  final TextEditingController edt_PreferedTime = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_FolowupType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_FolowupInquiryStatusType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_CloserReasonStatusType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_InquiryNoListType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_FolowupInquiryByCustomerID = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  SearchDetails _searchDetails;
  TeleCallerBloc _FollowupBloc;
  int savepkID = 0;
  bool _isForUpdate;
  bool _isInqury_details_Exist;

  String _editModel;
  double _rating;
  bool _isSwitched;
  File _selectedImageFile;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  //CloserReasonListResponse _offlilineFollowupCloserReasonListData;

  int CompanyID = 0;
  String LoginUserID = "";
  bool is_closer_reasonVisible;
  String fileName = "";
  String ImageURLFromListing = "";
  String SiteURL = "";
  String GetImageNamefromEditMode = "";
  FocusNode NotesFocusNode;

  Location location = new Location();

  bool _serviceEnabled;
  Position _currentPosition;
  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;

  bool is_LocationService_Permission;
  bool SaveSucess;
  bool is_Storage_Service_Permission;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  final TextEditingController edt_LeadStatus = TextEditingController();
  ALL_EmployeeList_Response _offlineALLEmployeeListData;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  final TextEditingController edt_EmployeeID = TextEditingController();
  final TextEditingController edt_EmployeeName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();
    _onALLEmplyeeList(_offlineALLEmployeeListData);

    LeadStatus();
    edt_LeadStatus.addListener(() {
      setState(() {});
    });

    // permission();
    // checkPhotoPermissionStatus();
    checkPermissionStatus();
    // _offlineFollowupTypeListResponseData = SharedPrefHelper.instance.getFollowupTypeListResponse();
    // _offlineInquiryLeadStatusData = SharedPrefHelper.instance.getInquiryLeadStatus();
    // _offlilineFollowupCloserReasonListData = SharedPrefHelper.instance.getFollowupCloserReason();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;

    SaveSucess = false;
    _FollowupBloc = TeleCallerBloc(baseBloc);
    NotesFocusNode = FocusNode();

    // _onFollowupListTypeCallSuccess(_offlineFollowupTypeListResponseData);
    //_onFollowupInquiryStatusListTypeCallSuccess(_offlineInquiryLeadStatusData);
    //_onCloserReasonStatusListTypeCallSuccess(_offlilineFollowupCloserReasonListData);
    FetchFollowupPriorityDetails();
    FetchFollowupStatusDetails();
    edt_Priority.addListener(() {
      NotesFocusNode.requestFocus();
    });

    //picked_s.periodOffset.toString();

    /* _FollowupBloc
      ..add(FollowupInquiryStatusTypeListByNameCallEvent(
          FollowupInquiryStatusTypeListRequest(
              CompanyId: CompanyID.toString(), pkID: "", StatusCategory: "Inquiry",LoginUserID: LoginUserID,SearchKey: "")));*/

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;

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

      setState(() {});
      //fillData();
    } else {
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

      setState(() {});
    }

    _rating = 4.0;
    _isSwitched = false;
    _isInqury_details_Exist = false;
    is_closer_reasonVisible = false;

    edt_FollowupInquiryStatusType.addListener(() {
      if (edt_FollowupInquiryStatusType.text == "Close - Lost") {
        is_closer_reasonVisible = true;
      } else {
        is_closer_reasonVisible = false;
      }
      setState(() {});
    });
    isExistINQFromEDIT();
    if (SaveSucess == true) {
      _onOldState();
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    NotesFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      /* ..add(FollowupTypeListByNameCallEvent(FollowupTypeListRequest(
            CompanyId: CompanyID.toString(), pkID: "", StatusCategory: "FollowUp"))),*/

      child: BlocConsumer<TeleCallerBloc, TeleCallerStates>(
        builder: (BuildContext context, TeleCallerStates state) {
          /* if (state is FollowupInquiryNoListCallResponseState) {
            _onInquiryNoListTypeCallSuccess(state);
          }
          if (state is FollowupCustomerListByNameCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }*/

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          /*if (currentState is FollowupCustomerListByNameCallResponseState ||
              currentState is FollowupInquiryStatusListCallResponseState ||
              currentState is FollowupInquiryNoListCallResponseState) {
            return true;
          }*/
          return false;
        },
        listener: (BuildContext context, TeleCallerStates state) {
          /*  if (state is FollowupInquiryByCustomerIdCallResponseState) {
            _onFollowupInquiryByCustomerIDCallSuccess(state);
          }
          if (state is FollowupSaveCallResponseState) {
            _onFollowupSaveCallSuccess(state);
          }
          if (state is FollowupImageDeleteCallResponseState) {
            _OnDeleteFollowupImageResponseSucess(state);
          }
          if (state is FollowupUploadImageCallResponseState) {
            _OnFollowupImageUploadSucessResponse(state);
          }

          if (state is FollowupTypeListCallResponseState) {
            _onFollowupListTypeCallSuccess(state);
          }
          if (state is InquiryLeadStatusListCallResponseState) {
            _onLeadStatusListTypeCallSuccess(state);
          }
          if (state is CloserReasonListCallResponseState) {
            _onCloserReasonStatusListTypeCallSuccess(state);
          }*/

          if (state is FollowupTypeListCallResponseState) {
            _onFollowupListTypeCallSuccess(state);
          }

          if (state is CloserReasonListCallResponseState) {
            _onCloserReasonStatusListTypeCallSuccess(state);
          }

          if (state is TeleCallerFollowupSaveResponseState) {
            _OnFollowupSaveResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          /*if (currentState is FollowupInquiryByCustomerIdCallResponseState ||
              currentState is FollowupSaveCallResponseState ||
              currentState is FollowupImageDeleteCallResponseState ||
              currentState is FollowupUploadImageCallResponseState ||
              currentState is FollowupTypeListCallResponseState ||
              currentState is InquiryLeadStatusListCallResponseState ||
              currentState is CloserReasonListCallResponseState) {
            return true;
          }*/

          if (currentState is FollowupTypeListCallResponseState ||
              currentState is CloserReasonListCallResponseState ||
              currentState is TeleCallerFollowupSaveResponseState) {
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
          title: Text('Followup Details'),
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
                  navigateTo(context, TeleCallerListScreen.routeName,
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

                        // _buildSearchView(),
                        Visibility(
                          visible: _isInqury_details_Exist,
                          child: showcustomdialogWithMultiID1("Inquiry #",
                              enable1: false,
                              title: "Inquiry #",
                              hintTextvalue: "Tap to Select Inquiry#",
                              icon: Icon(Icons.arrow_drop_down),
                              controllerForLeft: edt_InqNo,
                              controller1: edt_FollowupInquiryStatusType,
                              controllerpkID: edt_FollowupInquiryStatusTypepkID,
                              Custom_values1:
                                  arr_ALL_Name_ID_For_FolowupInquiryByCustomerID),
                        ),
                        showcustomdialogWithID1("Followup Type",
                            enable1: false,
                            title: "Followup Type *",
                            hintTextvalue: "Tap to Select Followup Type",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_FollowupType,
                            controllerpkID: edt_FollowupTypepkID,
                            Custom_values1: arr_ALL_Name_ID_For_FolowupType),
                        /* CustomDropDown1("Priority",
                            enable1: false,
                            title: "Priority *",
                            hintTextvalue: "Tap to Select Priority",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Priority,
                            Custom_values1:
                            arr_ALL_Name_ID_For_Folowup_Priority),*/

                        /* CustomDropDown1("Followup Status",
                              enable1: false,
                              title: "Followup Status",
                              hintTextvalue: "Tap to Followup Status",
                              icon: Icon(Icons.arrow_drop_down),
                              controllerForLeft: edt_FollowupStatus,
                              Custom_values1: arr_ALL_Name_ID_For_Folowup_Status),
*/

                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Followup Notes *",
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
                            focusNode: NotesFocusNode,
                            controller: edt_FollowupNotes,
                            minLines: 2,
                            maxLines: 5,
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
                          width: 20,
                          height: 15,
                        ),
                        _buildNextFollowupDate(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        _buildPreferredTime(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        /* LeadStatusDropDown(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),*/
                        /*edt_LeadStatus.text == "Disqualified"
                            ? Container()
                            : _buildEmplyeeListView(),*/
                        Visibility(
                          visible: _isInqury_details_Exist,
                          child: showcustomdialogWithID1("Inquiry Status",
                              enable1: false,
                              title: "Inquiry Status",
                              hintTextvalue: "Tap to Select Inquiry Status",
                              icon: Icon(Icons.arrow_drop_down),
                              controllerForLeft: edt_FollowupInquiryStatusType,
                              controllerpkID: edt_FollowupInquiryStatusTypepkID,
                              Custom_values1:
                                  arr_ALL_Name_ID_For_FolowupInquiryStatusType),
                        ),
                        Visibility(
                          visible: edt_LeadStatus.text == "Disqualified"
                              ? true
                              : false,
                          child: Container(
                            child: showcustomdialogWithID1("Closer Reason",
                                enable1: false,
                                title: "Closer Reason",
                                hintTextvalue: "Tap to Select Closer Reason",
                                icon: Icon(Icons.arrow_drop_down),
                                controllerForLeft: edt_CloserReasonStatusType,
                                controllerpkID: edt_CloserReasonStatusTypepkID,
                                Custom_values1:
                                    arr_ALL_Name_ID_For_CloserReasonStatusType),
                          ),
                        ),
                        /*SizedBox(
                          width: 20,
                          height: 30,
                        ),
                        RatingStar(),
                        SizedBox(
                          width: 20,
                          height: 30,
                        ),
                        SwitchNoFollowup(),
                        SizedBox(
                          width: 20,
                          height: 30,
                        ),
                        uploadImage(context),
                        SizedBox(
                          width: 20,
                          height: 30,
                        ),*/
                        SizedBox(
                          width: 20,
                          height: 30,
                        ),
                        getCommonButton(baseTheme, () async {
                          print("RatingValue " +
                              "Rate : " +
                              _rating.toInt().toString());
                          int nofollowupvalue = 0;
                          if (_isSwitched == false) {
                            nofollowupvalue = 0;
                          } else {
                            nofollowupvalue = 1;
                          }

                          print("SwitchValue " +
                              "Switch : " +
                              nofollowupvalue.toString());

                          if (edt_FollowupType.text != "") {
                            if (edt_FollowupNotes.text != "") {
                              if (edt_NextFollowupDate.text != "") {
                                /*baseBloc
                                        .emit(ShowProgressIndicatorState(true));
*/
                                if (is_LocationService_Permission == true) {
                                  bool serviceLocation = await Permission
                                      .locationWhenInUse
                                      .serviceStatus
                                      .isDisabled;

                                  // if (serviceLocation == false) {
                                  // baseBloc.emit(ShowProgressIndicatorState(false));

                                  DateTime FbrazilianDate =
                                      new DateFormat("dd-MM-yyyy")
                                          .parse(edt_FollowUpDate.text);
                                  DateTime NbrazilianDate =
                                      new DateFormat("dd-MM-yyyy")
                                          .parse(edt_NextFollowupDate.text);

                                  if (FbrazilianDate.isBefore(NbrazilianDate)) {
                                    showCommonDialogWithTwoOptions(context,
                                        "Are you sure you want to Save this Follow-Up?",
                                        negativeButtonTitle: "No",
                                        positiveButtonTitle: "Yes",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context).pop();
                                      String Msg = _isForUpdate == true
                                          ? "Followup Information. Updated Successfully"
                                          : "Followup Information. Added Successfully";

                                      _FollowupBloc.add(
                                          TeleCallerFollowupSaveRequestEvent(
                                              TeleCallerFollowupSaveRequest(
                                        pkID: "0",
                                        ExtpkID:
                                            _editModel != "" ? _editModel : "0",
                                        FollowupDate:
                                            edt_ReverseFollowUpDate.text,
                                        FollowupSource: edt_FollowupType.text,
                                        InquiryStatusID: "0",
                                        MeetingNotes: edt_FollowupNotes.text,
                                        NextFollowupDate:
                                            edt_ReverseNextFollowupDate.text,
                                        PreferredTime: edt_PreferedTime.text,
                                        LeadStatus: "InProcess",
                                        NoFollClosureID:
                                            edt_CloserReasonStatusTypepkID.text,
                                        AssignToEmployee: _offlineLoggedInData
                                            .details[0].employeeID
                                            .toString(),
                                        LoginUserID: LoginUserID,
                                        CompanyId: CompanyID.toString(),
                                      )));
                                      /*_FollowupBloc.add(FollowupSaveByNameCallEvent(
                                                  Msg,
                                                  context,
                                                  savepkID,
                                                  FollowupSaveApiRequest(
                                                      pkID: savepkID.toString(),
                                                      FollowupDate: edt_ReverseFollowUpDate
                                                          .text,
                                                      CustomerID:
                                                      edt_CustomerpkID.text,
                                                      InquiryNo:
                                                      edt_InqNo.text == "null"
                                                          ? ""
                                                          : edt_InqNo.text,
                                                      MeetingNotes:
                                                      edt_FollowupNotes.text,
                                                      NextFollowupDate:
                                                      edt_ReverseNextFollowupDate
                                                          .text,
                                                      Rating: _rating
                                                          .toInt()
                                                          .toString(),
                                                      FollowupTypeId:
                                                      edt_FollowupTypepkID.text == "null"
                                                          ? ""
                                                          : edt_FollowupTypepkID
                                                          .text,
                                                      LoginUserID: LoginUserID,
                                                      Address: "",
                                                      NoFollowup: nofollowupvalue
                                                          .toString(),
                                                      InquiryStatusId: edt_FollowupInquiryStatusTypepkID.text == "null"
                                                          ? ""
                                                          : edt_FollowupInquiryStatusTypepkID
                                                          .text,
                                                      Latitude: Latitude,
                                                      Longitude: Longitude,
                                                      PreferredTime:
                                                      edt_PreferedTime.text,
                                                      ClosureReasonId:
                                                      edt_CloserReasonStatusTypepkID.text == "null"
                                                          ? ""
                                                          : edt_CloserReasonStatusTypepkID.text,
                                                      CompanyId: CompanyID.toString(),
                                                      FollowupPriority: FollowupPriorityDetails,
                                                      FollowUpImage: fileName)));*/
                                    });
                                  } else {
                                    if (FbrazilianDate.isAtSameMomentAs(
                                        NbrazilianDate)) {
                                      showCommonDialogWithTwoOptions(context,
                                          "Are you sure you want to Save this Follow-Up?",
                                          negativeButtonTitle: "No",
                                          positiveButtonTitle: "Yes",
                                          onTapOfPositiveButton: () {
                                        Navigator.of(context).pop();
                                        String Msg = _isForUpdate == true
                                            ? "Followup Information. Updated Successfully"
                                            : "Followup Information. Added Successfully";

                                        _FollowupBloc.add(
                                            TeleCallerFollowupSaveRequestEvent(
                                                TeleCallerFollowupSaveRequest(
                                          pkID: "0",
                                          ExtpkID: _editModel != ""
                                              ? _editModel
                                              : "0",
                                          FollowupDate:
                                              edt_ReverseFollowUpDate.text,
                                          FollowupSource: edt_FollowupType.text,
                                          InquiryStatusID: "0",
                                          MeetingNotes: edt_FollowupNotes.text,
                                          NextFollowupDate:
                                              edt_ReverseNextFollowupDate.text,
                                          PreferredTime: edt_PreferedTime.text,
                                          LeadStatus: "InProcess",
                                          NoFollClosureID:
                                              edt_CloserReasonStatusTypepkID
                                                  .text,
                                          AssignToEmployee: _offlineLoggedInData
                                              .details[0].employeeID
                                              .toString(),
                                          LoginUserID: LoginUserID,
                                          CompanyId: CompanyID.toString(),
                                        )));
                                        /* _FollowupBloc.add(FollowupSaveByNameCallEvent(
                                                    Msg,
                                                    context,
                                                    savepkID,
                                                    FollowupSaveApiRequest(
                                                        pkID: savepkID.toString(),
                                                        FollowupDate:
                                                        edt_ReverseFollowUpDate
                                                            .text,
                                                        CustomerID:
                                                        edt_CustomerpkID.text,
                                                        InquiryNo:
                                                        edt_InqNo.text == "null"
                                                            ? ""
                                                            : edt_InqNo.text,
                                                        MeetingNotes:
                                                        edt_FollowupNotes.text,
                                                        NextFollowupDate:
                                                        edt_ReverseNextFollowupDate
                                                            .text,
                                                        Rating: _rating
                                                            .toInt()
                                                            .toString(),
                                                        FollowupTypeId:
                                                        edt_FollowupTypepkID.text == "null"
                                                            ? ""
                                                            : edt_FollowupTypepkID
                                                            .text,
                                                        LoginUserID: LoginUserID,
                                                        Address: "",
                                                        NoFollowup: nofollowupvalue
                                                            .toString(),
                                                        InquiryStatusId:
                                                        edt_FollowupInquiryStatusTypepkID.text == "null"
                                                            ? ""
                                                            : edt_FollowupInquiryStatusTypepkID
                                                            .text,
                                                        Latitude: Latitude,
                                                        Longitude: Longitude,
                                                        PreferredTime:
                                                        edt_PreferedTime.text,
                                                        ClosureReasonId:
                                                        edt_CloserReasonStatusTypepkID.text == "null"
                                                            ? ""
                                                            : edt_CloserReasonStatusTypepkID.text,
                                                        CompanyId: CompanyID.toString(),
                                                        FollowupPriority: FollowupPriorityDetails,
                                                        FollowUpImage: fileName)));*/
                                      });
                                    } else {
                                      showCommonDialogWithSingleOption(context,
                                          "Next Followup Date Should be greater than Followup Date !",
                                          positiveButtonTitle: "OK");
                                    }
                                  }
                                  /*}else {
                                        location.requestService();
                                        await Future.delayed(
                                            const Duration(seconds: 3), () {});
                                        baseBloc.emit(
                                            ShowProgressIndicatorState(false));
                                      }*/
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
                                  context, "Followup Notes is required!",
                                  positiveButtonTitle: "OK");
                            }
                          } else {
                            showCommonDialogWithSingleOption(
                                context, "Please Select Followup Type!",
                                positiveButtonTitle: "OK");
                          }
                        }, "Save"),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                      ]))),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, TeleCallerListScreen.routeName, clearAllStack: true);
  }

  Future<bool> _onOldState() {
    Navigator.of(context).pop();
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
      });
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

  FetchFollowupPriorityDetails() {
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

  FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Initialized";
      } else if (i == 1) {
        all_name_id.Name = "Pending";
      } else if (i == 2) {
        all_name_id.Name = "Sucess";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        //  _onTapOfSearchView();
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

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _selectDate(context, edt_FollowUpDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("FollowUp Date *",
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

  Widget _buildPreferredTime() {
    return InkWell(
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
    );
  }

  void _onFollowupListTypeCallSuccess(FollowupTypeListCallResponseState state) {
    if (state.followupTypeListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_FolowupType.clear();
      for (var i = 0; i < state.followupTypeListResponse.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.followupTypeListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.followupTypeListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_FolowupType.add(all_name_id);
      }

      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_FolowupType,
          context1: context,
          controller: edt_FollowupType,
          controllerID: edt_FollowupTypepkID,
          lable: "Select Followup Type");
    }
  }

  void _onFollowupInquiryStatusListTypeCallSuccess(
      InquiryStatusListResponse state) {
    if (state.details != null) {
      arr_ALL_Name_ID_For_FolowupInquiryStatusType.clear();
      for (var i = 0; i < state.details.length; i++) {
        print("InquiryStatus : " + state.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].inquiryStatus;
        all_name_id.pkID = state.details[i].pkID;
        arr_ALL_Name_ID_For_FolowupInquiryStatusType.add(all_name_id);
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

  Widget CustomDropDown1(String Category,
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
      margin: EdgeInsets.only(top: 15, bottom: 15),
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

  Widget showcustomdialogWithMultiID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithMultipleID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controller2: controller1,
                controllerID: controllerpkID,
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

  Widget RatingStar() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Rating",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          child: RatingBar.builder(
            initialRating: 3,
            itemCount: 5,
            itemSize: 40,
            itemPadding: EdgeInsets.only(left: 15, right: 15),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  );
                case 2:
                  return Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
                case 3:
                  return Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
                default:
                  return Container();
              }
            },
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
              print("DefaultRating" + "Default : " + rating.toString());
            },
          ),
        ),
      ],
    ));
  }

  Widget SwitchNoFollowup() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("No Followup",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: Switch(
              value: _isSwitched,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.red,
              onChanged: (value) {
                print("_isSwitchedVALUE : $value");
                setState(() {
                  _isSwitched = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void isExistINQFromEDIT() {
    if (edt_InqNo.text != "") {
      _isInqury_details_Exist = true;
    } else {
      _isInqury_details_Exist = false;
    }
    setState(() {});
  }

  CreateDialogDropdown(String category) {
    if (category == "Followup Type") {
      _FollowupBloc.add(FollowupTypeListByNameCallEvent(FollowupTypeListRequest(
          CompanyId: CompanyID.toString(),
          pkID: "",
          StatusCategory: "FollowUp",
          LoginUserID: LoginUserID,
          SearchKey: "")));
    } else {
      _FollowupBloc
        ..add(CloserReasonTypeListByNameCallEvent(CloserReasonTypeListRequest(
            CompanyId: CompanyID.toString(),
            pkID: "",
            StatusCategory: "DisQualifiedReason",
            LoginUserID: LoginUserID,
            SearchKey: "")));
    }
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

      await Permission.location.request();

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
      // openAppSettings();
      is_Storage_Service_Permission = false;

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
      is_Storage_Service_Permission = false;
      openAppSettings();
    }

    if (granted == true) {
      // The OS restricts access, for example because of parental controls.
      is_Storage_Service_Permission = true;
    }
  }

  Future<void> permission() async {
    if (await Permission.storage.isDenied) {
      //await Permission.storage.request();

      checkPhotoPermissionStatus();
    }
  }

  LeadStatus() {
    arr_ALL_Name_ID_For_LeadStatus.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Qualified";
      } else if (i == 1) {
        all_name_id.Name = "Disqualified";
      } else if (i == 2) {
        all_name_id.Name = "InProcess";
      }
      arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
    }
  }

  Widget LeadStatusDropDown() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        /* showcustomdialog(
            values: arr_ALL_Name_ID_For_Folowup_Status,
            context1: context,
            controller: edt_FollowupStatus,
            lable: "Select Status");*/
        // _expenseBloc.add(ExpenseTypeByNameCallEvent(ExpenseTypeAPIRequest(CompanyId: CompanyID.toString())));
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_LeadStatus,
            context1: context,
            controller: edt_LeadStatus,
            lable: "Select Lead Status");
      },
      child: Container(
        //margin: EdgeInsets.only(left: 5, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Lead Status",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ]),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                /*padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                width: double.maxFinite,*/
                height: 60,
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 5, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: /* Text(
                          SelectedStatus =="" ?
                          "Tap to select Status" : SelectedStatus.Name,
                          style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),*/

                          TextField(
                        controller: edt_LeadStatus,
                        enabled: false,
                        /*  onChanged: (value) => {
                      print("StatusValue " + value.toString() )
                  },*/
                        style: TextStyle(
                            color: Colors.black, // <-- Change this
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Select",
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: colorPrimary,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onALLEmplyeeList(ALL_EmployeeList_Response offlineALLEmployeeListData) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();
    arr_ALL_Name_ID_For_AssignTo.clear();
    if (offlineALLEmployeeListData.details != null) {
      for (var i = 0; i < offlineALLEmployeeListData.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = offlineALLEmployeeListData.details[i].employeeName;
        all_name_id.pkID = offlineALLEmployeeListData.details[i].pkID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
        arr_ALL_Name_ID_For_AssignTo.add(all_name_id);
      }
    }
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
            context1: context,
            controller: edt_EmployeeName,
            controllerID: edt_EmployeeID,
            lable: "Assign To");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Assign To ",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ]),
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
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: /* Text(
                        SelectedStatus =="" ?
                        "Tap to select Status" : SelectedStatus.Name,
                        style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),*/

                        TextField(
                      controller: edt_EmployeeName,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                      style: TextStyle(
                          color: Colors.black, // <-- Change this
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Select"),
                    ),
                    // dropdown()
                  ),
                  /*  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _OnFollowupSaveResponse(
      TeleCallerFollowupSaveResponseState state) async {
    String Msg = _isForUpdate == true
        ? "Followup Information. Updated Successfully"
        : "Followup Information. Added Successfully";

    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, TeleCallerListScreen.routeName, clearAllStack: true);
    });
  }
}
