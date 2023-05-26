import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/complaint/complaint_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_emp_follower_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/accurabath_complaint/accurabath_complaint_no_to_upload_video_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/accurabath_complaint_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/complaint_image_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/accurabath_complaint/accurabath_complaint_videoList_Response.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/ACCURABATH/accurabath_complaint/accurabath_complaint_listing_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_country_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/image_full_screen.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddUpdateAccuraBathComplaintScreenArguments {
  AccuraBathComplaintListResponseDetails editModel;
  List<FetchAccuraBathComplaintImageListResponseDetails> arrrImageVideoList123;
  List<AccurabathComplaintVideoListResponseDetails> arrcomplaintSiteVideoList;
  List<File> ImageFileListFromAPI = [];
  List<File> videoFileListFromAPI = [];

  AddUpdateAccuraBathComplaintScreenArguments(
      this.editModel,
      this.arrrImageVideoList123,
      this.arrcomplaintSiteVideoList,
      this.ImageFileListFromAPI,
      this.videoFileListFromAPI);
}

class AccuraBathComplaintAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/AccuraBathComplaintAddEditScreen';
  final AddUpdateAccuraBathComplaintScreenArguments arguments;

  AccuraBathComplaintAddEditScreen(this.arguments);

  @override
  _AccuraBathComplaintAddEditScreenState createState() =>
      _AccuraBathComplaintAddEditScreenState();
}

class _AccuraBathComplaintAddEditScreenState
    extends BaseState<AccuraBathComplaintAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController edt_ComplanitID = TextEditingController();

  final TextEditingController edt_ComplanitDate = TextEditingController();
  final TextEditingController edt_ReverseComplanitDate =
      TextEditingController();

  final TextEditingController edt_SheduleDate = TextEditingController();
  final TextEditingController edt_ReverseSheduleDate = TextEditingController();

  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerID = TextEditingController();

  final TextEditingController edt_Referene = TextEditingController();

  final TextEditingController edt_MobileNo = TextEditingController();
  final TextEditingController edt_SrNo = TextEditingController();

  final TextEditingController edt_ComplaintDiscription =
      TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();
  final TextEditingController edt_AssignTo = TextEditingController();
  final TextEditingController edt_AssignToID = TextEditingController();

  final TextEditingController edt_satus = TextEditingController();
  final TextEditingController edt_satusID = TextEditingController();

  final TextEditingController edt_Type = TextEditingController();
  final TextEditingController edt_ComplaintNotes = TextEditingController();

  final TextEditingController edt_Address = TextEditingController();

  final TextEditingController edt_FromTime = TextEditingController();
  final TextEditingController edt_ToTime = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadSource = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Type = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Country = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_State = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_District = [];

  List<ALL_Name_ID> _listFilteredCountry = [];

  List<ALL_Name_ID> _listFilteredState = [];
  List<ALL_Name_ID> _listFilteredCity = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  ComplaintScreenBloc _complaintScreenBloc;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  ALL_EmployeeList_Response _offlineALLEmployeeListData;
  SearchDetails _searchDetails;

  ProductSearchDetails _searchProductDetails;

  bool _isForUpdate;
  int CompanyID = 0;
  String LoginUserID = "";
  AccuraBathComplaintListResponseDetails _editModel;

  List<FetchAccuraBathComplaintImageListResponseDetails>
      _arrrImageVideoList123 = [];

  List<AccurabathComplaintVideoListResponseDetails> _arrcomplaintSiteVideoList;

  List<FetchAccuraBathComplaintImageListResponseDetails> _arrrVideoList123 = [];

  int savepkID = 0;
  final TextEditingController edt_QualifiedCountry = TextEditingController();
  final TextEditingController edt_QualifiedCountryCode =
      TextEditingController();
  final TextEditingController edt_QualifiedState = TextEditingController();

  final TextEditingController edt_QualifiedStateCode = TextEditingController();
  final TextEditingController edt_QualifiedCity = TextEditingController();
  final TextEditingController edt_QualifiedCityCode = TextEditingController();

  final TextEditingController edt_Pincode = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productIDController = TextEditingController();

  SearchStateDetails _searchStateDetails;
  SearchCityDetails _searchCityDetails;
  double CardViewHieght = 35;

  List<File> multiple_selectedImageFile = [];
  List<File> Tempmultiple_selectedImageFile = [];

  List<File> ALLImageVideoList = [];

  final picker = ImagePicker();

  String _retrieveDataError;
  XFile videofile;
  List<File> MultipleVideoList = [];

  String VideoURLFromListing = "";

  Uint8List data;
  String ImageURLFromListing = "";
  List<FetchAccuraBathComplaintImageListResponseDetails> arrImageList = [];

  bool isLoading = false;

  bool isUploadedDocs = false;

  bool loadingProgresswithdoc = false;

  @override
  void initState() {
    super.initState();

    _complaintScreenBloc = ComplaintScreenBloc(baseBloc);

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    // FetchAssignTODetails(_offlineALLEmployeeListData);
    FetchTypeDetails();

    _complaintScreenBloc.add(AccuraBathComplaintEmpFollowerListRequestEvent(
        AccuraBathComplaintEmpFollowerListRequest(
            CompanyId: CompanyID.toString())));

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      ShowProgressIndicatorState(true);

      _editModel = widget.arguments.editModel;
      _arrrImageVideoList123 = widget.arguments.arrrImageVideoList123;
      _arrcomplaintSiteVideoList = widget.arguments.arrcomplaintSiteVideoList;

      fillData();

      ShowProgressIndicatorState(false);

      /* loadingProgresswithdoc = false;
      loadercerculur(loadingProgresswithdoc);*/

      //https://www.youtube.com/watch?v=BAgLOAGga2o&ab_channel=JohannesMilke
    } else {
      VideoURLFromListing = "";
      edt_ComplanitID.text = "";
      selectedDate = DateTime.now();
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
      edt_SheduleDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseSheduleDate.text = selectedDate.year.toString() +
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

      edt_QualifiedCountry.text = "India";
      edt_QualifiedCountryCode.text = "IND";
      // _searchStateDetails.value = _offlineLoggedInData.details[0].stateCode;
      edt_QualifiedState.text = _offlineLoggedInData.details[0].StateName;
      edt_QualifiedStateCode.text =
          _offlineLoggedInData.details[0].stateCode.toString();

      edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
      edt_QualifiedCityCode.text =
          _offlineLoggedInData.details[0].CityCode.toString();

      _productNameController.text = "";
      _productIDController.text = "";

      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///listener to multiple states of bloc to handles api responses
  ///use only BlocListener if only need to listen to events

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _complaintScreenBloc
        ..add(AccuraBathComplaintEmpFollowerListRequestEvent(
            AccuraBathComplaintEmpFollowerListRequest(
                CompanyId: CompanyID.toString()))),
      child: BlocConsumer<ComplaintScreenBloc, ComplaintScreenStates>(
        builder: (BuildContext context, ComplaintScreenStates state) {
          if (state is AccuraBathComplaintEmployeeListResponseState) {
            _onGetComplaintImageList(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is AccuraBathComplaintEmployeeListResponseState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, ComplaintScreenStates state) {
          if (state is CustomerSourceCallEventResponseState) {
            _onLeadSourceListTypeCallSuccess(state);
          }
          if (state is AccuraBathComplaintSaveResponseState) {
            _OnComplaintSaveResponseSucess(state);
          }
          if (state is AccuraBathComplaintUploadImageCallResponseState) {
            _OnComplaintImageUploadSucess(state);
          }

          if (state is AccuraBathComplaintUploadVideoCallResponseState) {
            _OnComplaintVideoUploadSucess(state);
          }
          if (state is CountryListEventResponseState) {
            _onCountryListSuccess(state);
          }
          if (state is StateListEventResponseState) {
            _onStateListSuccess(state);
          }
          if (state is CityListEventResponseState) {
            _onCityListSuccess(state);
          }

          if (state is AccuraBathComplaintNoToDeleteImageResponseState) {
            _OnImageDeleteResponse(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is CustomerSourceCallEventResponseState ||
              currentState is AccuraBathComplaintSaveResponseState ||
              currentState is CountryListEventResponseState ||
              currentState is StateListEventResponseState ||
              currentState is CityListEventResponseState ||
              currentState is AccuraBathComplaintUploadImageCallResponseState ||
              currentState is AccuraBathComplaintNoToDeleteImageResponseState ||
              currentState is AccuraBathComplaintUploadVideoCallResponseState) {
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
          title: Text('Complaint Details'),
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
                        _isForUpdate == true
                            ? _buildComplaintNo()
                            : Container(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        _buildFollowupDate(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        _buildBankACSearchView(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Mobile No.*",
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
                            controller: edt_MobileNo,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter Number',
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
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Reference #",
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
                            controller: edt_Referene,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter Reference #',
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter Number',
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
                        _buildProductSearchView(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
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
                        Padding(
                          padding: EdgeInsets.only(left: 7, right: 7, top: 10),
                          child: TextFormField(
                            controller: edt_Address,
                            minLines: 2,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter Address',
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
                        Row(
                          children: [
                            Expanded(flex: 1, child: QualifiedCountry()),
                            Expanded(flex: 1, child: QualifiedState()),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: QualifiedCity()),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          height: CardViewHieght,
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          width: double.maxFinite,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                    controller: edt_Pincode,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 6,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 10),
                                                      counterText: "",
                                                      hintText: "PinCode",
                                                      labelStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
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
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Complaint Description *",
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
                            controller: edt_ComplaintNotes,
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
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selectFromTime(context, edt_FromTime);
                                      },
                                      child: Container(
                                        height: 60,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 10),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selectToTime(context, edt_ToTime);
                                      },
                                      child: Container(
                                        height: 60,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 10),
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
                        _buildEmplyeeListView(),
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
                        CustomDropDown1("Type",
                            enable1: false,
                            title: "Type",
                            hintTextvalue: "Tap to Select Type",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Type,
                            Custom_values1: arr_ALL_Name_ID_For_Type),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        uploadImage(context),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        uploadVideosss(context),

                        //  uploadVideo(context),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),

                        getCommonButton(baseTheme, () {
                          print("ComplaintDetails" +
                              "ComplaintDate : " +
                              edt_ComplanitDate.text +
                              " ComplaintReverseDate : " +
                              edt_ReverseComplanitDate.text +
                              " CustomerName : " +
                              edt_CustomerName.text +
                              " Customer ID : " +
                              edt_CustomerID.text +
                              " Reference : " +
                              edt_Referene.text +
                              " ComplaintNotes : " +
                              edt_ComplaintNotes.text +
                              " SheduleDate : " +
                              edt_SheduleDate.text +
                              " ReverseSheduleDate : " +
                              edt_ReverseSheduleDate.text +
                              " FromTime : " +
                              edt_FromTime.text +
                              " ToTime : " +
                              edt_ToTime.text +
                              " AssignTo : " +
                              edt_AssignTo.text +
                              " AssignToID : " +
                              edt_AssignToID.text +
                              " Status : " +
                              edt_satus.text +
                              " StatusID : " +
                              edt_satusID.text +
                              " Type : " +
                              edt_Type.text +
                              "");

                          if (edt_CustomerName.text != "") {
                            if (edt_MobileNo.text != "") {
                              if (edt_ComplaintNotes.text != "") {
                                if (edt_SheduleDate.text != "") {
                                  if (edt_AssignTo.text != "") {
                                    print("sljdrte" +
                                        " Image List : " +
                                        multiple_selectedImageFile.length
                                            .toString() +
                                        " VideoList : " +
                                        MultipleVideoList.length.toString());
                                    /*ALLImageVideoList.clear();
                                    ALLImageVideoList.addAll(
                                        multiple_selectedImageFile);
                                    ALLImageVideoList.addAll(MultipleVideoList);*/

                                    print("dfjdfdj" +
                                        " ALLImageVideoList : " +
                                        ALLImageVideoList.length.toString());

                                    DateTime FbrazilianDate =
                                        new DateFormat("dd-MM-yyyy")
                                            .parse(edt_ComplanitDate.text);
                                    DateTime NbrazilianDate =
                                        new DateFormat("dd-MM-yyyy")
                                            .parse(edt_SheduleDate.text);

                                    if (FbrazilianDate.isBefore(
                                        NbrazilianDate)) {
                                      showCommonDialogWithTwoOptions(context,
                                          "Are you sure you want to Save this Complaint Details ?",
                                          negativeButtonTitle: "No",
                                          positiveButtonTitle: "Yes",
                                          onTapOfPositiveButton: () {
                                        Navigator.of(context).pop();

                                        /* _complaintScreenBloc.add(
                                            AccurabathComplaintImageDeleteRequestEvent(
                                                edt_ComplanitID.text,
                                                AccurabathComplaintImageDeleteRequest(
                                                    CompanyId:
                                                        CompanyID.toString(),
                                                    LoginUserID: LoginUserID,
                                                    KeyValue:
                                                        edt_ComplanitID.text)));

                                        _complaintScreenBloc.add(
                                            AccurabathComplaintVideoDeleteRequestEvent(
                                                edt_ComplanitID.text,
                                                AccurabathComplaintVideoDeleteRequest(
                                                    CompanyId:
                                                        CompanyID.toString(),
                                                    LoginUserID: LoginUserID,
                                                    ComplaintNo:
                                                        edt_ComplanitID.text)));*/

                                        _complaintScreenBloc.add(
                                            AccuraBathComplaintSaveRequestEvent(
                                                savepkID,
                                                AccuraBathComplaintSaveRequest(
                                                  pkID: savepkID.toString(),
                                                  ComplaintDate:
                                                      edt_ReverseComplanitDate
                                                          .text,
                                                  ComplaintNo:
                                                      edt_ComplanitID.text,
                                                  CustomerEmpName:
                                                      edt_CustomerName.text,
                                                  CustmoreMobileNo:
                                                      edt_MobileNo.text,
                                                  ComplaintNotes:
                                                      edt_ComplaintNotes.text,
                                                  ComplaintType:
                                                      edt_Type.text == null
                                                          ? ""
                                                          : edt_Type.text,
                                                  ComplaintStatus:
                                                      edt_satus.text == null
                                                          ? ""
                                                          : edt_satus.text,
                                                  CustomerID2:
                                                      edt_AssignToID.text,
                                                  PreferredDate:
                                                      edt_ReverseSheduleDate
                                                          .text,
                                                  TimeFrom: edt_FromTime.text,
                                                  TimeTo: edt_ToTime.text,
                                                  LoginUserID: LoginUserID,
                                                  CompanyId:
                                                      CompanyID.toString(),
                                                  ReferenceNo:
                                                      edt_Referene.text == null
                                                          ? ""
                                                          : edt_Referene.text,
                                                  DateOfPurchase: selectedDate
                                                          .year
                                                          .toString() +
                                                      "-" +
                                                      selectedDate.month
                                                          .toString() +
                                                      "-" +
                                                      selectedDate.day
                                                          .toString(),
                                                  SiteAddress: edt_Address.text,
                                                  CityCode:
                                                      edt_QualifiedCityCode
                                                          .text,
                                                  CountryCode:
                                                      edt_QualifiedCountryCode
                                                          .text,
                                                  StateCode:
                                                      edt_QualifiedStateCode
                                                          .text,
                                                  Pincode: edt_Pincode.text,
                                                  ConvinientDate: selectedDate
                                                          .year
                                                          .toString() +
                                                      "-" +
                                                      selectedDate.month
                                                          .toString() +
                                                      "-" +
                                                      selectedDate.day
                                                          .toString(),
                                                  ProductID:
                                                      _productIDController.text,
                                                  SrNo: edt_SrNo.text,
                                                ),
                                                multiple_selectedImageFile,
                                                MultipleVideoList));
                                      });
                                    } else {
                                      if (FbrazilianDate.isAtSameMomentAs(
                                          NbrazilianDate)) {
                                        showCommonDialogWithTwoOptions(context,
                                            "Are you sure you want to Save this Complaint Details ?",
                                            negativeButtonTitle: "No",
                                            positiveButtonTitle: "Yes",
                                            onTapOfPositiveButton: () {
                                          Navigator.of(context).pop();
                                          _complaintScreenBloc.add(
                                              AccuraBathComplaintSaveRequestEvent(
                                                  savepkID,
                                                  AccuraBathComplaintSaveRequest(
                                                    pkID: savepkID.toString(),
                                                    ComplaintDate:
                                                        edt_ReverseComplanitDate
                                                            .text,
                                                    ComplaintNo:
                                                        edt_ComplanitID.text,
                                                    CustomerEmpName:
                                                        edt_CustomerName.text,
                                                    CustmoreMobileNo:
                                                        edt_MobileNo.text,
                                                    ComplaintNotes:
                                                        edt_ComplaintNotes.text,
                                                    ComplaintType:
                                                        edt_Type.text == null
                                                            ? ""
                                                            : edt_Type.text,
                                                    ComplaintStatus:
                                                        edt_satus.text == null
                                                            ? ""
                                                            : edt_satus.text,
                                                    CustomerID2:
                                                        edt_AssignToID.text,
                                                    PreferredDate:
                                                        edt_ReverseSheduleDate
                                                            .text,
                                                    TimeFrom: edt_FromTime.text,
                                                    TimeTo: edt_ToTime.text,
                                                    LoginUserID: LoginUserID,
                                                    CompanyId:
                                                        CompanyID.toString(),
                                                    ReferenceNo:
                                                        edt_Referene.text ==
                                                                null
                                                            ? ""
                                                            : edt_Referene.text,
                                                    DateOfPurchase: selectedDate
                                                            .year
                                                            .toString() +
                                                        "-" +
                                                        selectedDate.month
                                                            .toString() +
                                                        "-" +
                                                        selectedDate.day
                                                            .toString(),
                                                    SiteAddress:
                                                        edt_Address.text,
                                                    CityCode:
                                                        edt_QualifiedCityCode
                                                            .text,
                                                    CountryCode:
                                                        edt_QualifiedCountryCode
                                                            .text,
                                                    StateCode:
                                                        edt_QualifiedStateCode
                                                            .text,
                                                    Pincode: edt_Pincode.text,
                                                    ConvinientDate: selectedDate
                                                            .year
                                                            .toString() +
                                                        "-" +
                                                        selectedDate.month
                                                            .toString() +
                                                        "-" +
                                                        selectedDate.day
                                                            .toString(),
                                                    ProductID:
                                                        _productIDController
                                                            .text,
                                                    SrNo: edt_SrNo.text,
                                                  ),
                                                  multiple_selectedImageFile,
                                                  MultipleVideoList));
                                        });
                                      } else {
                                        showCommonDialogWithSingleOption(
                                            context,
                                            "Schedule Date Should be greater than Complaint Date !",
                                            positiveButtonTitle: "OK",
                                            onTapOfPositiveButton: () {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Assign To is required !",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Schedule Date is required !",
                                      onTapOfPositiveButton: () {
                                    Navigator.of(context).pop();
                                  });
                                }
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Complaint Notes is required !",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context).pop();
                                });
                              }
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "Mobile No. is required !",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                              });
                            }
                          } else {
                            showCommonDialogWithSingleOption(
                                context, "Customer name is required !",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                            });
                          }
                        }, "Save", backGroundColor: colorPrimary),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                      ]))),
        ),
      ),
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
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_For_Type,
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

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_AssignTo,
            context1: context,
            controller: edt_AssignTo,
            controllerID: edt_AssignToID,
            lable: "Select AssignTo");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Assigned To *",
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
                    child: TextField(
                      controller: edt_AssignTo,
                      enabled: false,
                      style: TextStyle(
                          color: Colors.black, // <-- Change this

                          fontSize: 15),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Select Employee"),
                    ),
                    // dropdown()
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
    );
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

  Widget _buildNextFollowupDate() {
    return InkWell(
      onTap: () {
        _selectNextFollowupDate(context, edt_SheduleDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Schedule Date *",
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
                      edt_SheduleDate.text == null || edt_SheduleDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_SheduleDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_SheduleDate.text == null ||
                                  edt_SheduleDate.text == ""
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
        edt_SheduleDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseSheduleDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _isForUpdate == false
            ? _selectDate(context, edt_ComplanitDate)
            : Container();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Complaint Date *",
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

  Widget _buildComplaintNo() {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Complaint No",
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
                      edt_ComplanitID.text == null || edt_ComplanitID.text == ""
                          ? "Complaint No."
                          : edt_ComplanitID.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_ComplanitID.text == null ||
                                  edt_ComplanitID.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
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

  Widget _buildBankACSearchView() {
    return Column(
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, AccurabathComplaintListScreen.routeName,
        clearAllStack: true);
  }

  FetchAssignTODetails(ALL_EmployeeList_Response offlineALLEmployeeListData) {
    arr_ALL_Name_ID_For_AssignTo.clear();
    for (var i = 0; i < offlineALLEmployeeListData.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      all_name_id.Name = offlineALLEmployeeListData.details[i].employeeName;
      all_name_id.pkID = offlineALLEmployeeListData.details[i].pkID;

      arr_ALL_Name_ID_For_AssignTo.add(all_name_id);
    }
  }

  void fillData() {
    if (_editModel.complaintDate == "") {
      selectedDate = DateTime.now();
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
    } else {
      edt_ComplanitDate.text = _editModel.complaintDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseComplanitDate.text = _editModel.complaintDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }
    if (_editModel.preferredDate == "") {
      selectedDate = DateTime.now();

      edt_SheduleDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseSheduleDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();
    } else {
      edt_SheduleDate.text = _editModel.preferredDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseSheduleDate.text = _editModel.preferredDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }
    savepkID = _editModel.pkID.toInt();
    edt_CustomerName.text = _editModel.customerEmpName;
    //edt_CustomerID.text = _editModel..toString();
    edt_Referene.text = ""; //_editModel.re;
    edt_ComplaintNotes.text = _editModel.complaintNotes;

    if (_editModel.timeFrom == "") {
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
    } else {
      edt_FromTime.text = _editModel.timeFrom.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "hh:mm a");
    }
    if (_editModel.timeTo == "") {
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
      edt_ToTime.text =
          beforZeroHourToTime + ":" + beforZerominuteToTime + " " + AM_PMToTime;
    } else {
      edt_ToTime.text = _editModel.timeTo.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "hh:mm a");
    }

    edt_AssignTo.text = _editModel.assignedTo;
    edt_AssignToID.text = _editModel.customerID2.toString();
    edt_satus.text =
        _editModel.complaintStatus == "0" ? "" : _editModel.complaintStatus;
    edt_Type.text = _editModel.complaintType;
    edt_ComplanitID.text = _editModel.complaintNo;
    // VideoURLFromListing = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";
    //"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

    if (_editModel.productName != "") {
      if (_editModel.productName != "--Not Available--") {
        _productNameController.text = _editModel.productName;
        _productIDController.text = _editModel.productID.toString();
      } else {
        _productNameController.text = "";
        _productIDController.text = "";
      }
    } else {
      _productNameController.text = "";
      _productIDController.text = "";
    }

    edt_SrNo.text = _editModel.srNo;
    edt_MobileNo.text = _editModel.custmoreMobileNo;
    edt_Address.text = _editModel.siteAddress;

    edt_QualifiedCountry.text = _editModel.countryName;
    edt_QualifiedCountryCode.text = _editModel.countryCode;
    edt_QualifiedState.text = _editModel.stateName;
    edt_QualifiedStateCode.text = _editModel.stateCode.toString();
    edt_QualifiedCity.text = _editModel.cityName.toString();
    edt_QualifiedCityCode.text = _editModel.cityCode.toString();
    edt_Pincode.text = _editModel.pincode.toString();

    /*for (int i = 0; i < _arrrImageVideoList123.length; i++) {
      print("ImageNameList" +
          " Image : " +
          _arrrImageVideoList123[i].docName.toString());
      ImageURLFromListing = _offlineCompanyData.details[0].siteURL +
          "/ModuleDocs/" +
          _arrrImageVideoList123[i].docName.toString();

      print("FileExtention" +
          " File Type : " +
          _arrrImageVideoList123[i].docName.split(".").last);

      if (_arrrImageVideoList123[i].docName != "") {
        if (_arrrImageVideoList123[i].docName.split(".").last == "jpg" ||
            _arrrImageVideoList123[i].docName.split(".").last == "png") {
          getDetailsOfImage(ImageURLFromListing,
              _arrrImageVideoList123[i].docName.toString());
        }
        setState(() {});
      }


    }*/

    for (int i = 0; i < widget.arguments.ImageFileListFromAPI.length; i++) {
      multiple_selectedImageFile.add(widget.arguments.ImageFileListFromAPI[i]);
    }

    for (int i = 0; i < widget.arguments.videoFileListFromAPI.length; i++) {
      MultipleVideoList.add(widget.arguments.videoFileListFromAPI[i]);
    }

    // multiple_selectedImageFile.addAll(widget.arguments.ImageFileListFromAPI);
    //  MultipleVideoList.addAll(widget.arguments.videoFileListFromAPI);

    /* for (int i = 0; i < _arrcomplaintSiteVideoList.length; i++) {
      print("ImageNameList" +
          " Image : " +
          _arrcomplaintSiteVideoList[i].fileName.toString());
      ImageURLFromListing = _offlineCompanyData.details[0].siteURL +
          "/SiteDocs/" +
          _arrcomplaintSiteVideoList[i].fileName.toString();

      print("sssf33er" + " VideoFile Path : " + ImageURLFromListing);

      if (_arrcomplaintSiteVideoList[i].fileName != "") {
        {
          getDetailsOfVideo(ImageURLFromListing,
              _arrcomplaintSiteVideoList[i].fileName.toString());
        }

        setState(() {});
      }
    }*/

    //ShowProgressIndicatorState(false);
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
    arr_ALL_Name_ID_For_Type.clear();
    for (var i = 0; i <= 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Online";
      } else if (i == 1) {
        all_name_id.Name = "Offline";
      }
      arr_ALL_Name_ID_For_Type.add(all_name_id);
    }
  }

  void _OnComplaintSaveResponseSucess(
      AccuraBathComplaintSaveResponseState state) async {
    //String Msg = "";

    String Msg = _isForUpdate == true
        ? "Complaint Updated Successfully"
        : "Complaint Added Successfully";

    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, AccurabathComplaintListScreen.routeName,
          clearAllStack: true);
    });

    /* print("ljfjdfj" + MultipleVideoList.length.toString());

    var splitNo = state.complaintSaveResponse.details[0].column3.split(",");
    print("CONO" + " Co.Number : " + splitNo[0] + " pkID : " + splitNo[1]);
    if (edt_ComplanitID.text != "") {
      _complaintScreenBloc.add(AccurabathComplaintImageDeleteRequestEvent(
          splitNo[0],
          AccurabathComplaintImageDeleteRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              KeyValue: splitNo[0])));

      _complaintScreenBloc.add(AccurabathComplaintVideoDeleteRequestEvent(
          splitNo[0],
          AccurabathComplaintVideoDeleteRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              ComplaintNo: splitNo[0])));
    }

    if (multiple_selectedImageFile.length != 0) {
      _complaintScreenBloc.add(AccuraBathComplaintUploadImageAPIRequestEvent(
          multiple_selectedImageFile,
          AccuraBathComplaintUploadImageAPIRequest(
              ModuleName: "complaint",
              DocName: multiple_selectedImageFile[0].path.split('/').last,
              KeyValue: splitNo[0],
              LoginUserId: LoginUserID,
              CompanyId: CompanyID.toString(),
              pkID: splitNo[1],
              file: multiple_selectedImageFile[0])));
    } else {
      _complaintScreenBloc.add(AccuraBathComplaintUploadVideoAPIRequestEvent(
          MultipleVideoList,
          AccuraBathComplaintUploadVideoAPIRequest(
              CompanyId: CompanyID.toString(),
              pkID: splitNo[1],
              ComplaintNo: splitNo[0],
              Name: MultipleVideoList[0].path.split('/').last,
              Type: "sitevideo",
              LoginUserId: LoginUserID,
              file: MultipleVideoList[0])));
    }

    if (multiple_selectedImageFile.length == 0 ||
        MultipleVideoList.length == 0) {
      String Msg = _isForUpdate == true
          ? "Complaint Updated Successfully"
          : "Complaint Added Successfully";

      await showCommonDialogWithSingleOption(Globals.context, Msg,
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        navigateTo(context, AccurabathComplaintListScreen.routeName,
            clearAllStack: true);
      });
    }*/
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
            onTap: () => _onTapOfSearchCountryView(""),
            child: Card(
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
                          enabled: false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: edt_QualifiedCountry,
                          decoration: InputDecoration(
                            //contentPadding: EdgeInsets.only(bottom: 10),
                            contentPadding: EdgeInsets.only(bottom: 10),

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

  Future<void> _onTapOfSearchCountryView(String sw) async {
    navigateTo(context, SearchCountryScreen.routeName,
            arguments: CountryArguments(sw))
        .then((value) {
      if (value != null) {
        //_searchDetails = SearchDetails();
        //_searchDetails = value;
        print("CountryName IS From SearchList" + value.countryCode);
        edt_QualifiedCountryCode.text = value.countryCode;
        edt_QualifiedCountry.text = value.countryName;
        _complaintScreenBloc.add(CountryCallEvent(CountryListRequest(
            CountryCode: value.countryCode, CompanyID: CompanyID.toString())));
      }
    });
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
          onTap: () => _onTapOfSearchStateView(
              edt_QualifiedCountryCode.text == ""
                  ? ""
                  : edt_QualifiedCountryCode.text),
          child: Card(
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
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedState,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10),
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

  Future<void> _onTapOfSearchStateView(String sw1) async {
    navigateTo(context, SearchStateScreen.routeName,
            arguments: StateArguments(sw1))
        .then((value) {
      if (value != null) {
        _searchStateDetails = value;
        edt_QualifiedStateCode.text = _searchStateDetails.value.toString();
        edt_QualifiedState.text = _searchStateDetails.label.toString();
        _complaintScreenBloc.add(StateCallEvent(StateListRequest(
            CountryCode: sw1,
            CompanyId: CompanyID.toString(),
            word: "",
            Search: "1")));
      }
    });
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
          onTap: () => _onTapOfSearchCityView(
              edt_QualifiedStateCode.text == null
                  ? ""
                  : edt_QualifiedStateCode.text.toString()),
          child: Card(
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
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedCity,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10),
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

  Future<void> _onTapOfSearchCityView(String talukaCode) async {
    navigateTo(context, SearchCityScreen.routeName,
            arguments: CityArguments(talukaCode))
        .then((value) {
      if (value != null) {
        _searchCityDetails = value;
        edt_QualifiedCityCode.text = _searchCityDetails.cityCode.toString();
        edt_QualifiedCity.text = _searchCityDetails.cityName.toString();
        _complaintScreenBloc
          ..add(CityCallEvent(CityApiRequest(
              CityName: "",
              CompanyID: CompanyID.toString(),
              StateCode: talukaCode)));
      }
    });
  }

  void _onCountryListSuccess(CountryListEventResponseState responseState) {
    arr_ALL_Name_ID_For_Country.clear();
    for (var i = 0; i < responseState.countrylistresponse.details.length; i++) {
      print("CustomerCategoryResponse2 : " +
          responseState.countrylistresponse.details[i].countryName);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          responseState.countrylistresponse.details[i].countryName;
      categoryResponse123.Name1 =
          responseState.countrylistresponse.details[i].countryCode;
      arr_ALL_Name_ID_For_Country.add(categoryResponse123);
      _listFilteredCountry.add(categoryResponse123);
      //children.add(new ListTile());
    }
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
    arr_ALL_Name_ID_For_District.clear();
    for (var i = 0; i < responseState.cityApiRespose.details.length; i++) {
      print("CustomerCategoryResponse2 : " +
          responseState.cityApiRespose.details[i].cityName);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          responseState.cityApiRespose.details[i].cityName;
      categoryResponse123.pkID =
          responseState.cityApiRespose.details[i].cityCode;
      arr_ALL_Name_ID_For_District.add(categoryResponse123);
      _listFilteredCity.add(categoryResponse123);
      //children.add(new ListTile());
    }
  }

  Widget uploadImage(BuildContext context123) {
    //multiple_selectedImageFile.toSet().toList();

    return Column(
      children: [
        if (multiple_selectedImageFile.length != 0)
          Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: colorLightGray,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImageFullScreenWrapperWidget(
                                  child: Image.file(
                                    File(
                                        multiple_selectedImageFile[index].path),
                                    height: 125,
                                    width: 125,
                                  ),
                                  dark: true,
                                ),
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

                                  child: GestureDetector(
                                    onTap: () {
                                      showCommonDialogWithTwoOptions(context,
                                          "Are you sure you want to delete this Image ?",
                                          negativeButtonTitle: "No",
                                          positiveButtonTitle: "Yes",
                                          onTapOfPositiveButton: () {
                                        Navigator.of(context).pop();
                                        multiple_selectedImageFile
                                            .removeAt(index);
                                        setState(() {});
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
                        ),
                      );

                      // }
                    },
                    shrinkWrap: true,
                    itemCount: multiple_selectedImageFile.length,
                  ),
                ),
              ],
            ),
          )
        else
          Container(),
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
                              leading: new Icon(Icons.photo_library),
                              title: new Text('Photo Gallery'),
                              onTap: () async {
                                Navigator.of(context).pop();
                                FilePickerResult result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.image,
                                );

                                if (result != null) {
                                  List<File> imageList = result.paths
                                      .map((path) => File(path))
                                      .toList();

                                  //  List<String> bigImageList = [];
                                  for (int i = 0; i < imageList.length; i++) {
                                    final bytes = imageList[i]
                                        .readAsBytesSync()
                                        .lengthInBytes;
                                    final kb = bytes / 1024;
                                    final mb = kb / 1024;

                                    if (mb > 10) {
                                      // bigImageList.add(imageList[i].path.split(".").last);

                                      showcustomdialogWithImageSized(
                                          context1: context,
                                          values: imageList,
                                          lable:
                                              "Image Size Should not be Greater than 10 MB !");
                                    } else {
                                      setState(() {
                                        multiple_selectedImageFile
                                            .add(imageList[i]);
                                      });
                                    }
                                  }
                                } else {
                                  // User canceled the picker
                                }
                              }),
                          new ListTile(
                            leading: new Icon(Icons.photo_camera),
                            title: new Text('Camera'),
                            onTap: () async {
                              Navigator.of(context).pop();

                              _onImageButtonPressed(ImageSource.camera,
                                  context: context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });

            /* FilePickerResult result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.image,
            );

            if (result != null) {
              List<File> imageList =
                  result.paths.map((path) => File(path)).toList();

              //  List<String> bigImageList = [];
              for (int i = 0; i < imageList.length; i++) {
                final bytes = imageList[i].readAsBytesSync().lengthInBytes;
                final kb = bytes / 1024;
                final mb = kb / 1024;

                if (mb > 10) {
                  // bigImageList.add(imageList[i].path.split(".").last);

                  showcustomdialogWithImageSized(
                      context1: context,
                      values: imageList,
                      lable: "Image Size Should not be Greater than 10 MB !");
                } else {
                  setState(() {
                    multiple_selectedImageFile.add(imageList[i]);
                  });
                }
              }
            } else {
              // User canceled the picker
            }*/

            //  multiple_selectedImageFile.addAll(imageList);
          }
        }, "Upload Image", backGroundColor: Colors.indigoAccent)
      ],
    );
  }

  Widget uploadVideosss(BuildContext context123) {
    //multiple_selectedImageFile.toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (MultipleVideoList.length != 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCommonDialogWithTwoOptions(context,
                                "Are you sure you want to delete this Video ?",
                                negativeButtonTitle: "No",
                                positiveButtonTitle: "Yes",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
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
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    OpenFile.open(
                                        MultipleVideoList[index].path);
                                  },
                                  child: Text(
                                    MultipleVideoList[index]
                                        .path
                                        .split('/')
                                        .last
                                        .replaceAll(" ", ""),
                                    overflow: TextOverflow.ellipsis,
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
          )
        else
          Container(),
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
                              leading: new Icon(Icons.photo_library),
                              title: new Text('Video Gallery'),
                              onTap: () async {
                                Navigator.of(context).pop();
                                FilePickerResult result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.video,
                                );

                                if (result != null) {
                                  List<File> imageList = result.paths
                                      .map((path) => File(path))
                                      .toList();

                                  //  List<String> bigImageList = [];
                                  for (int i = 0; i < imageList.length; i++) {
                                    final bytes = imageList[i]
                                        .readAsBytesSync()
                                        .lengthInBytes;
                                    final kb = bytes / 1024;
                                    final mb = kb / 1024;

                                    if (mb > 10) {
                                      // bigImageList.add(imageList[i].path.split(".").last);

                                      showcustomdialogWithImageSized(
                                          context1: context,
                                          values: imageList,
                                          lable:
                                              "Video Size Should not be Greater than 10 MB !");
                                    } else {
                                      setState(() {
                                        MultipleVideoList.add(imageList[i]);
                                      });
                                    }
                                  }
                                } else {
                                  // User canceled the picker
                                }
                              }),
                          new ListTile(
                            leading: new Icon(Icons.photo_camera),
                            title: new Text('Camera'),
                            onTap: () async {
                              Navigator.of(context).pop();

                              _onVideoButtonPressed(ImageSource.camera,
                                  context: context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        }, "Upload Video", backGroundColor: Colors.indigoAccent)
      ],
    );
  }

  urlToFile(String imageUrl, String filenamee) async {
    if (Uri.parse(imageUrl).isAbsolute == true) {
      try {
        baseBloc.emit(ShowProgressIndicatorState(true));

        http.Response response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          Directory dir = await getApplicationDocumentsDirectory();
          dir.exists();
          String pathName = p.join(dir.path, filenamee);

          print("77575sdd7" + imageUrl);

          File file = new File(pathName);

          print("7757sds5sdd7" + file.path);

          try {
            await file.writeAsBytes(response.bodyBytes);
          } catch (e) {
            print("hdfhjfdhh" + e.toString());
          }

          multiple_selectedImageFile.add(file);

          baseBloc.emit(ShowProgressIndicatorState(false));
        }
      } catch (e) {
        print("775757" + e.toString());
      }

      setState(() {});
    }
  }

  urlVideoToFile(String imageUrl, String filenamee) async {
    if (Uri.parse(imageUrl).isAbsolute == true) {
      http.Response response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        baseBloc.emit(ShowProgressIndicatorState(true));

        Directory dir = await getApplicationDocumentsDirectory();
        dir.exists();
        String pathName = p.join(dir.path, filenamee);
        File file = new File(pathName);
        await file.writeAsBytes(response.bodyBytes);
        MultipleVideoList.add(file);

        baseBloc.emit(ShowProgressIndicatorState(false));
      }

      setState(() {});
    }
  }

  //urlVideoToFile

  Widget uploadVideo(BuildContext context123) {
    return Container(
      child: Column(
        children: <Widget>[
          videofile == null
              ? _isForUpdate //edit mode or not
                  ? Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: VideoURLFromListing.isNotEmpty
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
                                  child: GestureDetector(
                                      onTap: () async {
                                        // If the video is playing, pause it.
                                        final String filePath = videofile.path;
                                        final Uri uri = Uri.file(filePath);
                                      },
                                      child: Container()), //_previewVideo()),
                                ),
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      // padding: const EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: colorGray,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),

                                      child: GestureDetector(
                                        onTap: () {
                                          showCommonDialogWithTwoOptions(
                                              context,
                                              "Are you sure you want to delete this Video ?",
                                              negativeButtonTitle: "No",
                                              positiveButtonTitle: "Yes",
                                              onTapOfPositiveButton: () {
                                            Navigator.of(context).pop();
                                            videofile = null;
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
                      child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Container())), //_previewVideo())),
                ),
          getCommonButton(baseTheme, () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return SafeArea(
                    child: Container(
                      child: new Wrap(
                        children: <Widget>[
                          new ListTile(
                              leading: new Icon(Icons.photo_library),
                              title: new Text('Video Gallery'),
                              onTap: () async {
                                Navigator.of(context).pop();
                                _onImageButtonPressed(ImageSource.gallery,
                                    context: context);
                              }),
                          new ListTile(
                            leading: new Icon(Icons.photo_camera),
                            title: new Text('Camera'),
                            onTap: () async {
                              Navigator.of(context).pop();

                              _onImageButtonPressed(ImageSource.camera,
                                  context: context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }, "Upload Video", backGroundColor: Colors.blueAccent)
        ],
      ),
    );
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext context, bool isMultiImage = false}) async {
    bool ISDuplicate = false;

    XFile file = await picker.pickImage(source: source);

    File file1 = File(file.path);
    final dir = await getTemporaryDirectory();
    final extension = p.extension(file1.path);
    int timestamp1 = DateTime.now().millisecondsSinceEpoch;
    String filenamepunchin =
        _offlineLoggedInData.details[0].employeeID.toString() +
            "_" +
            DateTime.now().day.toString() +
            "_" +
            DateTime.now().month.toString() +
            "_" +
            DateTime.now().year.toString() +
            "_" +
            timestamp1.toString() +
            extension;

    final targetPath = dir.absolute.path + "/" + filenamepunchin;
    File newRenameFile = await File(file1.path).copy(targetPath);
    final bytes = newRenameFile.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    // videofile = file;

    if (mb >= 15) {
      showCommonDialogWithSingleOption(
          context, "Image Size Should not be Greater than 15 MB !",
          positiveButtonTitle: "OK");
    } else {
      // videofile = file;

      if (multiple_selectedImageFile.length != 0) {
        for (int i = 0; i < multiple_selectedImageFile.length; i++) {
          if (file.path == multiple_selectedImageFile[i].path) {
            ISDuplicate = true;
          } else {
            ISDuplicate = false;
          }
        }
      }

      if (ISDuplicate == true) {
        showCommonDialogWithSingleOption(context, "File Is Already Exist !",
            positiveButtonTitle: "OK");
      } else {
        multiple_selectedImageFile.add(File(file.path));
      }

      //  dataList.add(VideoListData("Video ", file.path));

      //  await _playVideo(videofile);
    }

    setState(() {});
  }

  Future<void> _onVideoButtonPressed(ImageSource source,
      {BuildContext context, bool isMultiImage = false}) async {
    bool ISDuplicate = false;

    XFile file = await picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));

    File file1 = File(file.path);
    final dir = await getTemporaryDirectory();
    final extension = p.extension(file1.path);
    int timestamp1 = DateTime.now().millisecondsSinceEpoch;
    String filenamepunchin =
        _offlineLoggedInData.details[0].employeeID.toString() +
            "_" +
            DateTime.now().day.toString() +
            "_" +
            DateTime.now().month.toString() +
            "_" +
            DateTime.now().year.toString() +
            "_" +
            timestamp1.toString() +
            extension;

    final targetPath = dir.absolute.path + "/" + filenamepunchin;
    File newRenameFile = await File(file1.path).copy(targetPath);
    final bytes = newRenameFile.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    //videofile = newRenameFile;

    if (mb >= 15) {
      showCommonDialogWithSingleOption(
          context, "Video Size Should not be Greater than 15 MB !",
          positiveButtonTitle: "OK");
    } else {
      // videofile = newRenameFile;

      if (MultipleVideoList.length != 0) {
        for (int i = 0; i < MultipleVideoList.length; i++) {
          if (file.path == MultipleVideoList[i].path) {
            ISDuplicate = true;
          } else {
            ISDuplicate = false;
          }
        }
      }

      if (ISDuplicate == true) {
        showCommonDialogWithSingleOption(context, "File Is Already Exist !",
            positiveButtonTitle: "OK");
      } else {
        MultipleVideoList.add(File(newRenameFile.path));
      }

      //  dataList.add(VideoListData("Video ", file.path));

      //  await _playVideo(videofile);
    }

    setState(() {});
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
      openAppSettings();
    }

    if (granted == true) {
      // The OS restricts access, for example because of parental controls.
    }
  }

  showcustomdialogSignature({
    BuildContext context1,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          title: Text("Signature"),
          children: [
            Container(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[])),
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget _buildProductSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchProductView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Search Product ",
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
                        controller: _productNameController,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Tap to search product",
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

  Future<void> _onTapOfSearchProductView() async {
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchProductDetails = value;
        _productNameController.text =
            _searchProductDetails.productName.toString();
        _productIDController.text = _searchProductDetails.pkID.toString();
        //_totalAmountController.text = ""
      }
    });
  }

  void _OnComplaintImageUploadSucess(
      AccuraBathComplaintUploadImageCallResponseState state) async {
    if (MultipleVideoList.isNotEmpty) {
      _complaintScreenBloc.add(AccuraBathComplaintUploadVideoAPIRequestEvent(
          MultipleVideoList,
          AccuraBathComplaintUploadVideoAPIRequest(
              CompanyId: CompanyID.toString(),
              pkID: state.complaintUploadImageAPIRequest.pkID,
              ComplaintNo: state.complaintUploadImageAPIRequest.KeyValue,
              Name: MultipleVideoList[0].path.split('/').last,
              Type: "sitevideo",
              LoginUserId: LoginUserID,
              file: MultipleVideoList[0])));
    } else {
      String Msg = _isForUpdate == true
          ? "Complaint With Image Updated Successfully"
          : "Complaint With Image Added Successfully";
      await showCommonDialogWithSingleOption(Globals.context, Msg,
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        navigateTo(context, AccurabathComplaintListScreen.routeName,
            clearAllStack: true);
      });
    }
  }

  void _OnComplaintVideoUploadSucess(
      AccuraBathComplaintUploadVideoCallResponseState state) async {
    String Msg = _isForUpdate == true
        ? "Complaint With Image And Video Updated Successfully"
        : "Complaint With Image And Video Added Successfully";
    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, AccurabathComplaintListScreen.routeName,
          clearAllStack: true);
    });
  }

  void _onGetComplaintImageList(
      AccuraBathComplaintEmployeeListResponseState state) {
    arr_ALL_Name_ID_For_AssignTo.clear();
    for (var i = 0;
        i < state.accuraBathComplaintEmployeeListResponse.details.length;
        i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      all_name_id.Name =
          state.accuraBathComplaintEmployeeListResponse.details[i].customerName;
      all_name_id.pkID =
          state.accuraBathComplaintEmployeeListResponse.details[i].customerID;

      arr_ALL_Name_ID_For_AssignTo.add(all_name_id);
    }
  }

  void getDetailsOfImage(String s, String d) async {
    await urlToFile(s, d.toString());
  }

  void getDetailsOfVideo(String s, String d) async {
    await urlVideoToFile(s, d.toString());
  }

  void _OnImageDeleteResponse(
      AccuraBathComplaintNoToDeleteImageResponseState state) {
    print("ImageSucessDelete" +
        " MSG : " +
        state.complaintNoToDeleteImageResponse.details[0].column2);
  }

  showcustomdialogWithImageSized(
      {List<File> values, BuildContext context1, String lable}) async {
    // bool isVisible = false;
    List<File> Tvalues = [];
    for (int i = 0; i < values.length; i++) {
      final bytes = values[i].readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

      if (mb >= 4) {
        Tvalues.add(values[i]);
      }
    }

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
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: ClipRRect(
                                        child: SizedBox.fromSize(
                                          child: Image.file(
                                            File(Tvalues[index].path),
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        Tvalues[index].path.split('/').last,
                                        style: TextStyle(
                                            color: colorPrimary,
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: Tvalues.length,
                          ),
                        ])),
                    getCommonButton(baseTheme, () {
                      Navigator.of(context1).pop();
                    }, "Close", width: 200)
                  ],
                )),
          ],
        );
      },
    );
  }

  showcustomdialogWithDuplicateImage(
      {List<File> values, BuildContext context1, String lable}) async {
    // bool isVisible = false;
    List<File> Tvalues = [];
    for (int i = 0; i < values.length; i++) {
      final bytes = values[i].readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

      if (mb >= 4) {
        Tvalues.add(values[i]);
      }
    }

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
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: ClipRRect(
                                        child: SizedBox.fromSize(
                                          child: Image.file(
                                            File(Tvalues[index].path),
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        Tvalues[index].path.split('/').last,
                                        style: TextStyle(
                                            color: colorPrimary, fontSize: 12),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: Tvalues.length,
                          ),
                        ])),
                    getCommonButton(baseTheme, () {
                      Navigator.of(context1).pop();
                    }, "Close", width: 200)
                  ],
                )),
          ],
        );
      },
    );
  }
}
