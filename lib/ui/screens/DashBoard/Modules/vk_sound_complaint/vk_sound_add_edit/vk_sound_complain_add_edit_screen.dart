import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/vk_sound_complaint/vk_sound_complaint_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_sound_complaint_save_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_country_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/telecaller_add_edit/company_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/vk_sound_complaint/vk_sound_list/vk_sound_complain_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class VkAddUpdateComplaintScreenArguments {
  VkComplainPkIDtoDetailsResponseState editModel;

  VkAddUpdateComplaintScreenArguments(this.editModel);
}

class VkComplaintAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/VkComplaintAddEditScreen';
  final VkAddUpdateComplaintScreenArguments arguments;

  VkComplaintAddEditScreen(this.arguments);

  @override
  _VkComplaintAddEditScreenState createState() =>
      _VkComplaintAddEditScreenState();
}

/*class JosKeys {
  static final cardA = GlobalKey<ExpansionTileCardState>();
  static final refreshKey  = GlobalKey<RefreshIndicatorState>();
}*/
class _VkComplaintAddEditScreenState extends BaseState<VkComplaintAddEditScreen>
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
  final TextEditingController edt_ComplaintDiscription =
      TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();
  final TextEditingController edt_AssignTo = TextEditingController();
  final TextEditingController edt_AssignToID = TextEditingController();

  final TextEditingController edt_satus = TextEditingController();
  final TextEditingController edt_satusID = TextEditingController();

  final TextEditingController edt_Type = TextEditingController();
  final TextEditingController edt_ComplaintNotes = TextEditingController();
  final TextEditingController edt_FromTime = TextEditingController();
  final TextEditingController edt_ToTime = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadSource = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Type = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_VkStatus = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_Requirment_Details = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_ProjectType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_No_Of_Visit = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  VkComplaintScreenBloc _complaintScreenBloc;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineALLEmployeeListData;

  ALL_EmployeeList_Response _aLLEmployeeListData;

  SearchDetails _searchDetails;

  bool _isForUpdate;
  int CompanyID = 0;
  String LoginUserID = "";
  VkComplainPkIDtoDetailsResponseState _editModel;
  int savepkID = 0;
  String ComplaintNo = "";

  Uint8List data;

  final TextEditingController edt_vkStatus = TextEditingController();

  final TextEditingController edt_vkContactNo = TextEditingController();

  final TextEditingController edt_Address = TextEditingController();

  final TextEditingController edt_QualifiedCountry = TextEditingController();
  final TextEditingController edt_QualifiedCountryCode =
      TextEditingController();

  final TextEditingController edt_QualifiedState = TextEditingController();

  final TextEditingController edt_QualifiedStateCode = TextEditingController();

  final TextEditingController edt_QualifiedCity = TextEditingController();
  final TextEditingController edt_QualifiedCityCode = TextEditingController();
  final TextEditingController edt_Area = TextEditingController();
  final TextEditingController edt_Vk_Pincode = TextEditingController();

//
  SearchCountryDetails _searchCountryDetails;

  double CardViewHieght = 35;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Country = [];
  List<ALL_Name_ID> _listFilteredCountry = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_State = [];
  List<ALL_Name_ID> _listFilteredState = [];

  SearchStateDetails _searchStateDetails;
  SearchCityDetails _searchCityDetails;

  final TextEditingController edt_requirment_specs = TextEditingController();
  final TextEditingController edt_project_type_specs = TextEditingController();

  final TextEditingController edt_technical_details = TextEditingController();
  final TextEditingController edt_mark_area_length = TextEditingController();
  final TextEditingController edt_mark_area_width = TextEditingController();

  final TextEditingController edt_Ceiling_Height = TextEditingController();
  final TextEditingController edt_Tentative_Budget = TextEditingController();

  final TextEditingController edt_VisitDate = TextEditingController();
  final TextEditingController edt_VisitDate_Reverse = TextEditingController();
  final TextEditingController edt_Contact_Person = TextEditingController();
  final TextEditingController edt_Designation = TextEditingController();
  final TextEditingController edt_MetWithHis = TextEditingController();
  final TextEditingController edt_Contact_Number = TextEditingController();

  //edt_Contact_Person edt_Designation

  DateTime selectedDateFromComplaintDate = DateTime.now();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Site_in_change = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Visited_Person = [];

  final TextEditingController edt_SiteInChargeEmpName = TextEditingController();
  final TextEditingController edt_SiteInChargeEmpID = TextEditingController();
  final TextEditingController edt_VistedPersonEmpName = TextEditingController();
  final TextEditingController edt_VistedPersonEmpID = TextEditingController();

  final TextEditingController edt_Requirment = TextEditingController();
  final TextEditingController edt_ProjectType = TextEditingController();
  final TextEditingController edt_No_Of_Visit = TextEditingController();

  //edt_Requirment edt_ProjectType edt_No_Of_Visit

  bool Step1 = false;
  bool Step2 = false;
  bool Step3 = false;
  bool Step4 = false;
  bool Step5 = false;
  bool Step6 = false;
  bool Step7 = false;

  @override
  void initState() {
    super.initState();

    edt_ComplanitID.text = "";
    edt_ReverseComplanitDate.text = "";
    edt_vkStatus.text = "";
    edt_CustomerID.text = "";
    edt_CustomerName.text = "";
    edt_vkContactNo.text = "";
    edt_Address.text = "";
    edt_QualifiedCityCode.text = "";
    edt_QualifiedStateCode.text = "";
    edt_QualifiedCountryCode.text = "";
    edt_ReverseSheduleDate.text = "";
    edt_Type.text = "";
    edt_ComplaintNotes.text = "";
    edt_requirment_specs.text = "";
    edt_project_type_specs.text = "";
    edt_technical_details.text = "";
    edt_mark_area_length.text = "0.00";
    edt_mark_area_width.text = "0.00";
    edt_Ceiling_Height.text = "0.00";
    edt_Tentative_Budget.text = "0.00";
    edt_VisitDate_Reverse.text = "";
    edt_Contact_Person.text = "";
    edt_Designation.text = "";
    edt_FromTime.text = "";
    edt_SiteInChargeEmpName.text = "";
    edt_VistedPersonEmpName.text = "";
    edt_Requirment.text = "";
    edt_ProjectType.text = "";
    edt_No_Of_Visit.text = "";
    edt_AssignToID.text = "";
    edt_MetWithHis.text = "";
    edt_Contact_Number.text = "";
    edt_ToTime.text = "";
    edt_Vk_Pincode.text = "";

    _complaintScreenBloc = VkComplaintScreenBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _aLLEmployeeListData = SharedPrefHelper.instance.getALLEmployeeList();

    FetchAllEmployeeList_Site_in_change(_aLLEmployeeListData);

    FetchAllEmployeeList_Visited_Person(_aLLEmployeeListData);
    FetchAssignTODetails(_offlineALLEmployeeListData);
    FetchTypeDetails();
    VkComplaintStatus();

    RequirmentDetialsMethod();
    ProjectTypeMethod();
    NumberOfVisitMethod();
    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
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

      /* TimeOfDay selectedTime123 = TimeOfDay.now();
      TimeOfDay newTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));*/ /*selectedTime123.replacing(
          hour: selectedTime123.hour +2,
          minute: selectedTime123.minute
      );*/ /*

      String AM_PM1 = newTime.periodOffset.toString() == "12" ? "AM" : "PM";
      edt_ToTime.text = newTime.hour.toString() +
          ":" +
          newTime.minute.toString() +
          " " +
          AM_PM1; //picked_s.periodOffset.toString();*/
      edt_QualifiedCountry.text = "India";
      edt_QualifiedCountryCode.text = "IND";

      _searchCountryDetails = SearchCountryDetails();
      _searchCountryDetails.countryCode = "IND";
      _searchCountryDetails.countryName = "India";

      _searchStateDetails = SearchStateDetails();

      print("ljsfj" +
          " StateCode : " +
          _offlineLoggedInData.details[0].stateCode.toString());
      _searchStateDetails.value = _offlineLoggedInData.details[0].stateCode;
      _searchStateDetails.label = _offlineLoggedInData.details[0].StateName;

      edt_QualifiedState.text = _offlineLoggedInData.details[0].StateName;
      edt_QualifiedStateCode.text =
          _offlineLoggedInData.details[0].stateCode.toString();

      _searchCityDetails = SearchCityDetails();
      _searchCityDetails.cityCode = _offlineLoggedInData.details[0].CityCode;
      _searchCityDetails.cityName = _offlineLoggedInData.details[0].CityName;

      edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
      edt_QualifiedCityCode.text =
          _offlineLoggedInData.details[0].CityCode.toString();
      setState(() {});
    }
  }

  ///listener to multiple states of bloc to handles api responses
  ///use only BlocListener if only need to listen to events
/*
  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerPaginationListScreenBloc, CustomerPaginationListScreenStates>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, CustomerPaginationListScreenStates state) {
        if (state is CustomerPaginationListScreenResponseState) {
          _onCustomerPaginationListScreenCallSuccess(state.response);
        }
      },
      child: super.build(context),
    );
  }
*/

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _complaintScreenBloc,
      child: BlocConsumer<VkComplaintScreenBloc, VkComplaintScreenStates>(
        builder: (BuildContext context, VkComplaintScreenStates state) {
          /* if (state is ComplaintListResponseState) {
            _onGetListCallSuccess(state);
          }
          if (state is ComplaintSearchByIDResponseState) {
            _onSearchByIDCallSuccess(state);
          }*/

          if (state is CountryListEventResponseState) {
            _onCountryListSuccess(state);
          }

          if (state is StateListEventResponseState) {
            _onStateListSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CountryListEventResponseState ||
              currentState is StateListEventResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, VkComplaintScreenStates state) {
          if (state is VkComplaintSaveResponseState) {
            ComplaintSaveSucessResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is VkComplaintSaveResponseState) {
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
          title: Text('Technical Site Visit'),
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
                        Steps1(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Steps2(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Steps3(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Steps4(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Steps5(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Steps6(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Steps7(),
                        OldDetails(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            _onTapOfSaveComplaintDetails();
                          },
                          child: Card(
                              elevation: 10,
                              color: colorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Center(
                                  child: Text("Save",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ),
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
      margin: EdgeInsets.only(top: 10, bottom: 10),
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

  Widget VkStatusDropDown(String Category,
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
                values: arr_ALL_Name_ID_For_VkStatus,
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

  Widget RequirementDetailsDropDown(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_Requirment_Details,
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

  Widget NumberOfVisitDropDown(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_No_Of_Visit,
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

  Widget ProjectTypeDropDown(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_ProjectType,
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
              /* Icon(
                Icons.filter_list_alt,
                color: colorPrimary,
              ),*/
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
                      controller: edt_AssignTo,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
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

  Widget _buildEmplyeeSiteInCharge() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        //edt_SiteInChargeEmpName edt_SiteInChargeEmpID

        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_Site_in_change,
            context1: context,
            controller: edt_SiteInChargeEmpName,
            controllerID: edt_SiteInChargeEmpID,
            lable: "Select Site In Charge");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Site In Charge",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              /* Icon(
                Icons.filter_list_alt,
                color: colorPrimary,
              ),*/
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
                      controller: edt_SiteInChargeEmpName,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
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
                          hintText: "Site In Charge"),
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

  Widget _buildEmplyeeVisitedPerson() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        //edt_SiteInChargeEmpName edt_SiteInChargeEmpID

        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_Visited_Person,
            context1: context,
            controller: edt_VistedPersonEmpName,
            controllerID: edt_VistedPersonEmpID,
            lable: "Select Visited Person");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Visited Person",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              /* Icon(
                Icons.filter_list_alt,
                color: colorPrimary,
              ),*/
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
                      controller: edt_VistedPersonEmpName,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
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
                          hintText: "Visited Person"),
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
        initialDate: selectedDateFromComplaintDate,
        firstDate: selectedDateFromComplaintDate,
        /* initialDate: selectedDate,
        firstDate: selectedDate,*/
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
        _selectDate(context, edt_ComplanitDate);
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

  Widget _buildVisitDate() {
    //edt_VisitDate edt_VisitDate_Reverse
    return InkWell(
      onTap: () {
        _selectVisitDate(context, edt_VisitDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Visit Date",
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

  Widget ContactNumber() {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Contact No",
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
                          keyboardType: TextInputType.phone,
                          controller: edt_vkContactNo,
                          decoration: InputDecoration(
                            hintText: "Enter Contact Number",
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

                          )),
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
        selectedDateFromComplaintDate = selectedDate;
      });
  }

  Future<void> _selectVisitDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateFromComplaintDate,
        firstDate: selectedDateFromComplaintDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_VisitDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_VisitDate_Reverse.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
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
      /*navigateTo(context, SearchComplaintCustomerScreen.routeName)
          .then((value) {
        if (value != null) {
          _searchDetails = value;
          edt_CustomerID.text = _searchDetails.value.toString();
          edt_CustomerName.text = _searchDetails.label.toString();

          */ /*  _FollowupBloc.add(SearchBankVoucherCustomerListByNameCallEvent(
              CustomerLabelValueRequest(
                  CompanyId: CompanyID.toString(),
                  LoginUserID: "admin",
                  word: _searchDetails.value.toString())));*/ /*
        }
        print("CustomerInfo : " +
            edt_CustomerName.text.toString() +
            " CustomerID : " +
            edt_CustomerID.text.toString());
      });*/
      navigateTo(context, SearchCompanyScreen.routeName,
              arguments: SearchCompanyScreenArguments(edt_CustomerName.text))
          .then((value) {
        setState(() {
          if (value != null) {
            ALL_Name_ID searchDetails123 = new ALL_Name_ID();
            searchDetails123 = value;
            edt_CustomerName.text = searchDetails123.Name.toString();
            //edt_PrimaryContact.text = searchDetails123.Name1.toString();
            edt_CustomerID.text =
                searchDetails123.pkID == 0 || searchDetails123.pkID == null
                    ? "0"
                    : searchDetails123.pkID.toString();

            if (searchDetails123.CountryName != "") {
              edt_QualifiedCountry.text = searchDetails123.CountryCode;
              edt_QualifiedCountry.text = searchDetails123.CountryName;
              _searchCountryDetails = SearchCountryDetails();
              _searchCountryDetails.countryCode = searchDetails123.CountryCode;
              _searchCountryDetails.countryName = searchDetails123.CountryName;
            } else {
              edt_QualifiedCountry.text = "India";
              edt_QualifiedCountryCode.text = "IND";

              _searchCountryDetails = SearchCountryDetails();
              _searchCountryDetails.countryCode = "IND";
              _searchCountryDetails.countryName = "India";
            }

            if (searchDetails123.StateName != "") {
              edt_QualifiedState.text = searchDetails123.StateName;
              edt_QualifiedStateCode.text = searchDetails123.StateCode;

              _searchStateDetails = SearchStateDetails();
              _searchStateDetails.value = int.parse(searchDetails123.StateCode);
              _searchStateDetails.label = searchDetails123.StateName;
            } else {
              _searchStateDetails = SearchStateDetails();
              _searchStateDetails.value =
                  _offlineLoggedInData.details[0].stateCode;
              _searchStateDetails.label =
                  _offlineLoggedInData.details[0].StateName;

              edt_QualifiedState.text =
                  _offlineLoggedInData.details[0].StateName;
              edt_QualifiedStateCode.text =
                  _offlineLoggedInData.details[0].stateCode.toString();
            }

            if (searchDetails123.CityName != "") {
              edt_QualifiedCity.text = searchDetails123.CityName;
              edt_QualifiedCityCode.text = searchDetails123.CityCode;
              _searchCityDetails = SearchCityDetails();
              _searchCityDetails.cityCode =
                  int.parse(searchDetails123.CityCode);
              _searchCityDetails.cityName = searchDetails123.CityName;
            } else {
              _searchCityDetails = SearchCityDetails();
              _searchCityDetails.cityCode =
                  _offlineLoggedInData.details[0].CityCode;
              _searchCityDetails.cityName =
                  _offlineLoggedInData.details[0].CityName;

              edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
              edt_QualifiedCityCode.text =
                  _offlineLoggedInData.details[0].CityCode.toString();
            }

            if (edt_CustomerID.text == "0") {
              edt_QualifiedCountry.text = "India";
              edt_QualifiedCountryCode.text = "IND";

              _searchCountryDetails = SearchCountryDetails();
              _searchCountryDetails.countryCode = "IND";
              _searchCountryDetails.countryName = "India";

              _searchStateDetails = SearchStateDetails();
              _searchStateDetails.value =
                  _offlineLoggedInData.details[0].stateCode;
              _searchStateDetails.label =
                  _offlineLoggedInData.details[0].StateName;

              edt_QualifiedState.text =
                  _offlineLoggedInData.details[0].StateName;
              edt_QualifiedStateCode.text =
                  _offlineLoggedInData.details[0].stateCode.toString();

              _searchCityDetails = SearchCityDetails();
              _searchCityDetails.cityCode =
                  _offlineLoggedInData.details[0].CityCode;
              _searchCityDetails.cityName =
                  _offlineLoggedInData.details[0].CityName;

              edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
              edt_QualifiedCityCode.text =
                  _offlineLoggedInData.details[0].CityCode.toString();
            }

            //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));
          }
        });
      });
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, VkSoundComplaintPaginationListScreen.routeName,
        clearAllStack: true);
  }

  FetchAssignTODetails(
      FollowerEmployeeListResponse offlineALLEmployeeListData) {
    arr_ALL_Name_ID_For_AssignTo.clear();
    for (var i = 0; i < offlineALLEmployeeListData.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      all_name_id.Name = offlineALLEmployeeListData.details[i].employeeName;
      all_name_id.pkID = offlineALLEmployeeListData.details[i].pkID;

      arr_ALL_Name_ID_For_AssignTo.add(all_name_id);
    }
  }

  void fillData() {
    if (_editModel.response.details.isEmpty) {
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
      edt_ComplanitDate.text = _editModel.response.details[0].complaintDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseComplanitDate.text =
          _editModel.response.details[0].complaintDate.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

      _onpkIDtoDetailsAPIResponse(_editModel);
    }
    /*if (_editModel.preferredDate == "") {
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
    }*/
    savepkID = _editModel.response.details[0].pkID.toInt();
    /* edt_CustomerName.text = _editModel.customerName;
    edt_CustomerID.text = _editModel.customerID.toString();
    edt_Referene.text = _editModel.referenceNo;
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

    //selectedInTime =

    edt_AssignTo.text = _editModel.employeeName;
    edt_AssignToID.text = _editModel.employeeID.toString();
    edt_satus.text =
        _editModel.complaintStatus == "0" ? "" : _editModel.complaintStatus;
    edt_Type.text = _editModel.complaintType;
    edt_ComplanitID.text = _editModel.complaintNo;*/

    /*_complaintScreenBloc.add(VkComplaintpkIDtoDetailsRequestEvent(
        savepkID,
        VkComplaintpkIDtoDetailsRequest(
            pkID: savepkID.toString(), CompanyId: CompanyID.toString())));*/
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

  VkComplaintStatus() {
    //arr_ALL_Name_ID_For_VkStatus
    arr_ALL_Name_ID_For_VkStatus.clear();
    for (var i = 0; i <= 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Open";
      } else if (i == 1) {
        all_name_id.Name = "Closed";
      }
      arr_ALL_Name_ID_For_VkStatus.add(all_name_id);
    }
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
            onTap: () =>
                _onTapOfSearchCountryView(_searchCountryDetails.countryCode),
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
          onTap: () => _onTapOfSearchStateView(edt_QualifiedCountryCode.text),
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
          onTap: () =>
              _onTapOfSearchCityView(_searchStateDetails.value.toString()),
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

  Widget Area() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Area",
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
                      controller: edt_Area,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "Tap to enter Area",
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
                  Icons.house,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onTapOfSearchCountryView(String sw) async {
    navigateTo(context, SearchCountryScreen.routeName,
            arguments: CountryArguments(sw))
        .then((value) {
      if (value != null) {
        _searchCountryDetails = SearchCountryDetails();
        _searchCountryDetails = value;
        print("CountryName IS From SearchList" +
            _searchCountryDetails.countryCode);
        edt_QualifiedCountryCode.text = _searchCountryDetails.countryCode;
        edt_QualifiedCountry.text = _searchCountryDetails.countryName;
        _complaintScreenBloc.add(CountryCallEvent(CountryListRequest(
            CountryCode: sw, CompanyID: CompanyID.toString())));
      }
    });
  }

  Future<void> _onTapOfSearchStateView(String sw1) async {
    print("sdlfdjf" + sw1.toString());
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

  _onTapOfSearchCityView(String talukaCode) async {
    navigateTo(context, SearchCityScreen.routeName,
            arguments: CityArguments(talukaCode))
        .then((value) {
      if (value != null) {
        setState(() {
          _searchCityDetails = value;

          print("CityCodesdsf" +
              " CityCode : " +
              _searchCityDetails.cityCode.toString());
          edt_QualifiedCityCode.text = _searchCityDetails.cityCode.toString();
          edt_QualifiedCity.text = _searchCityDetails.cityName.toString();
        });
      }
    });
  }

  void FetchAllEmployeeList_Site_in_change(
      ALL_EmployeeList_Response aLLEmployeeListData) {
    //arr_ALL_Name_ID_For_Site_in_change arr_ALL_Name_ID_For_Visited_Person
    arr_ALL_Name_ID_For_Site_in_change.clear();

    for (var i = 0; i < aLLEmployeeListData.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      all_name_id.Name = aLLEmployeeListData.details[i].employeeName;
      all_name_id.pkID = aLLEmployeeListData.details[i].pkID;

      arr_ALL_Name_ID_For_Site_in_change.add(all_name_id);
    }
  }

  void FetchAllEmployeeList_Visited_Person(
      ALL_EmployeeList_Response aLLEmployeeListData) {
    //arr_ALL_Name_ID_For_Site_in_change arr_ALL_Name_ID_For_Visited_Person
    arr_ALL_Name_ID_For_Visited_Person.clear();

    for (var i = 0; i < aLLEmployeeListData.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      all_name_id.Name = aLLEmployeeListData.details[i].employeeName;
      all_name_id.pkID = aLLEmployeeListData.details[i].pkID;

      arr_ALL_Name_ID_For_Visited_Person.add(all_name_id);
    }
  }

  RequirmentDetialsMethod() {
    //arr_ALL_Name_ID_For_VkStatus
    arr_ALL_Name_ID_Requirment_Details.clear();
    for (var i = 0; i <= 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Home Theatre";
      } else if (i == 1) {
        all_name_id.Name = "Living Room Cinema";
      } else if (i == 2) {
        all_name_id.Name = "Conference Room";
      } else if (i == 3) {
        all_name_id.Name = "Auditorium";
      } else if (i == 4) {
        all_name_id.Name = "Chanel Music";
      }
      arr_ALL_Name_ID_Requirment_Details.add(all_name_id);
    }
  }

  ProjectTypeMethod() {
    //arr_ALL_Name_ID_For_VkStatus
    arr_ALL_Name_ID_ProjectType.clear();
    for (var i = 0; i <= 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Individual Bungalow";
      } else if (i == 1) {
        all_name_id.Name = "Commercial Office Space";
      } else if (i == 2) {
        all_name_id.Name = "Commercial Shopping Center";
      } else if (i == 3) {
        all_name_id.Name = "Industrial";
      }
      arr_ALL_Name_ID_ProjectType.add(all_name_id);
    }
  }

  NumberOfVisitMethod() {
    //arr_ALL_Name_ID_For_VkStatus
    arr_ALL_Name_ID_No_Of_Visit.clear();
    for (var i = 0; i <= 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "1st";
      } else if (i == 1) {
        all_name_id.Name = "2nd";
      } else if (i == 2) {
        all_name_id.Name = "3rd";
      } else if (i == 3) {
        all_name_id.Name = "4th";
      }
      arr_ALL_Name_ID_No_Of_Visit.add(all_name_id);
    }
  }

  Widget Steps1() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Step1 = !Step1;
                  Step2 = false;
                  Step3 = false;
                  Step4 = false;
                  Step5 = false;
                  Step6 = false;
                  Step7 = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Step - 1",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Step1 == true
                        ? Icon(Icons.arrow_circle_up_rounded,
                            color: colorPrimary)
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: colorPrimary,
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: Step1,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isForUpdate == false
                        ? TextFormField(
                            controller: edt_ComplanitID,
                            enabled: false,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Complaint No #',
                                hintText: "Complaint Number"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            ))
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _selectDate(context, edt_ComplanitDate);
                            },
                            child: TextFormField(
                                controller: edt_ComplanitDate,
                                enabled: false,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Complaint Date *',
                                    hintText: "DD-MM-YYYY"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            // isAllEditable == true ? _onTapOfSearchView() : Container();

                            showcustomdialogWithOnlyName(
                                values: arr_ALL_Name_ID_For_VkStatus,
                                context1: context,
                                controller: edt_vkStatus,
                                lable: "Select Status");
                          },
                          child: Container(
                            child: TextFormField(
                                controller: edt_vkStatus,
                                enabled: false,
                                decoration: const InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.arrow_drop_down_sharp),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Status',
                                    hintText: "Select Status"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _onTapOfBankACSearchView();
                      },
                      child: TextFormField(
                          controller: edt_CustomerName,
                          enabled: false,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Customer Name *',
                              hintText: "Tap to select Name"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: edt_vkContactNo,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Contact #1 *',
                            hintText: "Contact Number"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _selectNextFollowupDate(context, edt_SheduleDate);
                            },
                            child: TextFormField(
                                controller: edt_SheduleDate,
                                enabled: false,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Schedule Date *',
                                    hintText: "DD-MM-YYYY"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            // isAllEditable == true ? _onTapOfSearchView() : Container();

                            showcustomdialogWithOnlyName(
                                values: arr_ALL_Name_ID_For_Type,
                                context1: context,
                                controller: edt_Type,
                                lable: "Select Type");
                          },
                          child: Container(
                            child: TextFormField(
                                controller: edt_Type,
                                enabled: false,
                                decoration: const InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.arrow_drop_down_sharp),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Type',
                                    hintText: "Select Type"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Step2 = !Step2;
                          Step1 = false;
                          Step3 = false;
                          Step4 = false;
                          Step5 = false;
                          Step6 = false;
                          Step7 = false;
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget Steps2() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Step2 = !Step2;
                  Step1 = false;
                  Step3 = false;
                  Step4 = false;
                  Step5 = false;
                  Step6 = false;
                  Step7 = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Step - 2",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Step2 == true
                        ? Icon(Icons.arrow_circle_up_rounded,
                            color: colorPrimary)
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: colorPrimary,
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: Step2,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Address",
                          style: TextStyle(
                              fontSize: 12,
                              color: colorPrimary,
                              fontWeight: FontWeight
                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                          ),
                    ),
                    TextFormField(
                      minLines: 3,
                      maxLines: null,
                      controller: edt_Address,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Enter Address',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: colorPrimary),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: false,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_Area,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.area_chart),
                                border: UnderlineInputBorder(),
                                labelText: 'Area',
                                hintText: "Enter Area"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        _isForUpdate == true
                            ? Container()
                            : _onTapOfSearchCountryView(
                                _searchCountryDetails.countryCode);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_QualifiedCountry,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.location_city),
                                border: UnderlineInputBorder(),
                                labelText: 'Country',
                                hintText: "Select Country"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        print("Stajks" +
                            " StateCode : " +
                            edt_QualifiedCountryCode.text.toString());
                        _isForUpdate == true
                            ? Container()
                            : _onTapOfSearchStateView(
                                _searchCountryDetails.countryCode);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_QualifiedState,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.location_city),
                                border: UnderlineInputBorder(),
                                labelText: 'State',
                                hintText: "Select State"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        _isForUpdate == true
                            ? Container()
                            : _onTapOfSearchCityView(
                                _searchStateDetails.value.toString());
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_QualifiedCity,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.location_city),
                                border: UnderlineInputBorder(),
                                labelText: 'City',
                                hintText: "Select City"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                          controller: edt_Vk_Pincode,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.pin_drop),
                              border: UnderlineInputBorder(),
                              labelText: 'Pin-Code',
                              hintText: "Enter Pin-Code"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Step3 = !Step3;
                          Step1 = false;
                          Step2 = false;
                          Step4 = false;
                          Step5 = false;
                          Step6 = false;
                          Step7 = false;
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget Steps3() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Step3 = !Step3;
                  Step1 = false;
                  Step2 = false;
                  Step4 = false;
                  Step5 = false;
                  Step6 = false;
                  Step7 = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Step - 3",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Step3 == true
                        ? Icon(Icons.arrow_circle_up_rounded,
                            color: colorPrimary)
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: colorPrimary,
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: Step3,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Requirement Specs",
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
                        controller: edt_requirment_specs,
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Enter Specs',
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
                      child: Text("Project Type Specs",
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
                        controller: edt_project_type_specs,
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Enter Project Type Specs',
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          Step4 = !Step4;
                          Step1 = false;
                          Step2 = false;
                          Step3 = false;
                          Step5 = false;
                          Step6 = false;
                          Step7 = false;
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget Steps4() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Step4 = !Step4;
                  Step2 = false;
                  Step3 = false;
                  Step1 = false;
                  Step5 = false;
                  Step6 = false;
                  Step7 = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Step - 4",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Step4 == true
                        ? Icon(Icons.arrow_circle_up_rounded,
                            color: colorPrimary)
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: colorPrimary,
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: Step4,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: edt_technical_details,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Technical Details',
                            hintText: "Enter Details"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onTap: () => {
                                    edt_mark_area_length.selection =
                                        TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          edt_mark_area_length.text.length,
                                    )
                                  },
                              controller: edt_mark_area_length,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Marked Area Length',
                                  hintText: "0.00"),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onTap: () => {
                                    edt_mark_area_width.selection =
                                        TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          edt_mark_area_width.text.length,
                                    )
                                  },
                              controller: edt_mark_area_width,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Marked Area Width',
                                  hintText: "0.00"),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              controller: edt_Ceiling_Height,
                              onTap: () => {
                                    edt_Ceiling_Height.selection =
                                        TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          edt_Ceiling_Height.text.length,
                                    )
                                  },
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Ceiling Height',
                                  hintText: "0.00"),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onTap: () => {
                                    edt_Tentative_Budget.selection =
                                        TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          edt_Tentative_Budget.text.length,
                                    )
                                  },
                              controller: edt_Tentative_Budget,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Tentative Budget',
                                  hintText: "0.00"),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _selectVisitDate(context, edt_VisitDate);
                      },
                      child: TextFormField(
                          controller: edt_VisitDate,
                          enabled: false,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Visited Date *',
                              hintText: "DD-MM-YYYY"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Step5 = !Step5;
                          Step1 = false;
                          Step3 = false;
                          Step4 = false;
                          Step2 = false;
                          Step6 = false;
                          Step7 = false;
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget Steps5() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Step5 = !Step5;
                  Step2 = false;
                  Step3 = false;
                  Step1 = false;
                  Step4 = false;
                  Step6 = false;
                  Step7 = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Step - 5",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Step5 == true
                        ? Icon(Icons.arrow_circle_up_rounded,
                            color: colorPrimary)
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: colorPrimary,
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: Step5,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: edt_Contact_Person,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Contact Person',
                            hintText: "Enter Details"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: edt_Designation,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Designation',
                            hintText: "Enter Designation"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _selectFromTime(context, edt_FromTime);
                            },
                            child: TextFormField(
                                controller: edt_FromTime,
                                enabled: false,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Time In',
                                    hintText: "hh:mm"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _selectToTime(context, edt_ToTime);
                            },
                            child: TextFormField(
                                controller: edt_ToTime,
                                enabled: false,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Time Out',
                                    hintText: "hh:mm"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Step6 = !Step6;
                          Step1 = false;
                          Step3 = false;
                          Step4 = false;
                          Step2 = false;
                          Step5 = false;
                          Step7 = false;
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget Steps6() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Step6 = !Step6;
                  Step2 = false;
                  Step3 = false;
                  Step4 = false;
                  Step5 = false;
                  Step1 = false;
                  Step7 = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Step - 6",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Step6 == true
                        ? Icon(Icons.arrow_circle_up_rounded,
                            color: colorPrimary)
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: colorPrimary,
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: Step6,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        showcustomdialogWithID(
                            values: arr_ALL_Name_ID_For_Site_in_change,
                            context1: context,
                            controller: edt_SiteInChargeEmpName,
                            controllerID: edt_SiteInChargeEmpID,
                            lable: "Select Site In Charge");
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_SiteInChargeEmpName,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Site In Charge',
                                hintText: "Tap To Select"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showcustomdialogWithID(
                            values: arr_ALL_Name_ID_For_Visited_Person,
                            context1: context,
                            controller: edt_VistedPersonEmpName,
                            controllerID: edt_VistedPersonEmpID,
                            lable: "Select Visited Person");
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_VistedPersonEmpName,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Visited Person',
                                hintText: "Tap To Select"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showcustomdialogWithOnlyName(
                            values: arr_ALL_Name_ID_Requirment_Details,
                            context1: context,
                            controller: edt_Requirment,
                            lable: "Select Details");
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_Requirment,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Requirement Details',
                                hintText: "Tap To Select"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showcustomdialogWithOnlyName(
                            values: arr_ALL_Name_ID_ProjectType,
                            context1: context,
                            controller: edt_ProjectType,
                            lable: "Select Project Type");
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_ProjectType,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Project Type',
                                hintText: "Tap To Select"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showcustomdialogWithOnlyName(
                            values: arr_ALL_Name_ID_No_Of_Visit,
                            context1: context,
                            controller: edt_No_Of_Visit,
                            lable: "Select No. Of Visit");
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_No_Of_Visit,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'No. Of Visit',
                                hintText: "Tap To Select"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Step2 = false;
                          Step1 = false;
                          Step3 = false;
                          Step4 = false;
                          Step5 = false;
                          Step6 = false;
                          Step7 = !Step7;
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Steps7() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Step7 = !Step7;
                  Step2 = false;
                  Step3 = false;
                  Step4 = false;
                  Step5 = false;
                  Step6 = false;
                  Step1 = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Step - 7",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Step7 == true
                        ? Icon(Icons.arrow_circle_up_rounded,
                            color: colorPrimary)
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: colorPrimary,
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: Step7,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        showcustomdialogWithID(
                            values: arr_ALL_Name_ID_For_AssignTo,
                            context1: context,
                            controller: edt_AssignTo,
                            controllerID: edt_AssignToID,
                            lable: "Select AssignTo");
                      },
                      child: Container(
                        child: TextFormField(
                            controller: edt_AssignTo,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'AssignTo *',
                                hintText: "Tap To Select"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: edt_MetWithHis,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Met With & His...',
                            hintText: "Enter Name"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        )),
                    SizedBox(height: 10),
                    TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: edt_Contact_Number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Contact Number',
                            hintText: "Enter Number"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Step2 = false;
                          Step1 = false;
                          Step3 = false;
                          Step4 = false;
                          Step5 = false;
                          Step6 = false;
                          Step7 = false;
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  OldDetails() {
    return Visibility(
        visible: false,
        child: Column(
          children: [
            _isForUpdate == true ? _buildComplaintNo() : Container(),
            SizedBox(
              width: 20,
              height: 15,
            ),
            _buildFollowupDate(),
            VkStatusDropDown("Status",
                enable1: false,
                title: "Status",
                hintTextvalue: "Tap to Select Status",
                icon: Icon(Icons.arrow_drop_down),
                controllerForLeft: edt_vkStatus,
                Custom_values1: arr_ALL_Name_ID_For_VkStatus),
            _buildBankACSearchView(),
            SizedBox(
              width: 20,
              height: 10,
            ),
            ContactNumber(),
            SizedBox(
              width: 20,
              height: 10,
            ),
            _buildNextFollowupDate(),
            SizedBox(
              width: 20,
              height: 15,
            ),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Area()),
                Expanded(child: QualifiedCity()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: QualifiedState()),
                Expanded(child: QualifiedCountry()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: false,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("Reference #",
                    style: TextStyle(
                        fontSize: 12,
                        color: colorPrimary,
                        fontWeight: FontWeight
                            .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),
              ),
            ),
            Visibility(
              visible: false,
              child: Padding(
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
              ),
            ),
            SizedBox(
              width: 20,
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Technical Details",
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
                controller: edt_technical_details,
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Enter Technical Details',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Marked Area Length",
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
                          controller: edt_mark_area_length,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '0.00',
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Marked Area Width",
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
                          controller: edt_mark_area_width,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '0.00',
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
              ],
            ),
            SizedBox(
              width: 20,
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Ceiling Height",
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
                          controller: edt_Ceiling_Height,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '0.00',
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Tentative Budget",
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
                          controller: edt_Tentative_Budget,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '0.00',
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
              ],
            ),
            SizedBox(
              width: 20,
              height: 15,
            ),
            _buildVisitDate(),
            SizedBox(
              width: 20,
              height: 15,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Contact Person",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),

            // //edt_Contact_Person edt_Designation
            Padding(
              padding: EdgeInsets.only(left: 7, right: 7, top: 10),
              child: TextFormField(
                controller: edt_Contact_Person,
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Enter Contact Person',
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
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Designation",
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
                controller: edt_Designation,
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Enter Designation',
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
              child: Row(
                children: [
                  Expanded(
                    child: Text("Time In",
                        style: TextStyle(
                            fontSize: 12,
                            color: colorPrimary,
                            fontWeight: FontWeight
                                .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                        ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text("Time Out",
                        style: TextStyle(
                            fontSize: 12,
                            color: colorPrimary,
                            fontWeight: FontWeight
                                .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                        ),
                  ),
                ],
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

            _buildEmplyeeSiteInCharge(),
            SizedBox(
              width: 20,
              height: 15,
            ),
            _buildEmplyeeVisitedPerson(),

            //edt_Requirment edt_ProjectType edt_No_Of_Visit

            RequirementDetailsDropDown("Requirement Details",
                enable1: false,
                title: "Requirement Details",
                hintTextvalue: "Tap to Select Requirement",
                icon: Icon(Icons.arrow_drop_down),
                controllerForLeft: edt_Requirment,
                Custom_values1: arr_ALL_Name_ID_Requirment_Details),

            ProjectTypeDropDown("Project Type",
                enable1: false,
                title: "Project Type",
                hintTextvalue: "Tap to Project Type",
                icon: Icon(Icons.arrow_drop_down),
                controllerForLeft: edt_ProjectType,
                Custom_values1: arr_ALL_Name_ID_ProjectType),

            NumberOfVisitDropDown("No Of Visit",
                enable1: false,
                title: "No Of Visit",
                hintTextvalue: "Tap to No Of Visit",
                icon: Icon(Icons.arrow_drop_down),
                controllerForLeft: edt_No_Of_Visit,
                Custom_values1: arr_ALL_Name_ID_No_Of_Visit),
            SizedBox(
              width: 20,
              height: 10,
            ),
            _buildEmplyeeListView(),
            SizedBox(
              width: 20,
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Met With & His...",
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
                controller: edt_MetWithHis,
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ),
            ),
            SizedBox(
              width: 20,
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Contact Number",
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
                controller: edt_Contact_Number,
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Enter Number',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ),
            ),

            SizedBox(
              width: 20,
              height: 10,
            ),
          ],
        ));
  }

  void _onTapOfSaveComplaintDetails() {
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
        edt_vkStatus.text +
        " StatusID : " +
        edt_satusID.text +
        " Type : " +
        edt_Type.text +
        "");

    if (edt_CustomerName.text != "") {
      if (edt_ComplaintNotes.text != "") {
        if (edt_SheduleDate.text != "") {
          if (edt_AssignTo.text != "") {
            showCommonDialogWithTwoOptions(context,
                "Are you sure you want to Save this Complaint Details ?",
                negativeButtonTitle: "No",
                positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
              _complaintScreenBloc.add(VkComplaintSaveRequestEvent(
                  savepkID,
                  VkComplaintSaveRequest(
                    pkID: savepkID.toString(),
                    ComplaintNo: edt_ComplanitID.text.toString(),
                    ComplaintDate: edt_ReverseComplanitDate.text.toString(),
                    ComplaintStatus: edt_vkStatus.text.toString(),
                    CustomerID: edt_CustomerID.text.toString(),
                    CustomerName: edt_CustomerName.text.toString(),
                    CustmoreMobileNo: edt_vkContactNo.text.toString(),
                    SiteAddress: edt_Address.text.toString(),
                    CityCode: edt_QualifiedCityCode.text.toString(),
                    StateCode: edt_QualifiedStateCode.text.toString(),
                    CountryCode: edt_QualifiedCountryCode.text.toString(),
                    Pincode: edt_Vk_Pincode.text.toString(),
                    ScheduleDate: edt_ReverseSheduleDate.text.toString(),
                    ComplaintType: edt_Type.text.toString(),
                    ComplaintNotes: edt_ComplaintNotes.text.toString(),
                    RequirementSpecs: edt_requirment_specs.text.toString(),
                    ProjectTypeSpecs: edt_project_type_specs.text.toString(),
                    TechnicalDetail: edt_technical_details.text.toString(),
                    MarkedAreaLength: edt_mark_area_length.text.toString(),
                    MarkedAreaWidth: edt_mark_area_width.text.toString(),
                    CeilingHeight: edt_Ceiling_Height.text.toString(),
                    TentativeBudget: edt_Tentative_Budget.text.toString(),
                    VisitedDate: edt_VisitDate_Reverse.text.toString(),
                    ContactPerson: edt_Contact_Person.text.toString(),
                    Designation: edt_Designation.text.toString(),
                    TimeIn: DateTime.now().year.toString() +
                        "-" +
                        DateTime.now().month.toString() +
                        "-" +
                        DateTime.now().day.toString() +
                        " " +
                        edt_FromTime.text.toString(),
                    SiteInCharge: edt_SiteInChargeEmpID.text.toString(),
                    VisitedPerson: edt_VistedPersonEmpID.text.toString(),
                    RequirementDetail: edt_Requirment.text.toString(),
                    ProjectType: edt_ProjectType.text.toString(),
                    NoOfVisit: edt_No_Of_Visit.text.toString(),
                    EmployeeID: edt_AssignToID.text.toString(),
                    MetWith: edt_MetWithHis.text.toString(),
                    ContactNo: edt_Contact_Number.text.toString(),
                    LoginUserID: LoginUserID,
                    CompanyId: CompanyID.toString(),
                    TimeOut: DateTime.now().year.toString() +
                        "-" +
                        DateTime.now().month.toString() +
                        "-" +
                        DateTime.now().day.toString() +
                        " " +
                        edt_ToTime.text.toString(),
                  )));
              Navigator.of(context).pop();
            });
          } else {
            showCommonDialogWithSingleOption(context, "Assign To is required !",
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
      showCommonDialogWithSingleOption(context, "Customer name is required !",
          onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  void ComplaintSaveSucessResponse(VkComplaintSaveResponseState state) {
    String Msg = _isForUpdate == true
        ? "Complaint Updated Successfully !"
        : "Complaint Added Successfully !";

    showCommonDialogWithSingleOption(context, Msg, positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
      navigateTo(context, VkSoundComplaintPaginationListScreen.routeName);
    });
  }

  void _onpkIDtoDetailsAPIResponse(VkComplainPkIDtoDetailsResponseState state) {
    for (int i = 0; i < state.response.details.length; i++) {
      edt_ComplanitID.text = state.response.details[i].complaintNo;
      edt_ComplanitDate.text = state.response.details[i].complaintDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseComplanitDate.text = state.response.details[i].complaintDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
      edt_vkStatus.text = state.response.details[i].complaintStatus;
      edt_CustomerID.text = state.response.details[i].customerID.toString();
      edt_CustomerName.text = state.response.details[i].customerName;
      edt_vkContactNo.text = state.response.details[i].contactNo1;
      edt_Address.text = state.response.details[i].address;
      edt_QualifiedCityCode.text =
          state.response.details[i].cityCode.toString();
      // edt_Area.text = state.response.details[i].a
      edt_QualifiedCity.text = state.response.details[i].cityname;
      edt_QualifiedStateCode.text =
          state.response.details[i].stateCode.toString();
      edt_QualifiedState.text = state.response.details[i].stateName;
      edt_QualifiedCountryCode.text = state.response.details[i].countryCode;

      edt_QualifiedCountry.text = state.response.details[i].countryName;
      edt_Vk_Pincode.text = state.response.details[i].pinCode;
      edt_ReverseSheduleDate.text = state.response.details[i].scheduleDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
      edt_SheduleDate.text = state.response.details[i].scheduleDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_Type.text = state.response.details[i].complaintType;
      edt_ComplaintNotes.text = state.response.details[i].complaintNotes;
      edt_requirment_specs.text = state.response.details[i].requirementSpecs;
      edt_project_type_specs.text = state.response.details[i].projectTypeSpecs;
      edt_technical_details.text = state.response.details[i].technicalDetail;
      edt_mark_area_length.text =
          state.response.details[i].markedAreaLength.toString();
      edt_mark_area_width.text =
          state.response.details[i].markedAreaWidth.toString();
      edt_Ceiling_Height.text =
          state.response.details[i].ceilingHeight.toString();
      edt_Tentative_Budget.text =
          state.response.details[i].tentativeBudget.toString();
      edt_VisitDate_Reverse.text = state.response.details[i].visitedDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
      edt_VisitDate.text = state.response.details[i].visitedDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_Contact_Person.text = state.response.details[i].contactPerson;
      edt_Designation.text = state.response.details[i].designation;

      if (state.response.details[i].timeIn == "") {
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
        edt_FromTime.text = state.response.details[i].timeIn.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "hh:mm a");
      }
      if (state.response.details[i].timeOut == "") {
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
            AM_PMToTime;
      } else {
        edt_ToTime.text = state.response.details[i].timeOut.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "hh:mm a");
      }
      edt_SiteInChargeEmpName.text = state.response.details[i].SiteInChargeName;
      edt_SiteInChargeEmpID.text =
          state.response.details[i].siteInCharge.toString();
      edt_VistedPersonEmpName.text =
          state.response.details[i].VisitedPersonName;
      edt_VistedPersonEmpID.text =
          state.response.details[i].visitedPerson.toString();
      edt_Requirment.text = state.response.details[i].requirementDetail;
      edt_ProjectType.text = state.response.details[i].projectType;
      edt_No_Of_Visit.text = state.response.details[i].noOfVisit;
      edt_AssignToID.text = state.response.details[i].employeeID.toString();
      edt_AssignTo.text = state.response.details[i].AssignedTo;
      edt_MetWithHis.text = state.response.details[i].metWith;
      edt_Contact_Number.text = state.response.details[i].contactNo;

      if (state.response.details[i].countryCode != "") {
        _searchCountryDetails = SearchCountryDetails();
        _searchCountryDetails.countryCode =
            state.response.details[i].countryCode;
        _searchCountryDetails.countryName =
            state.response.details[i].countryName;
        edt_QualifiedCountryCode.text = state.response.details[i].countryCode;
        edt_QualifiedCountry.text = state.response.details[i].countryName;
      } else {
        _searchCountryDetails = SearchCountryDetails();
        _searchCountryDetails.countryCode = "IND";
        _searchCountryDetails.countryName = "India";
        edt_QualifiedCountryCode.text = "IND";
        edt_QualifiedCountry.text = "India";
      }

      if (state.response.details[i].stateCode != 0) {
        _searchStateDetails = SearchStateDetails();

        print("ljsfj" +
            " StateCode : " +
            _offlineLoggedInData.details[0].stateCode.toString());
        _searchStateDetails.value = state.response.details[i].stateCode;
        _searchStateDetails.label = state.response.details[i].stateName;

        edt_QualifiedState.text = state.response.details[i].stateName;
        edt_QualifiedStateCode.text =
            state.response.details[i].stateCode.toString();
      } else {
        _searchStateDetails = SearchStateDetails();

        print("ljsfj" +
            " StateCode : " +
            _offlineLoggedInData.details[0].stateCode.toString());
        _searchStateDetails.value = _offlineLoggedInData.details[0].stateCode;
        _searchStateDetails.label = _offlineLoggedInData.details[0].StateName;

        edt_QualifiedState.text = _offlineLoggedInData.details[0].StateName;
        edt_QualifiedStateCode.text =
            _offlineLoggedInData.details[0].stateCode.toString();
      }

      if (state.response.details[i].cityCode != 0) {
        _searchCityDetails = SearchCityDetails();
        _searchCityDetails.cityCode = state.response.details[i].cityCode;
        _searchCityDetails.cityName = state.response.details[i].cityname;

        edt_QualifiedCity.text = state.response.details[i].cityname;
        edt_QualifiedCityCode.text =
            state.response.details[i].cityCode.toString();
      } else {
        _searchCityDetails = SearchCityDetails();
        _searchCityDetails.cityCode = _offlineLoggedInData.details[0].CityCode;
        _searchCityDetails.cityName = _offlineLoggedInData.details[0].CityName;

        edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
        edt_QualifiedCityCode.text =
            _offlineLoggedInData.details[0].CityCode.toString();
      }
    }
  }
}
