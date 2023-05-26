import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/expense/expense_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/telecaller/telecaller_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/general_telecaller_img_upload_request/telecaller_upload_img_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/product/product_brand_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/tele_caller_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/telecaller_delete_image_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/telecaller_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_country_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/telecaller_add_edit/company_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/app_constants.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/image_full_screen.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:geolocator/geolocator.dart' as geolocator; // or whatever name you want
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

class AddUpdateTeleCallerScreenArguments {
  TeleCallerListDetails editModel;
  int PagNo;
  String LeadStatusFromList;
  AddUpdateTeleCallerScreenArguments(this.PagNo,this.LeadStatusFromList,this.editModel);
}

class TeleCallerAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/TeleCallerAddEditScreen';
  final AddUpdateTeleCallerScreenArguments arguments;

  TeleCallerAddEditScreen(this.arguments);

  @override
  _TeleCallerAddEditScreenState createState() =>
      _TeleCallerAddEditScreenState();
}

class _TeleCallerAddEditScreenState extends BaseState<TeleCallerAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController edt_ExpenseDateController =
      TextEditingController();
  final TextEditingController edt_ReverseExpenseDateController =
      TextEditingController();

  final TextEditingController edt_ExpenseNotes = TextEditingController();

  final TextEditingController edt_ExpenseType = TextEditingController();
  final TextEditingController edt_ExpenseTypepkID = TextEditingController();
  final TextEditingController edt_ExpenseAmount = TextEditingController();
  final TextEditingController edt_FromLocation = TextEditingController();
  final TextEditingController edt_ToLocation = TextEditingController();

  final TextEditingController edt_LeadNo = TextEditingController();
  final TextEditingController edt_LeadSource = TextEditingController();
  final TextEditingController edt_ForProduct = TextEditingController();
  final TextEditingController edt_Details = TextEditingController();
  final TextEditingController edt_SenderName = TextEditingController();
  final TextEditingController edt_CompanyName = TextEditingController();
  final TextEditingController edt_Email = TextEditingController();
  final TextEditingController edt_Brand = TextEditingController();

  final TextEditingController edt_Address = TextEditingController();

  final TextEditingController edt_CountryHeader = TextEditingController();
  final TextEditingController edt_StateHeader = TextEditingController();
  final TextEditingController edt_CityHeader = TextEditingController();
  final TextEditingController edt_PinHeader = TextEditingController();
  final TextEditingController edt_PrimaryContact = TextEditingController();
  final TextEditingController edt_AlternateContact = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();
  final TextEditingController edt_QualifiedForProduct = TextEditingController();
  final TextEditingController edt_QualifiedForProductID =
      TextEditingController();

  final TextEditingController edt_QualifiedCountry = TextEditingController();
  final TextEditingController edt_QualifiedCountryCode =
      TextEditingController();

  final TextEditingController edt_QualifiedState = TextEditingController();
  final TextEditingController edt_QualifiedStateCode = TextEditingController();

  final TextEditingController edt_QualifiedCity = TextEditingController();
  final TextEditingController edt_QualifiedCityCode = TextEditingController();

  final TextEditingController edt_QualifiedPinCode = TextEditingController();

  final TextEditingController edt_QualifiedEmplyeeName =
      TextEditingController();
  final TextEditingController edt_QualifiedEmplyeeID = TextEditingController();
  final TextEditingController edt_DisQualifiedName = TextEditingController();
  final TextEditingController edt_DisQualifiedID = TextEditingController();
  final TextEditingController edt_DisqualifiedRemarks = TextEditingController();
  final TextEditingController edt_FollowupNotes = TextEditingController();
  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_ReverseNextFollowupDate = TextEditingController();

  final TextEditingController edt_Cust_ID_OF_CompanyName = TextEditingController();

  final TextEditingController edt_PreferedTime = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  //

  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeaveType = [];

  DateTime selectedDate = DateTime.now();
  TeleCallerBloc _expenseBloc;
  int savepkID = 0;
  int LeadID = 0;
  bool _isForUpdate;
  int ExpensepkID = 0;

  TeleCallerListDetails _editModel;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  //ExpenseTypeResponse _offlineExpenseType;

  int CompanyID = 0;
  String LoginUserID = "";

  DateTime FromDate = DateTime.now();
  DateTime ToDate = DateTime.now();
  bool is_visibleLocation;

  List<ALL_Name_ID> arr_ImageList = [];
  String fileName = "";

  String SiteURL = "";
  String ImageURLFromListing = "";
  String GetImageNamefromEditMode = "";
  FocusNode AmountFocusNode, FromLocationFocusNode;

  double CardViewHeight = 45.00;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  FollowerEmployeeListResponse _offlineALLEmployeeListData;
  List<ALL_Name_ID> arr_All_Employee_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Country = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_State = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_City = [];
  List<ALL_Name_ID> _listFilteredCountry = [];
  List<ALL_Name_ID> _listFilteredState = [];
  List<ALL_Name_ID> _listFilteredCity = [];
  List<ALL_Name_ID> arr_All_DisQualifiedList = [];

  bool isqualified = false;
  bool isDisqualified = false;
  bool isInProcess = false;
  SearchCountryDetails _searchDetails;
  SearchCountryDetails _searchDetails123;

  ProductSearchDetails _productSearchDetails;

  SearchStateDetails _searchStateDetails;
  SearchCityDetails _searchCityDetails;

  bool isViewSaveButton = false;
  bool isAllEditable = false;

  File _selectedImageFile;
  String Address;
  String Latitude;
  String Longitude;
  Location location = new Location();
  bool _serviceEnabled;
  LocationData _locationData;
  bool is_LocationService_Permission;
  Position _currentPosition;
  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;

  bool isImageDeleted=false;

  String SerialKey = "";

  bool isforbluechem =false;

  String MapAPIKey="";
  String ReportToToken = "";

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Brand = [];


  bool IsManageOpertunity = false;
  bool IsBasicDetails = false;
  bool IsLeadStatusDetails = false;


  @override
  void initState() {
    super.initState();
    edt_Cust_ID_OF_CompanyName.text ="";
    _expenseBloc = TeleCallerBloc(baseBloc);
    AmountFocusNode = FocusNode();
    FromLocationFocusNode = FocusNode();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    SerialKey = _offlineLoggedInData.details[0].serialKey;
    MapAPIKey = _offlineCompanyData.details[0].MapApiKey;
    if(SerialKey.toUpperCase()=="BLUE-CHEM-56JK-BC88")
      {
        isforbluechem = true;
      }
    else
      {
        isforbluechem = false;

      }

    print("SiteeURL"+SerialKey + " UpperCase : " + SerialKey.toUpperCase() + isforbluechem.toString());


    LeadStatus();
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(_offlineALLEmployeeListData);
    //_offlineExpenseType = SharedPrefHelper.instance.getExpenseType();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    //_onLeaveRequestTypeSuccessResponse(_offlineExpenseType);
    edt_ExpenseDateController.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();

    edt_ReverseExpenseDateController.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();


    TimeOfDay selectedTime1234 = TimeOfDay.now();
    String AM_PM123 =
    selectedTime1234.periodOffset.toString() == "12" ? "PM" : "AM";
    String beforZeroHour123 = selectedTime1234.hourOfPeriod <= 9
        ? "0" + selectedTime1234.hourOfPeriod.toString()
        : selectedTime1234.hourOfPeriod.toString();
    String beforZerominute123 = selectedTime1234.minute <= 9
        ? "0" + selectedTime1234.minute.toString()
        : selectedTime1234.minute.toString();
    edt_PreferedTime.text =
        beforZeroHour123 + ":" + beforZerominute123 + " " + AM_PM123;

    /*
    final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_ReverseNextFollowupDate = TextEditingController();

  final TextEditingController edt_PreferedTime = TextEditingController();
    */

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

    _expenseBloc.add(GetReportToTokenRequestEvent(GetReportToTokenRequest(
        CompanyId: CompanyID.toString(),
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString())));


    _isForUpdate = widget.arguments != null;
    edt_ExpenseType.addListener(() {
      if (edt_ExpenseType.text == "Petrol") {
        FromLocationFocusNode.requestFocus();
      } else {
        AmountFocusNode.requestFocus();
      }
    });

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData(_editModel);

    } else {
      _searchStateDetails = SearchStateDetails();
      edt_Cust_ID_OF_CompanyName.text ="";
      edt_QualifiedCountry.text = "India";
      edt_QualifiedCountryCode.text = "IND";
      _searchStateDetails.value = _offlineLoggedInData.details[0].stateCode;
      edt_QualifiedState.text = _offlineLoggedInData.details[0].StateName;
      edt_QualifiedStateCode.text =
          _offlineLoggedInData.details[0].stateCode.toString();

      edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
      edt_QualifiedCityCode.text =
          _offlineLoggedInData.details[0].CityCode.toString();

      isAllEditable = true;
      isViewSaveButton = true;
      setState(() {});
    }

    is_visibleLocation = false;
    edt_ExpenseType.addListener(() {
      if (edt_ExpenseType.text == "Petrol") {
        is_visibleLocation = true;
      } else {
        is_visibleLocation = false;
      }
      setState(() {});
    });

    edt_LeadStatus.addListener(() {
      if (edt_LeadStatus.text == "Qualified") {
        isqualified = true;
        isDisqualified = false;
        isInProcess = false;
        edt_QualifiedEmplyeeName.text = "";
        edt_QualifiedEmplyeeID.text = "";
      } else if (edt_LeadStatus.text == "Disqualified") {
        //isqualified = "Disqualified";
        isDisqualified = true;
        isqualified = false;
        isInProcess = false;
        edt_QualifiedEmplyeeName.text = "";
        edt_QualifiedEmplyeeID.text = "";
      } else if (edt_LeadStatus.text == "InProcess") {
        // isqualified = "In-Process";
        isInProcess = true;
        isqualified = false;
        isDisqualified = false;
        edt_QualifiedEmplyeeName.text = "";
        edt_QualifiedEmplyeeID.text = "";
      }
      setState(() {});
    });

    /*   List lst123 = "Expense Added Successfully !10047".split("!");
    String RetrunPkID = lst123[1].toString();
    print("SaveReturnPKID : " + RetrunPkID);
*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _expenseBloc,
      /*..add(ExpenseTypeByNameCallEvent(
            ExpenseTypeAPIRequest(CompanyId: CompanyID.toString()))),*/
      /* ..add(FollowupTypeListByNameCallEvent(FollowupTypeListRequest(
            CompanyId: "8033", pkID: "", StatusCategory: "FollowUp"))),*/

      child: BlocConsumer<TeleCallerBloc, TeleCallerStates>(
        builder: (BuildContext context, TeleCallerStates state) {
          /*  if(state is LeaveRequestTypeResponseState)
          {
            _onLeaveRequestTypeSuccessResponse(state);
          }
          if(state is LeaveRequestEmployeeListResponseState)
          {
            _onFollowerEmployeeListByStatusCallSuccess(state);
          }*/

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
        listener: (BuildContext context, TeleCallerStates state) {
          if (state is CountryListEventResponseState) {
            _onCountryListSuccess(state);
          }
          if (state is StateListEventResponseState) {
            _onStateListSuccess(state);
          }

          if (state is CityListEventResponseState) {
            _onCityListSuccess(state);
          }
          if (state is CustomerSourceCallEventResponseState) {
            _onDisQualifiedResonResult(state);
          }
          if (state is ExternalLeadSaveResponseState) {
            _onExternalLeadSucessResponse(state);
          }
          if (state is TeleCallerUploadImgApiResponseState) {
            _OnUploadImageSucess(state);
          }
          if(state is TeleCallerImageDeleteResponseState)
            {
              _OnDeleteTeleCallerImageResponseSucess(state);
            }

          if (state is FCMNotificationResponseState) {
            _onRecevedNotification(state);
          }
          if (state is ProductBrandResponseState) {
            _onBrandListResponse(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is CountryListEventResponseState ||
              currentState is StateListEventResponseState ||
              currentState is CityListEventResponseState ||
              currentState is CustomerSourceCallEventResponseState ||
              currentState is ExternalLeadSaveResponseState ||
              currentState is TeleCallerUploadImgApiResponseState ||
              currentState is TeleCallerImageDeleteResponseState ||
              currentState is FCMNotificationResponseState ||
              currentState is ProductBrandResponseState

          ) {
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
        backgroundColor: colorTileBG,
        appBar: NewGradientAppBar(
          title: Text('TeleCaller Details'),
          gradient:
              LinearGradient(colors: [
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




                        Card(
                            elevation: 20,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      IsManageOpertunity = !IsManageOpertunity;
                                      IsBasicDetails=false;
                                      IsLeadStatusDetails=false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),

                                    child: Row(
                                      children: [
                                        Text("Manage Opportunities ",     style: TextStyle(
                                            fontSize: 15,
                                            color: colorPrimary,
                                            fontWeight: FontWeight
                                                .bold)),
                                        Spacer(),
                                        IsManageOpertunity==true?
                                        Icon(Icons.arrow_circle_up_rounded,color: colorPrimary):
                                        Icon(Icons.arrow_circle_down_rounded,color: colorPrimary,)
                                      ],
                                    ),
                                  ),
                                ),


                                Visibility(
                                  visible: IsManageOpertunity,
                                  child: ManageOpportunities(),
                                ),

                              ],
                            )



                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Card(
                            elevation: 20,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      IsBasicDetails = !IsBasicDetails;
                                      IsManageOpertunity=false;
                                      IsLeadStatusDetails=false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),

                                    child: Row(
                                      children: [
                                        Text("Basic Details",     style: TextStyle(
                                            fontSize: 15,
                                            color: colorPrimary,
                                            fontWeight: FontWeight
                                                .bold)),
                                        Spacer(),
                                        IsBasicDetails==true?
                                        Icon(Icons.arrow_circle_up_rounded,color: colorPrimary):
                                        Icon(Icons.arrow_circle_down_rounded,color: colorPrimary,)
                                      ],
                                    ),
                                  ),
                                ),


                                Visibility(
                                  visible: IsBasicDetails,
                                  child: BasicDetails(),
                                ),

                              ],
                            )



                        ),


                        SizedBox(
                          height: 20,
                        ),

                        Card(
                            elevation: 20,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      /*IsBasicDetails = !IsBasicDetails;
                                      IsManageOpertunity=false;
                                      IsLeadStatusDetails=false;*/


                                      IsLeadStatusDetails = !IsLeadStatusDetails;
                                      IsBasicDetails=false;
                                      IsManageOpertunity=false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),

                                    child: Row(
                                      children: [
                                        Text("Lead Status",     style: TextStyle(
                                            fontSize: 15,
                                            color: colorPrimary,
                                            fontWeight: FontWeight
                                                .bold)),
                                        Spacer(),
                                        IsLeadStatusDetails==true?
                                        Icon(Icons.arrow_circle_up_rounded,color: colorPrimary):
                                        Icon(Icons.arrow_circle_down_rounded,color: colorPrimary,)
                                      ],
                                    ),
                                  ),
                                ),


                                Visibility(
                                  visible: IsLeadStatusDetails,
                                  child: LeadStatusDetails(),
                                ),

                              ],
                            )



                        ),
                        SizedBox(
                          height: 20,
                        ),

                       /* uploadImage(context),
                        SizedBox(
                          height: 20,
                        ),*/






                        Visibility(
                          visible: isViewSaveButton,
                          child: InkWell(
                            onTap: () async {
                              if (_selectedImageFile != null) {
                                fileName = _selectedImageFile.path.split('/').last;
                              }
                              else
                              {
                                fileName = GetImageNamefromEditMode;
                              }

                              if(isImageDeleted==true)
                              {
                                fileName = "";
                              }

                              if(isforbluechem==true)
                              {
                                if (edt_QualifiedForProduct.text != "")
                                {
                                  if (edt_Details.text != "") {
                                    if (edt_SenderName.text != "") {
                                      if (edt_CompanyName.text != "") {
                                        if (edt_PrimaryContact.text != "") {
                                          if (edt_LeadStatus.text != "") {
                                            if (isqualified == true) {
                                              if (edt_QualifiedEmplyeeName
                                                  .text !=
                                                  "") {
                                                if (edt_QualifiedForProduct
                                                    .text !=
                                                    "") {
                                                  if (edt_QualifiedState.text !=
                                                      "") {
                                                    if (edt_QualifiedCity
                                                        .text !=
                                                        "") {
                                                      showCommonDialogWithTwoOptions(
                                                          context,
                                                          "Are you sure you want to Save TeleCaller Details ?",
                                                          negativeButtonTitle:
                                                          "No",
                                                          positiveButtonTitle:
                                                          "Yes",
                                                          onTapOfPositiveButton:
                                                              () {
                                                            Navigator.of(context)
                                                                .pop();
                                                            _expenseBloc.add(
                                                                TeleCallerSaveCallEvent(
                                                                    context,
                                                                    savepkID,
                                                                    TeleCallerSaveRequest(
                                                                        LeadID: edt_LeadNo
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_LeadNo
                                                                            .text,
                                                                        SenderName: edt_SenderName
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_SenderName
                                                                            .text,
                                                                        QueryDatetime: edt_ReverseExpenseDateController
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_ReverseExpenseDateController
                                                                            .text,
                                                                        CompanyName: edt_CompanyName
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_CompanyName
                                                                            .text,
                                                                        SenderMail: edt_Email
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_Email
                                                                            .text,
                                                                        CountryFlagURL:
                                                                        "",
                                                                        Message: edt_Details
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_Details
                                                                            .text,
                                                                        Address: edt_Address
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_Address
                                                                            .text,
                                                                        City: _offlineLoggedInData.details[0].CityName,
                                                                        State: _offlineLoggedInData.details[0].StateName,
                                                                        Country: "India",
                                                                        CountryISO:
                                                                        "",
                                                                        PrimaryMobileNo: edt_PrimaryContact
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_PrimaryContact
                                                                            .text,
                                                                        SecondaryMobileNo: edt_AlternateContact
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_AlternateContact
                                                                            .text,
                                                                        ForProduct: edt_QualifiedForProduct
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedForProduct
                                                                            .text,
                                                                        LeadSource:
                                                                        "TeleCaller",
                                                                        LeadStatus: edt_LeadStatus
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_LeadStatus
                                                                            .text,
                                                                        EmployeeID: edt_QualifiedEmplyeeID
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedEmplyeeID
                                                                            .text,
                                                                        ACID: "",
                                                                        ProductID: edt_QualifiedForProductID
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedForProductID
                                                                            .text,
                                                                        Pincode: edt_QualifiedPinCode
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedPinCode
                                                                            .text,
                                                                        StateCode: _offlineLoggedInData.details[0].stateCode.toString(),
                                                                        CityCode: _offlineLoggedInData.details[0].CityCode.toString(),
                                                                        CountryCode: "IND",
                                                                        CustomerID:edt_Cust_ID_OF_CompanyName.text ,
                                                                        ExLeadClosure: edt_DisQualifiedID
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_DisQualifiedID
                                                                            .text,
                                                                        LoginUserID:
                                                                        LoginUserID,
                                                                        FollowupNotes:
                                                                        edt_FollowupNotes.text,
                                                                        FollowupDate:
                                                                        edt_ReverseNextFollowupDate.text,
                                                                        PreferredTime:
                                                                        edt_PreferedTime.text,
                                                                        SerialKey: "",
                                                                        DisqualifedRemarks: edt_DisqualifiedRemarks
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_DisqualifiedRemarks
                                                                            .text,
                                                                        CompanyId:
                                                                        CompanyID
                                                                            .toString(),
                                                                        Latitude:
                                                                        SharedPrefHelper.instance.getLatitude().toString(),
                                                                        Longitude:
                                                                        SharedPrefHelper.instance.getLongitude().toString(),
                                                                        Image: fileName,
                                                                        Brand: edt_Brand.text.toString()
                                                                    )));
                                                          });
                                                    } else {
                                                      showCommonDialogWithSingleOption(
                                                          context,
                                                          "Qualified City is required!",
                                                          positiveButtonTitle:
                                                          "OK",
                                                          onTapOfPositiveButton:
                                                              () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          });
                                                    }
                                                  } else {
                                                    showCommonDialogWithSingleOption(
                                                        context,
                                                        "Qualified State is required!",
                                                        positiveButtonTitle:
                                                        "OK",
                                                        onTapOfPositiveButton:
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                  }
                                                } else {
                                                  showCommonDialogWithSingleOption(
                                                      context,
                                                      "Qualified ProductName  is required!",
                                                      positiveButtonTitle: "OK",
                                                      onTapOfPositiveButton:
                                                          () {
                                                        Navigator.of(context).pop();
                                                      });
                                                }
                                              } else {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "AssignTo is required!",
                                                    positiveButtonTitle: "OK",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                    });
                                              }
                                            }
                                            else if (isDisqualified == true) {
                                              if (edt_DisQualifiedName.text !=
                                                  "") {
                                                showCommonDialogWithTwoOptions(
                                                    context,
                                                    "Are you sure you want to Save TeleCaller Details ?",
                                                    negativeButtonTitle: "No",
                                                    positiveButtonTitle: "Yes",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                      _expenseBloc.add(
                                                          TeleCallerSaveCallEvent(context,
                                                              savepkID,
                                                              TeleCallerSaveRequest(
                                                                  LeadID: edt_LeadNo
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadNo
                                                                      .text,
                                                                  SenderName: edt_SenderName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_SenderName
                                                                      .text,
                                                                  QueryDatetime:
                                                                  edt_ReverseExpenseDateController
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_ReverseExpenseDateController
                                                                      .text,
                                                                  CompanyName: edt_CompanyName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_CompanyName
                                                                      .text,
                                                                  SenderMail:
                                                                  edt_Email.text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Email
                                                                      .text,
                                                                  CountryFlagURL: "",
                                                                  Message: edt_Details
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Details
                                                                      .text,
                                                                  Address: edt_Address
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Address
                                                                      .text,
                                                                  City: _offlineLoggedInData.details[0].CityName,
                                                                  State: _offlineLoggedInData.details[0].StateName,
                                                                  Country: "India",
                                                                  CountryISO: "",
                                                                  PrimaryMobileNo:
                                                                  edt_PrimaryContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_PrimaryContact
                                                                      .text,
                                                                  SecondaryMobileNo:
                                                                  edt_AlternateContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_AlternateContact
                                                                      .text,
                                                                  ForProduct: edt_QualifiedForProduct
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProduct
                                                                      .text,
                                                                  LeadSource:
                                                                  "TeleCaller",
                                                                  LeadStatus: edt_LeadStatus
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadStatus
                                                                      .text,
                                                                  EmployeeID: edt_QualifiedEmplyeeID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedEmplyeeID
                                                                      .text,
                                                                  ACID: "",
                                                                  ProductID: edt_QualifiedForProductID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProductID
                                                                      .text,
                                                                  Pincode: edt_QualifiedPinCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedPinCode
                                                                      .text,
                                                                  StateCode: _offlineLoggedInData.details[0].stateCode.toString(),
                                                                  CityCode: _offlineLoggedInData.details[0].CityCode.toString(),
                                                                  CountryCode: "IND",
                                                                  CustomerID: edt_Cust_ID_OF_CompanyName.text,
                                                                  ExLeadClosure:
                                                                  edt_DisQualifiedID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisQualifiedID
                                                                      .text,
                                                                  LoginUserID:
                                                                  LoginUserID,
                                                                  FollowupNotes: "",
                                                                  FollowupDate: "",
                                                                  PreferredTime: "",
                                                                  SerialKey: "",
                                                                  DisqualifedRemarks:
                                                                  edt_DisqualifiedRemarks
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisqualifiedRemarks
                                                                      .text,
                                                                  CompanyId: CompanyID
                                                                      .toString(),
                                                                  Latitude:
                                                                  SharedPrefHelper.instance.getLatitude().toString(),
                                                                  Longitude:
                                                                  SharedPrefHelper.instance.getLongitude().toString(),
                                                                  Image: fileName,
                                                                  Brand: edt_Brand.text.toString()

                                                              )));
                                                    });
                                              } else {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "DisQualified Reason is required!",
                                                    positiveButtonTitle: "OK",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                    });
                                              }
                                            }
                                            else if (isInProcess == true) {
                                              if (edt_QualifiedEmplyeeName
                                                  .text !=
                                                  "") {
                                                showCommonDialogWithTwoOptions(
                                                    context,
                                                    "Are you sure you want to Save TeleCaller Details ?",
                                                    negativeButtonTitle: "No",
                                                    positiveButtonTitle: "Yes",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                      _expenseBloc.add(
                                                          TeleCallerSaveCallEvent(context,
                                                              savepkID,
                                                              TeleCallerSaveRequest(
                                                                  LeadID: edt_LeadNo
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadNo
                                                                      .text,
                                                                  SenderName: edt_SenderName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_SenderName
                                                                      .text,
                                                                  QueryDatetime:
                                                                  edt_ReverseExpenseDateController
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_ReverseExpenseDateController
                                                                      .text,
                                                                  CompanyName: edt_CompanyName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_CompanyName
                                                                      .text,
                                                                  SenderMail:
                                                                  edt_Email.text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Email
                                                                      .text,
                                                                  CountryFlagURL: "",
                                                                  Message: edt_Details
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Details
                                                                      .text,
                                                                  Address: edt_Address
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Address
                                                                      .text,
                                                                  City: _offlineLoggedInData.details[0].CityName,
                                                                  State: _offlineLoggedInData.details[0].StateName,
                                                                  Country: "India",
                                                                  CountryISO: "",
                                                                  PrimaryMobileNo:
                                                                  edt_PrimaryContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_PrimaryContact
                                                                      .text,
                                                                  SecondaryMobileNo:
                                                                  edt_AlternateContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_AlternateContact
                                                                      .text,
                                                                  ForProduct: edt_QualifiedForProduct
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProduct
                                                                      .text,
                                                                  LeadSource:
                                                                  "TeleCaller",
                                                                  LeadStatus: edt_LeadStatus
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadStatus
                                                                      .text,
                                                                  EmployeeID: edt_QualifiedEmplyeeID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedEmplyeeID
                                                                      .text,
                                                                  ACID: "",
                                                                  ProductID: edt_QualifiedForProductID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProductID
                                                                      .text,
                                                                  Pincode: edt_QualifiedPinCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedPinCode
                                                                      .text,
                                                                  StateCode: _offlineLoggedInData.details[0].stateCode.toString(),
                                                                  CityCode: _offlineLoggedInData.details[0].CityCode.toString(),
                                                                  CountryCode: "IND",
                                                                  CustomerID: edt_Cust_ID_OF_CompanyName.text,
                                                                  ExLeadClosure:
                                                                  edt_DisQualifiedID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisQualifiedID
                                                                      .text,
                                                                  LoginUserID:
                                                                  LoginUserID,
                                                                  FollowupNotes: edt_FollowupNotes.text,
                                                                  FollowupDate: edt_ReverseNextFollowupDate.text,
                                                                  PreferredTime: edt_PreferedTime.text.toString(),
                                                                  SerialKey: "",
                                                                  DisqualifedRemarks:
                                                                  edt_DisqualifiedRemarks
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisqualifiedRemarks
                                                                      .text,
                                                                  CompanyId: CompanyID
                                                                      .toString(),
                                                                  Latitude:
                                                                  SharedPrefHelper.instance.getLatitude().toString(),
                                                                  Longitude:
                                                                  SharedPrefHelper.instance.getLongitude().toString(),
                                                                  Image: fileName,
                                                                  Brand: edt_Brand.text.toString()

                                                              )));
                                                    });
                                              } else {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "Assign To is required!",
                                                    positiveButtonTitle: "OK",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                    });
                                              }
                                            } else {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  "Lead Status is required!",
                                                  positiveButtonTitle: "OK",
                                                  onTapOfPositiveButton: () {
                                                    Navigator.of(context).pop();
                                                  });
                                            }
                                          } else {
                                            showCommonDialogWithSingleOption(
                                                context,
                                                "Lead Status is required!",
                                                positiveButtonTitle: "OK",
                                                onTapOfPositiveButton: () {
                                                  Navigator.of(context).pop();
                                                });
                                          }
                                        } else {
                                          showCommonDialogWithSingleOption(
                                              context,
                                              "Primary Contact is required!",
                                              positiveButtonTitle: "OK",
                                              onTapOfPositiveButton: () {
                                                Navigator.of(context).pop();
                                              });
                                        }
                                      } else {
                                        showCommonDialogWithSingleOption(
                                            context,
                                            "Company Name is required!",
                                            positiveButtonTitle: "OK",
                                            onTapOfPositiveButton: () {
                                              Navigator.of(context).pop();
                                            });
                                      }
                                    } else {
                                      showCommonDialogWithSingleOption(context,
                                          "Contact Person is required!",
                                          positiveButtonTitle: "OK",
                                          onTapOfPositiveButton: () {
                                            Navigator.of(context).pop();
                                          });
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Details are required!",
                                        positiveButtonTitle: "OK",
                                        onTapOfPositiveButton: () {
                                          Navigator.of(context).pop();
                                        });
                                  }
                                }
                                else
                                {
                                  showCommonDialogWithSingleOption(
                                      context, "Product is required!",
                                      positiveButtonTitle: "OK",
                                      onTapOfPositiveButton: () {
                                        Navigator.of(context).pop();
                                      });
                                }
                              }
                              else
                              {
                                if (edt_QualifiedForProduct.text != "")
                                {
                                  if (edt_Details.text != "") {
                                    if (edt_SenderName.text != "") {
                                      if (edt_CompanyName.text != "") {
                                        if (edt_PrimaryContact.text != "") {
                                          if (edt_LeadStatus.text != "") {
                                            if (isqualified == true) {
                                              if (edt_QualifiedEmplyeeName
                                                  .text !=
                                                  "") {
                                                if (edt_QualifiedForProduct
                                                    .text !=
                                                    "") {
                                                  if (edt_QualifiedState.text !=
                                                      "") {
                                                    if (edt_QualifiedCity
                                                        .text !=
                                                        "") {
                                                      showCommonDialogWithTwoOptions(
                                                          context,
                                                          "Are you sure you want to Save TeleCaller Details ?",
                                                          negativeButtonTitle:
                                                          "No",
                                                          positiveButtonTitle:
                                                          "Yes",
                                                          onTapOfPositiveButton:
                                                              () {
                                                            Navigator.of(context)
                                                                .pop();
                                                            _expenseBloc.add(
                                                                TeleCallerSaveCallEvent(context,
                                                                    savepkID,
                                                                    TeleCallerSaveRequest(
                                                                        LeadID: edt_LeadNo
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_LeadNo
                                                                            .text,
                                                                        SenderName: edt_SenderName
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_SenderName
                                                                            .text,
                                                                        QueryDatetime: edt_ReverseExpenseDateController
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_ReverseExpenseDateController
                                                                            .text,
                                                                        CompanyName: edt_CompanyName
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_CompanyName
                                                                            .text,
                                                                        SenderMail: edt_Email
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_Email
                                                                            .text,
                                                                        CountryFlagURL:
                                                                        "",
                                                                        Message: edt_Details
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_Details
                                                                            .text,
                                                                        Address: edt_Address
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_Address
                                                                            .text,
                                                                        City: edt_QualifiedCity
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedCity
                                                                            .text,
                                                                        State: edt_QualifiedState
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedState
                                                                            .text,
                                                                        Country: edt_QualifiedCountry
                                                                            .text ==
                                                                            null
                                                                            ? "India"
                                                                            : edt_QualifiedCountry
                                                                            .text,
                                                                        CountryISO:
                                                                        "",
                                                                        PrimaryMobileNo: edt_PrimaryContact
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_PrimaryContact
                                                                            .text,
                                                                        SecondaryMobileNo: edt_AlternateContact
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_AlternateContact
                                                                            .text,
                                                                        ForProduct: edt_QualifiedForProduct
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedForProduct
                                                                            .text,
                                                                        LeadSource:
                                                                        "TeleCaller",
                                                                        LeadStatus: edt_LeadStatus
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_LeadStatus
                                                                            .text,
                                                                        EmployeeID: edt_QualifiedEmplyeeID
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedEmplyeeID
                                                                            .text,
                                                                        ACID: "",
                                                                        ProductID: edt_QualifiedForProductID
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedForProductID
                                                                            .text,
                                                                        Pincode: edt_QualifiedPinCode
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedPinCode
                                                                            .text,
                                                                        StateCode: edt_QualifiedStateCode
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedStateCode
                                                                            .text,
                                                                        CityCode: edt_QualifiedCityCode
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedCityCode
                                                                            .text,
                                                                        CountryCode: edt_QualifiedCountryCode
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_QualifiedCountryCode
                                                                            .text,
                                                                        CustomerID:
                                                                        edt_Cust_ID_OF_CompanyName.text,
                                                                        ExLeadClosure: edt_DisQualifiedID
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_DisQualifiedID
                                                                            .text,
                                                                        LoginUserID:
                                                                        LoginUserID,
                                                                        FollowupNotes:
                                                                        edt_FollowupNotes.text.toString(),
                                                                        FollowupDate:
                                                                        edt_ReverseNextFollowupDate.text.toString(),
                                                                        PreferredTime:
                                                                        edt_PreferedTime.text.toString(),
                                                                        SerialKey: "",
                                                                        DisqualifedRemarks: edt_DisqualifiedRemarks
                                                                            .text ==
                                                                            null
                                                                            ? ""
                                                                            : edt_DisqualifiedRemarks
                                                                            .text,
                                                                        CompanyId:
                                                                        CompanyID
                                                                            .toString(),
                                                                        Latitude:
                                                                        SharedPrefHelper.instance.getLatitude().toString(),
                                                                        Longitude:
                                                                        SharedPrefHelper.instance.getLongitude().toString(),
                                                                        Image: fileName,
                                                                        Brand: edt_Brand.text.toString()

                                                                    )));
                                                          });
                                                    } else {
                                                      showCommonDialogWithSingleOption(
                                                          context,
                                                          "Qualified City is required!",
                                                          positiveButtonTitle:
                                                          "OK",
                                                          onTapOfPositiveButton:
                                                              () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          });
                                                    }
                                                  } else {
                                                    showCommonDialogWithSingleOption(
                                                        context,
                                                        "Qualified State is required!",
                                                        positiveButtonTitle:
                                                        "OK",
                                                        onTapOfPositiveButton:
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                  }
                                                } else {
                                                  showCommonDialogWithSingleOption(
                                                      context,
                                                      "Qualified ProductName  is required!",
                                                      positiveButtonTitle: "OK",
                                                      onTapOfPositiveButton:
                                                          () {
                                                        Navigator.of(context).pop();
                                                      });
                                                }
                                              } else {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "AssignTo is required!",
                                                    positiveButtonTitle: "OK",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                    });
                                              }
                                            } else if (isDisqualified == true) {
                                              if (edt_DisQualifiedName.text !=
                                                  "") {
                                                showCommonDialogWithTwoOptions(
                                                    context,
                                                    "Are you sure you want to Save TeleCaller Details ?",
                                                    negativeButtonTitle: "No",
                                                    positiveButtonTitle: "Yes",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                      _expenseBloc.add(
                                                          TeleCallerSaveCallEvent(context,
                                                              savepkID,
                                                              TeleCallerSaveRequest(
                                                                  LeadID: edt_LeadNo
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadNo
                                                                      .text,
                                                                  SenderName: edt_SenderName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_SenderName
                                                                      .text,
                                                                  QueryDatetime:
                                                                  edt_ReverseExpenseDateController
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_ReverseExpenseDateController
                                                                      .text,
                                                                  CompanyName: edt_CompanyName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_CompanyName
                                                                      .text,
                                                                  SenderMail:
                                                                  edt_Email.text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Email
                                                                      .text,
                                                                  CountryFlagURL: "",
                                                                  Message: edt_Details
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Details
                                                                      .text,
                                                                  Address: edt_Address
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Address
                                                                      .text,
                                                                  City: edt_QualifiedCity
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedCity
                                                                      .text,
                                                                  State: edt_QualifiedState
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedState
                                                                      .text,
                                                                  Country: edt_QualifiedCountry
                                                                      .text ==
                                                                      null
                                                                      ? "India"
                                                                      : edt_QualifiedCountry
                                                                      .text,
                                                                  CountryISO: "",
                                                                  PrimaryMobileNo:
                                                                  edt_PrimaryContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_PrimaryContact
                                                                      .text,
                                                                  SecondaryMobileNo:
                                                                  edt_AlternateContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_AlternateContact
                                                                      .text,
                                                                  ForProduct: edt_QualifiedForProduct
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProduct
                                                                      .text,
                                                                  LeadSource:
                                                                  "TeleCaller",
                                                                  LeadStatus: edt_LeadStatus
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadStatus
                                                                      .text,
                                                                  EmployeeID: edt_QualifiedEmplyeeID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedEmplyeeID
                                                                      .text,
                                                                  ACID: "",
                                                                  ProductID: edt_QualifiedForProductID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProductID
                                                                      .text,
                                                                  Pincode: edt_QualifiedPinCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedPinCode
                                                                      .text,
                                                                  StateCode: edt_QualifiedStateCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedStateCode
                                                                      .text,
                                                                  CityCode: edt_QualifiedCityCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedCityCode
                                                                      .text,
                                                                  CountryCode:
                                                                  edt_QualifiedCountryCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedCountryCode
                                                                      .text,
                                                                  CustomerID: edt_Cust_ID_OF_CompanyName.text,
                                                                  ExLeadClosure:
                                                                  edt_DisQualifiedID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisQualifiedID
                                                                      .text,
                                                                  LoginUserID:
                                                                  LoginUserID,
                                                                  FollowupNotes: "",
                                                                  FollowupDate: "",
                                                                  PreferredTime: "",
                                                                  SerialKey: "",
                                                                  DisqualifedRemarks:
                                                                  edt_DisqualifiedRemarks
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisqualifiedRemarks
                                                                      .text,
                                                                  CompanyId: CompanyID
                                                                      .toString(),
                                                                  Latitude:
                                                                  SharedPrefHelper.instance.getLatitude().toString(),
                                                                  Longitude:
                                                                  SharedPrefHelper.instance.getLongitude().toString(),
                                                                  Image: fileName,
                                                                  Brand: edt_Brand.text.toString()

                                                              )));
                                                    });
                                              } else {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "DisQualified Reason is required!",
                                                    positiveButtonTitle: "OK",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                    });
                                              }
                                            } else if (isInProcess == true) {
                                              if (edt_QualifiedEmplyeeName
                                                  .text !=
                                                  "") {
                                                showCommonDialogWithTwoOptions(
                                                    context,
                                                    "Are you sure you want to Save TeleCaller Details ?",
                                                    negativeButtonTitle: "No",
                                                    positiveButtonTitle: "Yes",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                      _expenseBloc.add(
                                                          TeleCallerSaveCallEvent(context,
                                                              savepkID,
                                                              TeleCallerSaveRequest(
                                                                  LeadID: edt_LeadNo
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadNo
                                                                      .text,
                                                                  SenderName: edt_SenderName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_SenderName
                                                                      .text,
                                                                  QueryDatetime:
                                                                  edt_ReverseExpenseDateController
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_ReverseExpenseDateController
                                                                      .text,
                                                                  CompanyName: edt_CompanyName
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_CompanyName
                                                                      .text,
                                                                  SenderMail:
                                                                  edt_Email.text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Email
                                                                      .text,
                                                                  CountryFlagURL: "",
                                                                  Message: edt_Details
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Details
                                                                      .text,
                                                                  Address: edt_Address
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_Address
                                                                      .text,
                                                                  City: edt_QualifiedCity
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedCity
                                                                      .text,
                                                                  State: edt_QualifiedState
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedState
                                                                      .text,
                                                                  Country: edt_QualifiedCountry
                                                                      .text ==
                                                                      null
                                                                      ? "India"
                                                                      : edt_QualifiedCountry
                                                                      .text,
                                                                  CountryISO: "",
                                                                  PrimaryMobileNo:
                                                                  edt_PrimaryContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_PrimaryContact
                                                                      .text,
                                                                  SecondaryMobileNo:
                                                                  edt_AlternateContact
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_AlternateContact
                                                                      .text,
                                                                  ForProduct: edt_QualifiedForProduct
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProduct
                                                                      .text,
                                                                  LeadSource:
                                                                  "TeleCaller",
                                                                  LeadStatus: edt_LeadStatus
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_LeadStatus
                                                                      .text,
                                                                  EmployeeID: edt_QualifiedEmplyeeID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedEmplyeeID
                                                                      .text,
                                                                  ACID: "",
                                                                  ProductID: edt_QualifiedForProductID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedForProductID
                                                                      .text,
                                                                  Pincode: edt_QualifiedPinCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedPinCode
                                                                      .text,
                                                                  StateCode: edt_QualifiedStateCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedStateCode
                                                                      .text,
                                                                  CityCode: edt_QualifiedCityCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedCityCode
                                                                      .text,
                                                                  CountryCode:
                                                                  edt_QualifiedCountryCode
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_QualifiedCountryCode
                                                                      .text,
                                                                  CustomerID: edt_Cust_ID_OF_CompanyName.text,
                                                                  ExLeadClosure:
                                                                  edt_DisQualifiedID
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisQualifiedID
                                                                      .text,
                                                                  LoginUserID:
                                                                  LoginUserID,
                                                                  FollowupNotes: "",
                                                                  FollowupDate: "",
                                                                  PreferredTime: "",
                                                                  SerialKey: "",
                                                                  DisqualifedRemarks:
                                                                  edt_DisqualifiedRemarks
                                                                      .text ==
                                                                      null
                                                                      ? ""
                                                                      : edt_DisqualifiedRemarks
                                                                      .text,
                                                                  CompanyId: CompanyID
                                                                      .toString(),
                                                                  Latitude:
                                                                  SharedPrefHelper.instance.getLatitude().toString(),
                                                                  Longitude:
                                                                  SharedPrefHelper.instance.getLongitude().toString(),
                                                                  Image: fileName,
                                                                  Brand: edt_Brand.text.toString()

                                                              )));
                                                    });
                                              } else {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "Assign To is required!",
                                                    positiveButtonTitle: "OK",
                                                    onTapOfPositiveButton: () {
                                                      Navigator.of(context).pop();
                                                    });
                                              }
                                            } else {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  "Lead Status is required!",
                                                  positiveButtonTitle: "OK",
                                                  onTapOfPositiveButton: () {
                                                    Navigator.of(context).pop();
                                                  });
                                            }
                                          } else {
                                            showCommonDialogWithSingleOption(
                                                context,
                                                "Lead Status is required!",
                                                positiveButtonTitle: "OK",
                                                onTapOfPositiveButton: () {
                                                  Navigator.of(context).pop();
                                                });
                                          }
                                        } else {
                                          showCommonDialogWithSingleOption(
                                              context,
                                              "Primary Contact is required!",
                                              positiveButtonTitle: "OK",
                                              onTapOfPositiveButton: () {
                                                Navigator.of(context).pop();
                                              });
                                        }
                                      } else {
                                        showCommonDialogWithSingleOption(
                                            context,
                                            "Company Name is required!",
                                            positiveButtonTitle: "OK",
                                            onTapOfPositiveButton: () {
                                              Navigator.of(context).pop();
                                            });
                                      }
                                    } else {
                                      showCommonDialogWithSingleOption(context,
                                          "Contact Person is required!",
                                          positiveButtonTitle: "OK",
                                          onTapOfPositiveButton: () {
                                            Navigator.of(context).pop();
                                          });
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Details are required!",
                                        positiveButtonTitle: "OK",
                                        onTapOfPositiveButton: () {
                                          Navigator.of(context).pop();
                                        });
                                  }
                                }
                                else
                                {
                                  showCommonDialogWithSingleOption(
                                      context, "Product is required!",
                                      positiveButtonTitle: "OK",
                                      onTapOfPositiveButton: () {
                                        Navigator.of(context).pop();
                                      });
                                }
                              }
                            },
                            child: Card(
                                elevation: 10,
                                color: colorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                                  child: Center(
                                    child: Text("Save", style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight
                                            .bold)),
                                  ),
                                )



                            ),
                          ),
                        ),


                    /*    Row(
                          children: [
                            Expanded(flex: 2, child: LeadNo()),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(flex: 3, child: _buildFollowupDate()),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        QualifiedForProduct(),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),


                        _offlineLoggedInData.details[0].serialKey.toUpperCase()=="MYA6-G9EC-VS3P-H4PL" || _offlineLoggedInData.details[0].serialKey.toUpperCase()=="TEST-0000-SI0F-0208"?Brand():Container(),

                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Details *",
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
                            enabled: isAllEditable,
                            controller: edt_Details,
                            minLines: 2,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter Details',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: colorPrimary),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),*/
                       /* SenderName(),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        CompanyName(),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        Email(),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        PrimaryContact(),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        AlternativeContact(),
                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        Address1234(),
                        isforbluechem==false?Column(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(flex: 1, child: QualifiedCountry()),
                                Expanded(flex: 1, child: QualifiedState()),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(flex: 1, child: QualifiedCity()),
                                Expanded(flex: 1, child: QualifiedPinCode()),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                              height: 10,
                            ),

                          ],
                        ):Container(),

*/
                       /* SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        isViewSaveButton == true
                            ? getCommonButton(baseTheme, () async {







                              }, "Save", backGroundColor: colorPrimary)
                            : Container(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),*/
                      ]))),
        ),
      ),
    );
  }

  LeadStatus() {
    arr_ALL_Name_ID_For_LeadStatus.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Disqualified";
      } else if (i == 1) {
        all_name_id.Name = "Qualified";
      } else if (i == 2) {
        all_name_id.Name = "InProcess";
      }
      arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
    }
  }

  Future<bool> _onBackPressed() {
    if(_isForUpdate==true)
    {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = widget.arguments.LeadStatusFromList;
      all_name_id.pkID = widget.arguments.PagNo;
      all_name_id.Name1 = "";
      Navigator.of(context).pop(all_name_id);
    }
    else
    {
      navigateTo(context, TeleCallerListScreen.routeName, clearAllStack: true);

    }
   // navigateTo(context, TeleCallerListScreen.routeName, clearAllStack: true);
  }

  /*Future<int> deleteFile(File file123) async {
    try {
      final file = await file123.path;

      await file123.delete();
    } catch (e) {
      return 0;
    }
  }*/

  Widget ExpenseAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Amount",
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
                      focusNode: AmountFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_ExpenseAmount,
                      decoration: InputDecoration(
                        hintText: "Tap to enter Amount",
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

              ],
            ),
          ),
        )
      ],
    );
  }

  Widget LeadNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Lead #",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_LeadNo,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "000000",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget LeadSource() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Lead Source",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_LeadSource,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "Lead Source",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget ForProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("For Product",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_ForProduct,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "Product Name",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget SenderName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Contact Person *",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: isAllEditable,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: edt_SenderName,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget CompanyName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Company Name *",
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
        InkWell(
          onTap: () =>
              isAllEditable == true ? _onTapOfSearchCompanyView() : Container(),
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: CardViewHeight,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: edt_CompanyName,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "Tap to search company name",
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onTapOfSearchCompanyView() async {
    navigateTo(context, SearchCompanyScreen.routeName,
            arguments: SearchCompanyScreenArguments(edt_CompanyName.text))
        .then((value) {
      if (value != null) {
        ALL_Name_ID searchDetails123 = new ALL_Name_ID();
        searchDetails123 = value;
        edt_CompanyName.text = searchDetails123.Name.toString();
        edt_PrimaryContact.text = searchDetails123.Name1.toString();
        edt_Cust_ID_OF_CompanyName.text = searchDetails123.pkID ==0 || searchDetails123.pkID == null ?"":searchDetails123.pkID.toString();
        //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));

      }
    });
  }


  Widget Brand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Brand",
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
          child: InkWell(
            onTap: (){
              _expenseBloc.add(ProductBrandListRequestEvent(ProductBrandListRequest(
                  LoginUserID:LoginUserID,
                  CompanyId: CompanyID.toString()
              )));
            },
            child: Container(
              height: CardViewHeight,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: edt_Brand,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "Tap to enter brand",
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
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
          height: 10,
        ),
      ],
    );
  }


  Widget Email() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Email",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: isAllEditable,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: edt_Email,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "Tap to enter email",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget Address1234() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Address",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: isAllEditable,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: edt_Address,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "Tap to enter address",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget CountryHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Country",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: isAllEditable,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: edt_CountryHeader,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "Country",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget StateHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("State",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: isAllEditable,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: edt_StateHeader,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "State",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget CityHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("City",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: isAllEditable,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: edt_CityHeader,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "City",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget PinCodeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("PinCode",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: isAllEditable,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_PinHeader,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),

                        hintText: "PinCode",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget PrimaryContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Primary Contact # *",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLength: 16,
                      enabled: isAllEditable,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: edt_PrimaryContact,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),
                        counterText: "",
                        hintText: "Tap to enter Mobile No.",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget AlternativeContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Alternate Contact #",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLength: 16,
                      enabled: isAllEditable,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: edt_AlternateContact,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),
                        counterText: "",
                        hintText: "Tap to enter Mobile No.",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget FromLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("From Location",
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
                      focusNode: FromLocationFocusNode,
                      textInputAction: TextInputAction.next,
                      controller: edt_FromLocation,
                      decoration: InputDecoration(
                        hintText: "Tap to enter location",
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
                  Icons.location_on,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget ToLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("To Location",
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
                      controller: edt_ToLocation,
                      decoration: InputDecoration(
                        hintText: "Tap to enter location",
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
                  Icons.location_on,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
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
            onTap: () => showcustomdialog(
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
                          color: Color(0xFF000000),
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

  void fillData(TeleCallerListDetails expenseDetails) async {
    savepkID = expenseDetails.pkId;
    LeadID = expenseDetails.pkId;
    edt_ExpenseDateController.text = expenseDetails.queryDatetime
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseExpenseDateController.text = expenseDetails.queryDatetime
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_LeadNo.text = expenseDetails.pkId.toString();
    edt_LeadSource.text = expenseDetails.leadSource;
    edt_ForProduct.text = expenseDetails.forProduct;
    edt_Details.text = expenseDetails.message;
    edt_SenderName.text = expenseDetails.senderName;
    edt_CompanyName.text = expenseDetails.companyName;
    edt_Email.text = expenseDetails.senderMail;
    edt_Address.text = expenseDetails.address;

    edt_CountryHeader.text = expenseDetails.countryName;
    edt_StateHeader.text = expenseDetails.state;
    edt_CityHeader.text = expenseDetails.city;
    edt_PinHeader.text = expenseDetails.pincode;
    edt_QualifiedPinCode.text = expenseDetails.pincode;
    edt_PrimaryContact.text = expenseDetails.primaryMobileNo;
    edt_AlternateContact.text = expenseDetails.secondaryMobileNo;
    edt_LeadStatus.text = expenseDetails.leadStatus;
    edt_DisqualifiedRemarks.text = expenseDetails.DisqualifedRemarks;

    edt_Brand.text = expenseDetails.Brand;

    if (edt_LeadStatus.text == "Qualified") {
      isqualified = true;
      isAllEditable = false;
      isViewSaveButton = false;
      isDisqualified = false;
      isInProcess = false;



      edt_QualifiedEmplyeeName.text = expenseDetails.employeeName;
      edt_QualifiedEmplyeeID.text = expenseDetails.employeeID.toString();
      edt_QualifiedForProduct.text =
          expenseDetails.productName == "--Not Available--"
              ? ""
              : expenseDetails.productName;
      edt_QualifiedForProductID.text = expenseDetails.productID.toString();
      edt_QualifiedCountry.text = expenseDetails.countryName;
      edt_QualifiedCountryCode.text = expenseDetails.countryCode;
      edt_QualifiedState.text = expenseDetails.stateName;
      edt_QualifiedStateCode.text = expenseDetails.stateCode.toString();
      edt_QualifiedCity.text = expenseDetails.cityName;
      edt_QualifiedCityCode.text = expenseDetails.cityCode.toString();
      edt_QualifiedPinCode.text = expenseDetails.pincode;
    }
    if (edt_LeadStatus.text == "Disqualified") {
      isAllEditable = true;
      isViewSaveButton = true;
      isDisqualified = true;
      isqualified = false;
      isInProcess = false;


      edt_DisQualifiedName.text = expenseDetails.exLeadClosureReason;
      edt_DisQualifiedID.text = expenseDetails.exLeadClosure.toString();

      edt_QualifiedEmplyeeName.text = expenseDetails.employeeName;
      edt_QualifiedEmplyeeID.text = expenseDetails.employeeID.toString();
      edt_QualifiedForProduct.text =
          expenseDetails.productName == "--Not Available--"
              ? ""
              : expenseDetails.productName;
      edt_QualifiedForProductID.text = expenseDetails.productID.toString();
      edt_QualifiedCountry.text = expenseDetails.countryName;
      edt_QualifiedCountryCode.text = expenseDetails.countryCode;
      edt_QualifiedState.text = expenseDetails.stateName;
      edt_QualifiedStateCode.text = expenseDetails.stateCode.toString();
      edt_QualifiedCity.text = expenseDetails.cityName;
      edt_QualifiedCityCode.text = expenseDetails.cityCode.toString();
      edt_QualifiedPinCode.text = expenseDetails.pincode;
    }
    if (edt_LeadStatus.text == "InProcess") {
      isAllEditable = true;
      isViewSaveButton = true;
      isInProcess = true;
      isDisqualified = false;
      isqualified = false;



      edt_QualifiedEmplyeeName.text = expenseDetails.employeeName;
      edt_QualifiedEmplyeeID.text = expenseDetails.employeeID.toString();
      edt_QualifiedEmplyeeName.text = expenseDetails.employeeName;
      edt_QualifiedEmplyeeID.text = expenseDetails.employeeID.toString();
      edt_QualifiedForProduct.text =
          expenseDetails.productName == "--Not Available--"
              ? ""
              : expenseDetails.productName;
      edt_QualifiedForProductID.text = expenseDetails.productID.toString();
      edt_QualifiedCountry.text = expenseDetails.countryName;
      edt_QualifiedCountryCode.text = expenseDetails.countryCode;
      edt_QualifiedState.text = expenseDetails.stateName;
      edt_QualifiedStateCode.text = expenseDetails.stateCode.toString();
      edt_QualifiedCity.text = expenseDetails.cityName;
      edt_QualifiedCityCode.text = expenseDetails.cityCode.toString();
      edt_QualifiedPinCode.text = expenseDetails.pincode;
    }
    if (edt_LeadStatus.text == "") {
      isAllEditable = true;
      isViewSaveButton = true;
      edt_QualifiedEmplyeeName.text = expenseDetails.employeeName;
      edt_QualifiedEmplyeeID.text = expenseDetails.employeeID.toString();
      edt_QualifiedForProduct.text =
          expenseDetails.productName == "--Not Available--"
              ? ""
              : expenseDetails.productName;
      edt_QualifiedForProductID.text = expenseDetails.productID.toString();
      edt_QualifiedCountry.text = expenseDetails.countryName;
      edt_QualifiedCountryCode.text = expenseDetails.countryCode;
      edt_QualifiedState.text = expenseDetails.stateName;
      edt_QualifiedStateCode.text = expenseDetails.stateCode.toString();
      edt_QualifiedCity.text = expenseDetails.cityName;
      edt_QualifiedCityCode.text = expenseDetails.cityCode.toString();
      edt_QualifiedPinCode.text = expenseDetails.pincode;
    }


    if (expenseDetails.image.isNotEmpty) {
      ImageURLFromListing = "";
      ImageURLFromListing = _offlineCompanyData.details[0].siteURL+"otherimages/"+expenseDetails.image.toString().trim();
      print("ImageURLFromListing"+ "ImageURLFromListing : " +ImageURLFromListing);
      GetImageNamefromEditMode =expenseDetails.image;
      print("ImageURLFromListing1235"+ "ImageURLFromListing : " +GetImageNamefromEditMode);

    } else {
      ImageURLFromListing = "";
    }






   // fileName = SiteURL + expenseDetails.image;

    /* if (_editModel.FollowUpImage.isNotEmpty) {
      ImageURLFromListing =
          SiteURL+"followupimages/"+_editModel.FollowUpImage;
      print("ImageURLFromListing"+ "ImageURLFromListing : " +ImageURLFromListing);
      GetImageNamefromEditMode = _editModel.FollowUpImage;
      print("ImageURLFromListing1235"+ "ImageURLFromListing : " +GetImageNamefromEditMode);

    } else {
      ImageURLFromListing = "";
    }*/
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        isAllEditable == true
            ? _selectDate(context, edt_ExpenseDateController)
            : Container();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Query Date *",
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
              height: CardViewHeight,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_ExpenseDateController.text == null ||
                              edt_ExpenseDateController.text == ""
                          ? "DD-MM-YYYY"
                          : edt_ExpenseDateController.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_ExpenseDateController.text == null ||
                                  edt_ExpenseDateController.text == ""
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
        edt_ExpenseDateController.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseExpenseDateController.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  void _onLeaveRequestTypeSuccessResponse(ExpenseTypeCallResponseState state) {
    if (state.expenseTypeResponse.details.length != 0) {
      arr_ALL_Name_ID_For_LeaveType.clear();
      for (var i = 0; i < state.expenseTypeResponse.details.length; i++) {
        print("description : " +
            state.expenseTypeResponse.details[i].expenseTypeName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.expenseTypeResponse.details[i].expenseTypeName;
        all_name_id.pkID = state.expenseTypeResponse.details[i].pkID;
        arr_ALL_Name_ID_For_LeaveType.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_LeaveType,
          context1: context,
          controller: edt_ExpenseType,
          controllerID: edt_ExpenseTypepkID,
          lable: "Select Expense Type");
    }
  }

  LeadQualified() {
    return Container(
      child: Column(
        children: [
          /* Row(
            children: [Icon(Icons.ac_unit,color: colorPrimary,),

              SizedBox(
                width: 20,
              ),
              Text("Matured Lead Information")],
          ),*/

          GestureDetector(
            onTap: () => isAllEditable == true
                ? showcustomdialogWithID(
                    values: arr_All_Employee_List,
                    context1: context,
                    controller: edt_QualifiedEmplyeeName,
                    controllerID: edt_QualifiedEmplyeeID,
                    lable: "Select Employee ")
                : Container(),
            child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Assign To *",
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
                      color: colorTileBG,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: CardViewHeight,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  controller: edt_QualifiedEmplyeeName,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Select Assign To",
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
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FollowupFields(),
                  ],
                )),
          ),
          SizedBox(
            width: 20,
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget QualifiedForProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Product * ",
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
        InkWell(
          onTap: () =>
              isAllEditable == true ? _onTapOfSearchView() : Container(),
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: CardViewHeight,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedForProduct,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "Tap to search Product",
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget QualifiedCountry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Country *",
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
        InkWell(
            onTap: () => isAllEditable == true
                ? _onTapOfSearchCountryView(_searchDetails == null
                    ? ""
                    : /*_searchDetails.countryCode*/ "")
                : Container(),
            child: Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: CardViewHeight,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: edt_QualifiedCountry,
                          decoration: InputDecoration(
                            //contentPadding: EdgeInsets.only(bottom: 10),

                            hintText: "Country",
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
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget QualifiedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("State * ",
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
        InkWell(
          onTap: () => isAllEditable == true
              ? _onTapOfSearchStateView(
                  _searchDetails == null ? "" : _searchDetails.countryCode)
              : Container(),
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: CardViewHeight,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedState,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "State",
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget QualifiedCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("City * ",
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
        InkWell(
          onTap: () {
            _onTapOfSearchCityView(edt_QualifiedStateCode.text == null
                ? ""
                : edt_QualifiedStateCode.text.toString());
          },
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: CardViewHeight,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedCity,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "City",
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget QualifiedPinCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("PinCode",
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
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLength: 6,
                      enabled: isAllEditable,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_QualifiedPinCode,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),
                        counterText: "",
                        hintText: "PinCode",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse offlineALLEmployeeListData) {
    arr_All_Employee_List.clear();
    for (int i = 0; i < offlineALLEmployeeListData.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = offlineALLEmployeeListData.details[i].employeeName;
      all_name_id.pkID = offlineALLEmployeeListData.details[i].pkID;
      arr_All_Employee_List.add(all_name_id);
    }
  }

  void _onCountryListSuccess(CountryListEventResponseState state) {
    arr_ALL_Name_ID_For_Country.clear();
    for (var i = 0; i < state.countrylistresponse.details.length; i++) {
      print("CustomerCategoryResponse2 : " +
          state.countrylistresponse.details[i].countryName);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          state.countrylistresponse.details[i].countryName;
      categoryResponse123.Name1 =
          state.countrylistresponse.details[i].countryCode;
      arr_ALL_Name_ID_For_Country.add(categoryResponse123);
      _listFilteredCountry.add(categoryResponse123);
      //children.add(new ListTile());
    }
  }

  _onTapOfSearchCountryView(String sw) {
    navigateTo(context, SearchCountryScreen.routeName,
            arguments: CountryArguments(sw))
        .then((value) {
      if (value != null) {
        _searchDetails = SearchCountryDetails();
        _searchDetails = value;
        print("CountryName IS From SearchList" + _searchDetails.countryCode);
        edt_QualifiedCountryCode.text = /*_searchDetails.countryCode*/ "";
        edt_QualifiedCountry.text = _searchDetails.countryName;
        _expenseBloc.add(CountryCallEvent(CountryListRequest(
            CountryCode: /*_searchDetails.countryCode*/ "IND",
            CompanyID: CompanyID.toString())));
      }
    });
  }

  Future<void> _onTapOfSearchStateView(String sw1) async {
    navigateTo(context, SearchStateScreen.routeName,
            arguments: StateArguments(sw1))
        .then((value) {
      if (value != null) {
        _searchStateDetails = value;
        edt_QualifiedStateCode.text = _searchStateDetails.value.toString();
        edt_QualifiedState.text = _searchStateDetails.label.toString();
        _expenseBloc.add(StateCallEvent(StateListRequest(
            CountryCode: sw1,
            CompanyId: CompanyID.toString(),
            word: "",
            Search: "1")));
      }
    });
  }

  void _onStateListSuccess(StateListEventResponseState responseState) {
    arr_ALL_Name_ID_For_State.clear();
    for (var i = 0; i < responseState.statelistresponse.details.length; i++) {
      print("CustomerCategoryResponse2 : " +
          responseState.statelistresponse.details[i].label);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          responseState.statelistresponse.details[i].label;
      categoryResponse123.pkID =
          responseState.statelistresponse.details[i].value;
      arr_ALL_Name_ID_For_State.add(categoryResponse123);
      _listFilteredState.add(categoryResponse123);
      //children.add(new ListTile());
    }
  }

  void _onCityListSuccess(CityListEventResponseState responseState) {
    arr_ALL_Name_ID_For_City.clear();
    _listFilteredCity.clear();
    for (var i = 0; i < responseState.cityApiRespose.details.length; i++) {
      print("CustomerCategoryResponse2 : " +
          responseState.cityApiRespose.details[i].cityName);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          responseState.cityApiRespose.details[i].cityName;
      categoryResponse123.pkID =
          responseState.cityApiRespose.details[i].cityCode;
      arr_ALL_Name_ID_For_City.add(categoryResponse123);
      _listFilteredCity.add(categoryResponse123);
      //children.add(new ListTile());
    }
  }

  Future<void> _onTapOfSearchCityView(String talukaCode) async {
    navigateTo(context, SearchCityScreen.routeName,
            arguments: CityArguments(talukaCode))
        .then((value) {
      if (value != null) {
        _searchCityDetails = value;
        edt_QualifiedCityCode.text = _searchCityDetails.cityCode.toString();
        edt_QualifiedCity.text = _searchCityDetails.cityName.toString();
        _expenseBloc
          ..add(CityCallEvent(CityApiRequest(
              CityName: "",
              CompanyID: CompanyID.toString(),
              StateCode: talukaCode)));
      }
    });
  }

  Future<void> _onTapOfSearchView() async {
    /* navigateTo(context, SearchInquiryProductScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _inquiryBloc.add(InquiryProductSearchNameCallEvent(InquiryProductSearchRequest(pkID: "",CompanyId: "10032",ListMode: "L",SearchKey: value)));
       print("ProductDetailss345"+_searchDetails.productName +"Alias"+ _searchDetails.productAlias);
      }
    });*/
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _productSearchDetails = value;
        edt_QualifiedForProduct.text =
            _productSearchDetails.productName.toString();
        edt_QualifiedForProductID.text = _productSearchDetails.pkID.toString();
        //_totalAmountController.text = ""

      }
    });
  }

  LeadDisQualified() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Row(
            children: [Icon(Icons.ac_unit,color: colorPrimary,),

              SizedBox(
                width: 20,
              ),
              Text("Matured Lead Information")],
          ),*/
          SizedBox(
            width: 20,
            height: 10,
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("DisQualified Reason *",
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
                  InkWell(
                    onTap: () => isAllEditable == true
                        ? _expenseBloc.add(CustomerSourceCallEvent(
                            CustomerSourceRequest(
                                companyId: CompanyID,
                                StatusCategory: "DisQualifiedReason",
                                pkID: "",
                                LoginUserID: LoginUserID,
                                SearchKey: "")))
                        : Container(),
                    child: Card(
                      elevation: 5,
                      color: colorTileBG,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: CardViewHeight,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  controller: edt_DisQualifiedName,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Select DisQualified Reason",
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
                    ),
                  )
                ],
              )),
          SizedBox(
            width: 20,
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Disqualified Remarks",
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
              enabled: isAllEditable,
              controller: edt_DisqualifiedRemarks,
              minLines: 2,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Enter Details',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: new BorderSide(color: colorPrimary),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void _onDisQualifiedResonResult(CustomerSourceCallEventResponseState state) {
    arr_All_DisQualifiedList.clear();
    for (int i = 0; i < state.sourceResponse.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.sourceResponse.details[i].inquiryStatus;
      all_name_id.pkID = state.sourceResponse.details[i].pkID;
      arr_All_DisQualifiedList.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_All_DisQualifiedList,
        context1: context,
        controller: edt_DisQualifiedName,
        controllerID: edt_DisQualifiedID,
        lable: "Select DisQualified Reason ");
  }

  _DisqualifiedRequest() {}

  LeadInProcess() {
    return Container(
      child: Column(
        children: [
          /* Row(
            children: [Icon(Icons.ac_unit,color: colorPrimary,),

              SizedBox(
                width: 20,
              ),
              Text("Matured Lead Information")],
          ),*/

          GestureDetector(
            onTap: () => isAllEditable == true
                ? showcustomdialogWithID(
                    values: arr_All_Employee_List,
                    context1: context,
                    controller: edt_QualifiedEmplyeeName,
                    controllerID: edt_QualifiedEmplyeeID,
                    lable: "Select Employee ")
                : Container(),
            child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Assign To *",
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
                      color: colorTileBG,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: CardViewHeight,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  controller: edt_QualifiedEmplyeeName,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Select Assign To",
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
                )),
          ),
          SizedBox(
            width: 20,
            height: 10,
          ),
        ],
      ),
    );
  }

  void _onExternalLeadSucessResponse(
      ExternalLeadSaveResponseState state) async {
    String SucessMsg = "";
    bool gotoimageUpload=false;
    for (int i = 0; i < state.response.details.length; i++) {
      SucessMsg = state.response.details[i].column2;
    }
    if (SucessMsg == "Duplicate Contact Number, This Number Already exists in Customer Master !")
      {
        gotoimageUpload = true;
      }
    else
      {
        String updatemsg = _isForUpdate == true ? " Updated " : " Created ";
        String notiTitle= "TeleCaller";

        ///state.inquiryHeaderSaveResponse.details[0].column3;
        String notibody  = "TeleCaller " +
            //state.inquiryHeaderSaveResponse.details[0].column3 +
            updatemsg +
            " Successfully " +
            // edt_CustomerName.text +
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

        if(ReportToToken!="")
          {
            _expenseBloc.add(FCMNotificationRequestEvent(request123));

          }
      }
    //String Msg = _isForUpdate == true ? "Inquiry Updated Successfully" : "Inquiry Added Successfully";

    /* showCommonDialogWithSingleOption(context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
        });*/

    if(_selectedImageFile!=null)
    {
      if (gotoimageUpload == true) {
        await showCommonDialogWithSingleOption(Globals.context, SucessMsg,
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              //Duplicate Contact Number, This Number Already exists in Customer Master !
              Navigator.of(context).pop();

            });


      } else {

        if(SucessMsg=="Inquiry Added Successfully")
          {

            final extension = p.extension(_selectedImageFile.path);
            int timestamp1 = DateTime
                .now()
                .millisecondsSinceEpoch;

            _expenseBloc.add(TeleCallerUploadImageNameCallEvent(
                  state.contextfromHeader,
                _selectedImageFile,
                TeleCallerUploadImgApiRequest(
                  CompanyID: CompanyID.toString(),
                  LoginUserId: LoginUserID,
                  pkID: state.response.details[0].pkID.toString()=="null"?"":state.response.details[0].pkID.toString(),
                  Image: _selectedImageFile.path
                      .split('/')
                      .last,//state.response.details[0].pkID.toString()+"_TeleCaller_"+timestamp1.toString()+extension.toString(),


                  /*state.response.details[0].pkID.toString()+"_"+_selectedImageFile.path
                      .split('/')
                      .last,*/
                  LeadID: state.response.details[0].leadID.toString()=="null"?"":state.response.details[0].leadID.toString(),
                )));
          }
        else
          {

            final extension = p.extension(_selectedImageFile.path);
            int timestamp1 = DateTime
                .now()
                .millisecondsSinceEpoch;
            _expenseBloc.add(TeleCallerUploadImageNameCallEvent(
                state.contextfromHeader,
                _selectedImageFile,
                TeleCallerUploadImgApiRequest(
                  CompanyID: CompanyID.toString(),
                  LoginUserId: LoginUserID,
                  pkID: state.response.details[0].pkID.toString()=="null"?"":state.response.details[0].pkID.toString(),
                  Image:_selectedImageFile.path
                      .split('/')
                      .last,//state.response.details[0].pkID.toString()+"_TeleCaller_"+timestamp1.toString()+extension.toString(),
                  LeadID: state.response.details[0].leadID.toString()=="null"?"":state.response.details[0].leadID.toString(),
                )));
          }

      }



    }
    else
      {
        await showCommonDialogWithSingleOption(Globals.context, SucessMsg,
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              //Duplicate Contact Number, This Number Already exists in Customer Master !
              if (SucessMsg ==
                  "Duplicate Contact Number, This Number Already exists in Customer Master !") {
                Navigator.of(context).pop();
              } else {
                if(_isForUpdate==true)
                {
                  // skdjdsf


                  ALL_Name_ID all_name_id = ALL_Name_ID();
                  all_name_id.Name = edt_LeadStatus.text;
                  all_name_id.pkID = widget.arguments.PagNo;
                  all_name_id.Name1 = savepkID.toString();
                  Navigator.pop(context);
                  Navigator.of(state.contextfromHeader).pop(all_name_id);
                }
                else
                {
                  navigateTo(context, TeleCallerListScreen.routeName, clearAllStack: true);

                }
              }
            });
      }

    //Navigator.of(context).pop();
  }

  Widget uploadImage(BuildContext context123) {

    return Column(
      children: [
        _selectedImageFile == null
            ? _isForUpdate //edit mode or not
                ? Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ImageURLFromListing.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: colorGray,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: ImageFullScreenWrapperWidget(
                                  child: Image.network(
                                    ImageURLFromListing,
                                    height: 125,
                                    width: 125,
                                  ),
                                  dark: true,
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    // padding: const EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: colorGray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
/*
                                    margin: EdgeInsets.only(left: 180),
*/
                                    child: GestureDetector(
                                      onTap: () {
                                        showCommonDialogWithTwoOptions(context,
                                            "Are you sure you want to delete this Image ?",
                                            negativeButtonTitle: "No",
                                            positiveButtonTitle: "Yes",
                                            onTapOfPositiveButton: () {
                                          Navigator.of(context).pop();

                                          _expenseBloc.add(TeleCallerImageDeleteRequestCallEvent(savepkID,TeleCallerImageDeleteRequest(CompanyId: CompanyID.toString())));

                                          //_FollowupBloc.add(FollowupImageDeleteCallEvent(savepkID, FollowupImageDeleteRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID)));
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 32,
                                        color: colorPrimary,
                                      ),
                                    ),
                                  )),
                            ],
                          )
                        : Container())
                : Container()
            : Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageFullScreenWrapperWidget(
                    child: Image.file(
                      _selectedImageFile,
                      height: 125,
                      width: 125,
                    ),
                    dark: true,
                  ),
                ),
              ),

        InkWell(
          onTap: () async {


            pickImage(context, onImageSelection: (file) async
            {

              final dir = await path_provider.getTemporaryDirectory();

              final extension = p.extension(file.path);
              int timestamp1 = DateTime
                  .now()
                  .millisecondsSinceEpoch;
              String FileNameWithTimeStamp = savepkID.toString() + "_TeleCaller_"+ DateTime.now()
                  .day
                  .toString() +
                  "_" +
                  DateTime.now()
                      .month
                      .toString() +
                  "_" +
                  DateTime.now()
                      .year
                      .toString() +
                  "_" +
                  timestamp1
                      .toString();

              /*Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;*/

              final targetPath = dir.absolute.path + "/"+FileNameWithTimeStamp.toString() + extension;


              print("DirectoryPath"+" DirectoryPath : " + targetPath.toString());

              File file1 = await testCompressAndGetFile(file,targetPath);
              final bytes = file1.readAsBytesSync().lengthInBytes;
              final kb = bytes / 1024;
              final mb = kb / 1024;
              /*if(mb<5)
              {*/

              //clearimage();
              _selectedImageFile = file1;



              print("Image File Is Largre" + mb.toString());
              isImageDeleted = false;
              //}
/*            else
              {

                showCommonDialogWithSingleOption(
                    context,
                    "Image Size must be less than 5 Mb !",
                    positiveButtonTitle: "OK",
                    onTapOfPositiveButton:
                        () {
                      Navigator.of(context).pop();
                    });
              }*/


              baseBloc.refreshScreen();
            });
          },
          child: Card(
              elevation: 10,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                child: Center(
                  child: Text("Upload Image", style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight
                          .bold)),
                ),
              )



          ),
        ),

      ],
    );
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
     /* showCommonDialogWithSingleOption(context,
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

      /*if (serviceLocation == true) {
        // Use location.
        _serviceEnabled=false;

         location.requestService();


      }
      else{
        _serviceEnabled=true;
        _getCurrentLocation();



      }*/
    }
  }

  _getCurrentLocation() {
    geolocator123
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best)
        .then((Position position) async {
      _currentPosition = position;
      Longitude = position.longitude.toString();
      Latitude = position.latitude.toString();

      Address = await getAddressFromLatLngMapMyIndia(
          Latitude, Longitude, MAPMYINDIAKEY);
    }).catchError((e) {
      print(e);
    });

    location.onLocationChanged.listen((LocationData currentLocation) async {
      // Use current location
      print("OnLocationChange" +
          " Location : " +
          currentLocation.latitude.toString());
      //  placemarks = await placemarkFromCoordinates(currentLocation.latitude,currentLocation.longitude);
      // final coordinates = new Coordinates(currentLocation.latitude,currentLocation.longitude);
      // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      //  print("${first.featureName} : ${first.addressLine}");
      Latitude = currentLocation.latitude.toString();
      Longitude = currentLocation.longitude.toString();
      Address = await getAddressFromLatLngMapMyIndia(
          Latitude, Longitude, MAPMYINDIAKEY);

      //  Address = "${first.featureName} : ${first.addressLine}";
    });

    // _FollowupBloc.add(LocationAddressCallEvent(LocationAddressRequest(key:"",latlng:Latitude+","+Longitude)));
  }
// esko ignor karo yeho me blank pass karta hu
  /*Future<String> getAddressFromLatLng(
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
  }*/

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

  void _OnUploadImageSucess(TeleCallerUploadImgApiResponseState state) async {


   await  showCommonDialogWithSingleOption(Globals.context, _isForUpdate==true ?"Lead and Image Updated Successfully ! " : "Lead and Image Added Successfully",
    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      //Duplicate Contact Number, This Number Already exists in Customer Master !
         if(_isForUpdate==true)
         {
           // skdjdsf


           ALL_Name_ID all_name_id = ALL_Name_ID();
           all_name_id.Name = edt_LeadStatus.text;
           all_name_id.pkID = widget.arguments.PagNo;
           all_name_id.Name1 = savepkID.toString();
           Navigator.pop(context);
           Navigator.of(state.contextFromAddEditScreen).pop(all_name_id);
         }
         else
         {
           navigateTo(context, TeleCallerListScreen.routeName, clearAllStack: true);

         }
          /*navigateTo(context, TeleCallerListScreen.routeName,
              clearAllStack: true);*/
    });

  }


  _OnDeleteTeleCallerImageResponseSucess(TeleCallerImageDeleteResponseState state) {
    print("ImageDeleteSucess"+ state.response.details[0].column1.toString());
    _isForUpdate=false;
    isImageDeleted = true;
    setState(() {

    });
  }

  clearimage() {
    setState(() {
      _selectedImageFile = null;
    });
  }

  void _onGetTokenfromReportopersonResult(GetReportToTokenResponseState state) {

    ReportToToken = state.response.details[0].reportPersonTokenNo;

  }

  void _onRecevedNotification(FCMNotificationResponseState state) {

    print("fcm_notification" +
        state.response.canonicalIds.toString() +
        state.response.failure.toString() +
        state.response.multicastId.toString() +
        state.response.success.toString() +
        state.response.results[0].messageId);
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
                child: Text("Next FollowUp Date",
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
                color: colorTileBG,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: 42,
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
                color: colorTileBG,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: 42,
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


  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print('testCompressAndGetFile');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,

    );
    print(file.lengthSync());
    print(result?.lengthSync());
    return result;
  }

  Future<File> testCompressAndGetFile1(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  void _onBrandListResponse(ProductBrandResponseState state) {

    arr_ALL_Name_ID_For_Brand.clear();
    for(int i=0;i<state.productBrandResponse.details.length;i++)
      {
        print("BrnadResponseFromAPI" + state.productBrandResponse.details[i].brandName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.productBrandResponse.details[i].brandName;

        arr_ALL_Name_ID_For_Brand.add(all_name_id);
      }


    showcustomdialogWithOnlyName(
        values: arr_ALL_Name_ID_For_Brand,
        context1: context,
        controller: edt_Brand,

        lable: "Select DisQualified Reason ");

  }

  ManageOpportunities() {

    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: _isForUpdate,
                child: Expanded(
                  child: TextFormField(
                      controller: edt_LeadNo,
                      enabled: false,

                      decoration: const InputDecoration(
                        // border: UnderlineInputBorder(),
                        labelText: 'Lead',

                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      )
                  ),
                ),
              ),


              Visibility(
                  visible: _isForUpdate,
                  child: SizedBox(width: 20,)),
              Expanded(
                child: InkWell(
                  onTap: (){
                    isAllEditable == true
                        ? _selectDate(context, edt_ExpenseDateController)
                        : Container();
                  },
                  child: TextFormField(
                      controller: edt_ExpenseDateController,
                      enabled: false,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Query Date',
                          hintText: "DD-MM-YYYY"
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      )
                  ),
                ),
              ),
            ],),
          SizedBox(height: 20,),

          InkWell(
            onTap: (){
              isAllEditable == true ? _onTapOfSearchView() : Container();
            },
            child: TextFormField(
                controller: edt_QualifiedForProduct,
                enabled: false,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Product *',
                    hintText :"Product Name"
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF000000),
                )
            ),
          ),
          SizedBox(height: 20,),

          _offlineLoggedInData.details[0].serialKey.toUpperCase()=="MYA6-G9EC-VS3P-H4PL"?InkWell(
            onTap: (){
             // isAllEditable == true ? _onTapOfSearchView() : Container();

              _expenseBloc.add(ProductBrandListRequestEvent(ProductBrandListRequest(
                  LoginUserID:LoginUserID,
                  CompanyId: CompanyID.toString()
              )));
            },
            child: Container(
    margin: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                  controller: edt_Brand,
                  enabled: false,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Brand',
                      hintText :"Brand Name"
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )
              ),
            ),
          ):Container(),
          //edt_Brand
          Container(
            //margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Details *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

            ),
          ),
          TextFormField(
            enabled: isAllEditable,
            controller: edt_Details,
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter Details',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide:
                  new BorderSide(color: colorPrimary),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10)),
                )),
          ),
          SizedBox(height: 20,),


          InkWell(
            onTap: (){
              setState(() {
               /* IsCompanyInfo = !IsCompanyInfo;
                IsLeadInfo=false;
                IsLeadStatusInfo=false;*/

                IsBasicDetails = !IsBasicDetails;
                IsManageOpertunity=false;
                IsLeadStatusDetails=false;
              });
            },
            child: Card(
                elevation: 10,
                color: colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                  child: Center(
                    child: Text("Next", style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight
                            .bold)),
                  ),
                )



            ),
          ),


        ],),
    );

  }

  BasicDetails() {

    return Container(
        margin: EdgeInsets.all(20),

        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextFormField(
                  enabled: isAllEditable,
                  textInputAction: TextInputAction.next,

                  controller: edt_SenderName,
                  // enabled: false,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Sender Name',
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )
              ),

              SizedBox(height: 20,),

              //edt_CompanyName

              InkWell(
                onTap: (){
                  isAllEditable == true ? _onTapOfSearchCompanyView() : Container();
                },
                child: TextFormField(
                   // enabled: isAllEditable,
                    textInputAction: TextInputAction.next,

                    controller: edt_CompanyName,
                     enabled: false,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Company Name *',
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF000000),
                    )
                ),
              ),
              SizedBox(height: 20,),


              TextFormField(
                  enabled: isAllEditable,
                  textInputAction: TextInputAction.next,

                  controller: edt_Email,
                  // enabled: false,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )
              ),

              SizedBox(height: 20,),

              TextFormField(
                  enabled: isAllEditable,

                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: edt_PrimaryContact,
                  // enabled: false,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Primary Contact *',
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )
              ),

              SizedBox(height: 20,),



              TextFormField(
                  enabled: isAllEditable,

                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: edt_AlternateContact,
                  // enabled: false,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Alternate Contact',
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )
              ),
              //edt_Email
              SizedBox(height: 20,),

              TextFormField(
                  enabled: isAllEditable,

                  controller: edt_Address,
                  // enabled: false,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Address',
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )
              ),
              SizedBox(height: 20,),


              isforbluechem==false?Column(children: [


                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          isAllEditable == true
                              ? _onTapOfSearchCountryView(""):Container();
                        },
                        child: TextFormField(
                            controller: edt_QualifiedCountry,
                            enabled: false,
                            textInputAction: TextInputAction.next,

                            decoration: const InputDecoration(
                              // border: UnderlineInputBorder(),
                              labelText: 'Country',

                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )
                        ),
                      ),
                    ),

                    SizedBox(width: 20,),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          isAllEditable == true
                              ? _onTapOfSearchStateView(
                              edt_QualifiedCountryCode.text):Container();
                        },
                        child: TextFormField(
                            controller: edt_QualifiedState,
                            enabled: false,
                            textInputAction: TextInputAction.next,

                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'State',
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )
                        ),
                      ),
                    ),


                  ],),
                SizedBox(height: 20,),

                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: InkWell(
                        onTap: (){
                          _onTapOfSearchCityView(edt_QualifiedStateCode.text);
                        },
                        child: TextFormField(
                            controller: edt_QualifiedCity,
                            enabled: false,
                            textInputAction: TextInputAction.next,

                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'City',
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),

                    Expanded(
                      child: TextFormField(
                          controller: edt_QualifiedPinCode,
                          enabled: isAllEditable,
                          textInputAction: TextInputAction.next,

                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'PinCode',
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )
                      ),
                    ),
                  ],),
                SizedBox(height: 20,),
              ],):Container(),










              InkWell(
                onTap: (){
                  setState(() {
                   /* IsLeadStatusInfo = !IsLeadStatusInfo;
                    IsLeadInfo=false;
                    IsCompanyInfo=false;*/
                    IsLeadStatusDetails = !IsLeadStatusDetails;
                    IsManageOpertunity=false;
                    IsBasicDetails=false;
                  });
                },
                child: Card(
                    elevation: 10,
                    color: colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                      child: Center(
                        child: Text("Next", style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight
                                .bold)),
                      ),
                    )



                ),
              ),

            ]));

  }

  LeadStatusDetails() {

    return Container(
      margin: EdgeInsets.all(10),

      child: Column(children: [

        GestureDetector(
          onTap: () => isAllEditable == true
              ? showcustomdialogWithOnlyName(
              values: arr_ALL_Name_ID_For_LeadStatus,
              context1: context,
              controller: edt_LeadStatus,
              lable: "Select Lead Status")
              : Container(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Lead Status *",
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
                  color: colorTileBG,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHeight,
                    padding:
                    EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: edt_LeadStatus,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Select Lead Status",
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
        ),
        isqualified == true ? LeadQualified() : Container(),
        isDisqualified == true
            ? LeadDisQualified()
            : Container(),
        isInProcess == true ? LeadInProcess() : Container(),
        SizedBox(
          width: 20,
          height: 15,
        ),
      ],),
    );
  }

}
