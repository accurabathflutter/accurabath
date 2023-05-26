import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_followup_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_inquiry_by_customer_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_type_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/closer_reason_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/ACCURABATH/accurabath_complaint/accurabath_complaint_listing_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class AddUpdateAccuraBathFollowupInquiryScreenArguments {
  String ComplaintPkID;

  AddUpdateAccuraBathFollowupInquiryScreenArguments(this.ComplaintPkID);
}

class AccuraBathFollowUpFromComplaintAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/AccuraBathFollowUpFromComplaintAddEditScreen';
  final AddUpdateAccuraBathFollowupInquiryScreenArguments arguments;

  AccuraBathFollowUpFromComplaintAddEditScreen(this.arguments);

  @override
  _AccuraBathFollowUpFromComplaintAddEditScreenState createState() =>
      _AccuraBathFollowUpFromComplaintAddEditScreenState();
}

class _AccuraBathFollowUpFromComplaintAddEditScreenState
    extends BaseState<AccuraBathFollowUpFromComplaintAddEditScreen>
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
  FollowupBloc _FollowupBloc;
  int savepkID = 0;
  bool _isForUpdate = false;
  bool _isInqury_details_Exist;

  FilterDetails _editModel;
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

  bool _serviceEnabled;
  Position _currentPosition;
  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;

  bool is_LocationService_Permission;
  bool SaveSucess;
  bool is_Storage_Service_Permission;
  String _ComplaintPkID;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    // permission();
    // checkPhotoPermissionStatus();
    checkPermissionStatus();
    // _offlineFollowupTypeListResponseData = SharedPrefHelper.instance.getFollowupTypeListResponse();
    // _offlineInquiryLeadStatusData = SharedPrefHelper.instance.getInquiryLeadStatus();
    // _offlilineFollowupCloserReasonListData = SharedPrefHelper.instance.getFollowupCloserReason();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    _ComplaintPkID = widget.arguments.ComplaintPkID == null
        ? "0"
        : widget.arguments.ComplaintPkID;
    SaveSucess = false;
    _FollowupBloc = FollowupBloc(baseBloc);
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

    edt_PreferedTime.text = beforZeroHour + ":" + beforZerominute + " " + AM_PM;

    setState(() {});

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
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is FollowupInquiryNoListCallResponseState) {
            _onInquiryNoListTypeCallSuccess(state);
          }
          if (state is FollowupCustomerListByNameCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is FollowupCustomerListByNameCallResponseState ||
              currentState is FollowupInquiryStatusListCallResponseState ||
              currentState is FollowupInquiryNoListCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupInquiryByCustomerIdCallResponseState) {
            _onFollowupInquiryByCustomerIDCallSuccess(state);
          }
          if (state is AccuraBathComplaintFollowupSaveResponseState) {
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
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is FollowupInquiryByCustomerIdCallResponseState ||
              currentState is AccuraBathComplaintFollowupSaveResponseState ||
              currentState is FollowupImageDeleteCallResponseState ||
              currentState is FollowupUploadImageCallResponseState ||
              currentState is FollowupTypeListCallResponseState ||
              currentState is InquiryLeadStatusListCallResponseState ||
              currentState is CloserReasonListCallResponseState) {
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
          title: Text('Complaint FollowUp'),
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
                  navigateTo(context, AccurabathComplaintListScreen.routeName,
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
                        showcustomdialogWithID1("Followup Type",
                            enable1: false,
                            title: "Followup Type *",
                            hintTextvalue: "Tap to Select Followup Type",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_FollowupType,
                            controllerpkID: edt_FollowupTypepkID,
                            Custom_values1: arr_ALL_Name_ID_For_FolowupType),
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
                          visible: _isInqury_details_Exist,
                          child: is_closer_reasonVisible == true
                              ? showcustomdialogWithID1("Closer Reason",
                                  enable1: false,
                                  title: "Closer Reason",
                                  hintTextvalue: "Tap to Select Closer Reason",
                                  icon: Icon(Icons.arrow_drop_down),
                                  controllerForLeft: edt_CloserReasonStatusType,
                                  controllerpkID:
                                      edt_CloserReasonStatusTypepkID,
                                  Custom_values1:
                                      arr_ALL_Name_ID_For_CloserReasonStatusType)
                              : Container(),
                        ),
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
                                if (_selectedImageFile != null) {
                                  fileName =
                                      _selectedImageFile.path.split('/').last;
                                } else {
                                  fileName = GetImageNamefromEditMode;
                                }
                                print("ALLIDS" +
                                    "CustomerID : " +
                                    edt_CustomerpkID.text +
                                    " FollowupType_pkID : " +
                                    edt_FollowupTypepkID.text +
                                    " InquiryStatusID : " +
                                    edt_FollowupInquiryStatusTypepkID.text +
                                    " CloserReason_pkID : " +
                                    edt_CloserReasonStatusTypepkID.text);
                                String FollowupStatusIDs = "";
                                String FollowupPriorityDetails = "";

                                if (_offlineLoggedInData.details[0].serialKey
                                        .toLowerCase() ==
                                    "dol2-6uh7-ph03-in5h") {
                                  if (edt_Priority.text == "Hot") {
                                    FollowupPriorityDetails = "1";
                                  } else if (edt_Priority.text == "Cold") {
                                    FollowupPriorityDetails = "2";
                                  } else if (edt_Priority.text == "Warm") {
                                    FollowupPriorityDetails = "3";
                                  }
                                } else {
                                  if (edt_Priority.text == "High") {
                                    FollowupPriorityDetails = "1";
                                  } else if (edt_Priority.text == "Medium") {
                                    FollowupPriorityDetails = "2";
                                  } else if (edt_Priority.text == "Low") {
                                    FollowupPriorityDetails = "3";
                                  }
                                }

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
                                          AccuraBathComplaintFollowupSaveRequestEvent(
                                              0,
                                              context,
                                              Msg,
                                              AccuraBathComplaintFollowupSaveRequest(
                                                ComppkID:
                                                    _ComplaintPkID.toString(),
                                                FollowupDate:
                                                    edt_ReverseFollowUpDate
                                                        .text,
                                                CustomerID:
                                                    edt_CustomerpkID.text,
                                                MeetingNotes:
                                                    edt_FollowupNotes.text,
                                                NextFollowupDate:
                                                    edt_ReverseNextFollowupDate
                                                        .text,
                                                FollowupSource:
                                                    edt_FollowupType.text ==
                                                            "null"
                                                        ? ""
                                                        : edt_FollowupType.text,
                                                LoginUserID: LoginUserID,
                                                InquiryStatusID:
                                                    edt_FollowupInquiryStatusTypepkID
                                                                .text ==
                                                            "null"
                                                        ? ""
                                                        : edt_FollowupInquiryStatusTypepkID
                                                            .text,
                                                PreferredTime:
                                                    edt_PreferedTime.text,
                                                CompanyID: CompanyID.toString(),
                                              )));
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
                                            AccuraBathComplaintFollowupSaveRequestEvent(
                                                0,
                                                context,
                                                Msg,
                                                AccuraBathComplaintFollowupSaveRequest(
                                                  ComppkID:
                                                      _ComplaintPkID.toString(),
                                                  FollowupDate:
                                                      edt_ReverseFollowUpDate
                                                          .text,
                                                  CustomerID:
                                                      edt_CustomerpkID.text,
                                                  MeetingNotes:
                                                      edt_FollowupNotes.text,
                                                  NextFollowupDate:
                                                      edt_ReverseNextFollowupDate
                                                          .text,
                                                  FollowupSource:
                                                      edt_FollowupType.text ==
                                                              "null"
                                                          ? ""
                                                          : edt_FollowupType
                                                              .text,
                                                  LoginUserID: LoginUserID,
                                                  InquiryStatusID:
                                                      edt_FollowupInquiryStatusTypepkID
                                                                  .text ==
                                                              "null"
                                                          ? ""
                                                          : edt_FollowupInquiryStatusTypepkID
                                                              .text,
                                                  PreferredTime:
                                                      edt_PreferedTime.text,
                                                  CompanyID:
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
    navigateTo(context, AccurabathComplaintListScreen.routeName,
        clearAllStack: true);
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

  void _onInquiryListByNumberCallSuccess(
      FollowupCustomerListByNameCallResponseState state) {}

  void _onFollowupSaveCallSuccess(
      AccuraBathComplaintFollowupSaveResponseState state) async {
    // if( state.followupSaveResponse.details[0].column2==" state.followupSaveResponse.details[0].column2")
    print("FollowupSav123" +
        " Response : " +
        state.complaintFollowupSaveResponse.details[0].column2);

    String Msg = _isForUpdate == true
        ? "Followup Information. Updated Successfully"
        : "Followup Information. Added Successfully";
    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, AccurabathComplaintListScreen.routeName,
          clearAllStack: true);

      //Navigator.of(context).pop();
    });
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

  void _onInquiryNoListTypeCallSuccess(
      FollowupInquiryNoListCallResponseState state) {
    if (state.followupInquiryNoListResponse.details != null) {
      arr_ALL_Name_ID_For_InquiryNoListType.clear();
      for (var i = 0;
          i < state.followupInquiryNoListResponse.details.length;
          i++) {
        print("InquiryNoStatus : " +
            state.followupInquiryNoListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.followupInquiryNoListResponse.details[i].inquiryNo;
        all_name_id.Name1 = state
            .followupInquiryNoListResponse.details[i].inquiryStatus
            .toString();
        all_name_id.pkID =
            state.followupInquiryNoListResponse.details[i].inquiryStatusID;
        arr_ALL_Name_ID_For_InquiryNoListType.add(all_name_id);
      }
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
            onTap: () => CreateDialogDropdown(Category),
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

  void fillData() {
    if (_editModel.followupDate == "") {
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
    } else {
      edt_FollowUpDate.text = _editModel.followupDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseFollowUpDate.text = _editModel.followupDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }
    if (_editModel.nextFollowupDate == "") {
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
    } else {
      edt_NextFollowupDate.text = _editModel.nextFollowupDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseNextFollowupDate.text = _editModel.nextFollowupDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }

    if (_editModel.preferredTime == "") {
      TimeOfDay selectedTime = TimeOfDay.now();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_PreferedTime.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
    } else {
      edt_PreferedTime.text = _editModel.preferredTime;
    }

    if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
        "dol2-6uh7-ph03-in5h") {
      if (_editModel.followupPriority == 1) {
        edt_Priority.text = "Hot";
      } else if (_editModel.followupPriority == 2) {
        edt_Priority.text = "Cold";
      } else {
        edt_Priority.text = "Warm";
      }
    } else {
      if (_editModel.followupPriority == 1) {
        edt_Priority.text = "High";
      } else if (_editModel.followupPriority == 2) {
        edt_Priority.text = "Medium";
      } else {
        edt_Priority.text = "Low";
      }
    }

    edt_CustomerName.text = _editModel.customerName;
    edt_CustomerpkID.text = _editModel.customerID.toString();

    savepkID = _editModel.pkID.toInt();
    edt_InqNo.text = _editModel.inquiryNo;
    edt_FollowupInquiryStatusType.text = _editModel.inquiryStatusDesc;
    edt_FollowupInquiryStatusTypepkID.text =
        _editModel.inquiryStatusDescID.toString();

    print("InqExistt" + "INQNO : " + _editModel.inquiryNo);

    edt_FollowupNotes.text = _editModel.meetingNotes;

    edt_CloserReasonStatusTypepkID.text = _editModel.noFollClosureID.toString();
    edt_FollowupType.text = _editModel.inquiryStatus.toString();
    edt_FollowupTypepkID.text = _editModel.inquiryStatusID.toString();
    _rating = _editModel.rating.toDouble();
    if (_editModel.noFollowup == 0) {
      _isSwitched = false;
    } else {
      _isSwitched = true;
    }
    if (_editModel.FollowUpImage.isNotEmpty) {
      ImageURLFromListing =
          SiteURL + "followupimages/" + _editModel.FollowUpImage;
      print("ImageURLFromListing" +
          "ImageURLFromListing : " +
          ImageURLFromListing);
      GetImageNamefromEditMode = _editModel.FollowUpImage;
      print("ImageURLFromListing1235" +
          "ImageURLFromListing : " +
          GetImageNamefromEditMode);
    } else {
      ImageURLFromListing = "";
    }

    _FollowupBloc.add(
        FollowupInquiryByCustomerIDCallEvent(FollowerInquiryByCustomerIDRequest(
      CompanyId: CompanyID.toString(),
      CustomerID: edt_CustomerpkID.text,
    )));
  }

  void _onFollowupInquiryByCustomerIDCallSuccess(
      FollowupInquiryByCustomerIdCallResponseState state) {
    // edt_InqNo.text = "";
    _isForUpdate == true
        ? edt_FollowupInquiryStatusTypepkID.text
        : edt_FollowupInquiryStatusTypepkID.text = "";
    _isForUpdate == true
        ? edt_FollowupInquiryStatusType.text
        : edt_FollowupInquiryStatusType.text = "";

    _isInqury_details_Exist = false;

    if (state.followupInquiryByCustomerIDResponse.details != null) {
      arr_ALL_Name_ID_For_FolowupInquiryByCustomerID.clear();
      for (var i = 0;
          i < state.followupInquiryByCustomerIDResponse.details.length;
          i++) {
        print("InquiryStatus : " +
            state.followupInquiryByCustomerIDResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.followupInquiryByCustomerIDResponse.details[i].inquiryNo;
        all_name_id.Name1 =
            state.followupInquiryByCustomerIDResponse.details[i].inquiryStatus;
        all_name_id.pkID = state
            .followupInquiryByCustomerIDResponse.details[i].inquiryStatusID;
        arr_ALL_Name_ID_For_FolowupInquiryByCustomerID.add(all_name_id);
        _isInqury_details_Exist = true;
      }
    } else {
      arr_ALL_Name_ID_For_FolowupInquiryByCustomerID.clear();
      _isInqury_details_Exist = false;
    }

    setState(() {});
  }

  void isExistINQFromEDIT() {
    if (edt_InqNo.text != "") {
      _isInqury_details_Exist = true;
    } else {
      _isInqury_details_Exist = false;
    }
    setState(() {});
  }

  _OnDeleteFollowupImageResponseSucess(
      FollowupImageDeleteCallResponseState state) {
    print("ImageDeleteSucess" +
        state.followupDeleteImageResponse.details[0].column2.toString());
    _isForUpdate = false;
    setState(() {});
  }

  _OnFollowupImageUploadSucessResponse(
      FollowupUploadImageCallResponseState state) async {
    //print("ImageUploadSucess"+ state.followupImageUploadResponse.details[0].column1);

    String Msg = _isForUpdate == true
        ? "Followup Information. Updated Successfully"
        : "Followup Information. Added Successfully";
    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
    });
    // Navigator.of(context).pop();
  }

  CreateDialogDropdown(String category) {
    if (category == "Inquiry Status") {
      _FollowupBloc.add(InquiryLeadStatusTypeListByNameCallEvent(
          FollowupInquiryStatusTypeListRequest(
              CompanyId: CompanyID.toString(),
              pkID: "",
              StatusCategory: "Inquiry",
              LoginUserID: LoginUserID,
              SearchKey: "")));
    } else if (category == "Followup Type") {
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

  void _onLeadStatusListTypeCallSuccess(
      InquiryLeadStatusListCallResponseState state) {
    if (state.inquiryStatusListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_FolowupInquiryStatusType.clear();
      for (var i = 0; i < state.inquiryStatusListResponse.details.length; i++) {
        print("InquiryStatus : " +
            state.inquiryStatusListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.inquiryStatusListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.inquiryStatusListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_FolowupInquiryStatusType.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_FolowupInquiryStatusType,
          context1: context,
          controller: edt_FollowupInquiryStatusType,
          controllerID: edt_FollowupInquiryStatusTypepkID,
          lable: "Select Inquiry Status");
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
}
