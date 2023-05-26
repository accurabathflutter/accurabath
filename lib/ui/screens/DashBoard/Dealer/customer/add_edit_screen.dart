import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/dealer/dealer_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/district_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/taluka_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/customer/list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_country_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class DCustomerAdd_Edit_Screen extends BaseStatefulWidget {
  static const routeName = '/DCustomerAdd_Edit_Screen';

  @override
  BaseState<DCustomerAdd_Edit_Screen> createState() =>
      _DCustomerAdd_Edit_ScreenState();
}

class _DCustomerAdd_Edit_ScreenState extends BaseState<DCustomerAdd_Edit_Screen>
    with BasicScreen, WidgetsBindingObserver {
  DealerBloc _dealerBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;

  int CompanyID = 0;
  String LoginUserID = "";
  final TextEditingController edt_Customer_Name = TextEditingController();
  final TextEditingController edt_Source = TextEditingController();
  final TextEditingController edt_sourceID = TextEditingController();
  final TextEditingController edt_Address = TextEditingController();
  final TextEditingController edt_Area = TextEditingController();
  final TextEditingController edt_QualifiedCountry = TextEditingController();
  final TextEditingController edt_QualifiedCountryCode =
      TextEditingController();
  final TextEditingController edt_QualifiedState = TextEditingController();
  final TextEditingController edt_QualifiedStateCode = TextEditingController();
  final TextEditingController edt_QualifiedCity = TextEditingController();
  final TextEditingController edt_QualifiedCityCode = TextEditingController();
  final TextEditingController edt_Pincode = TextEditingController();

  double CardViewHieght = 45;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Source = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Country = [];
  List<ALL_Name_ID> _listFilteredCountry = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_State = [];
  List<ALL_Name_ID> _listFilteredState = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_District = [];

  List<ALL_Name_ID> _listFilteredDistrict = [];
  List<ALL_Name_ID> _listFilteredTaluka = [];
  List<ALL_Name_ID> _listFilteredCity = [];

  final _formKey = GlobalKey<FormState>();
  SearchCountryDetails _searchDetails;
  SearchCountryDetails _searchCountryDetails;
  SearchDistrictDetails _searchDistrictDetails;
  SearchStateDetails _searchStateDetails;
  SearchTalukaDetails _searchTalukaDetails;
  SearchCityDetails _searchCityDetails;

  List<File> MultipleVideoList = [];

  final imagepicker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    edt_Customer_Name.text = "";
    edt_Source.text = "";
    edt_sourceID.text = "";
    edt_Address.text = "";
    edt_Area.text = "";
    edt_QualifiedCountry.text = "";
    edt_QualifiedCountryCode.text = "";
    _searchDetails = SearchCountryDetails();
    _searchCountryDetails = SearchCountryDetails();
    _searchStateDetails = SearchStateDetails();

    edt_QualifiedCountry.text = "India";
    edt_QualifiedCountryCode.text = "IND";
    _searchStateDetails.value = _offlineLoggedInData.details[0].stateCode;
    edt_QualifiedState.text = _offlineLoggedInData.details[0].StateName;
    edt_QualifiedStateCode.text =
        _offlineLoggedInData.details[0].stateCode.toString();

    edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
    edt_QualifiedCityCode.text =
        _offlineLoggedInData.details[0].CityCode.toString();

    _dealerBloc = DealerBloc(baseBloc);
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
          if (state is CustomerSourceCallEventResponseState) {
            _onSourceSuccess(state);
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
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is CustomerSourceCallEventResponseState ||
              currentState is CountryListEventResponseState ||
              currentState is StateListEventResponseState ||
              currentState is CityListEventResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    edt_Customer_Name.dispose();
    edt_Source.dispose();
    edt_sourceID.dispose();
    edt_Address.dispose();
    edt_Area.dispose();
    edt_QualifiedCountry.dispose();
    edt_QualifiedCountryCode.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Customer Details'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  top: 25,
                ),
                child: Column(
                  children: [
                    CustomerName(),
                    SizedBox(height: Constant.SIZEBOXNEWHEIGHT),
                    CustomDropDown1("Source",
                        enable2: false,
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForRight: edt_Source,
                        Custom_values2: arr_ALL_Name_ID_For_Source),
                    SizedBox(height: Constant.SIZEBOXNEWHEIGHT),
                    Address(),
                    SizedBox(height: Constant.SIZEBOXNEWHEIGHT),
                    Area(),
                    SizedBox(height: Constant.SIZEBOXNEWHEIGHT),
                    Row(
                      children: [
                        Expanded(flex: 1, child: QualifiedCountry()),
                        Expanded(flex: 1, child: QualifiedState()),
                      ],
                    ),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    Row(
                      children: [
                        Expanded(flex: 1, child: QualifiedCity()),
                        Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
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
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
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
                              ),
                            )),
                      ],
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

  Widget CustomerName() {
    return Column(
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
                      controller: edt_Customer_Name,
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

  Widget CustomDropDown1(String Source,
      {bool enable2,
      Icon icon,
      TextEditingController controllerForRight,
      List<ALL_Name_ID> Custom_values2}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                /* showcustomdialog(
                    values: Custom_values2,
                    context1: context,
                    controller: controllerForRight,
                    controller2: edt_sourceID,
                    lable: "Select $Source")*/
                _dealerBloc.add(CustomerSourceCallEvent(CustomerSourceRequest(
                    pkID: "0",
                    StatusCategory: "InquirySource",
                    companyId: CompanyID,
                    LoginUserID: LoginUserID,
                    SearchKey: ""))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Source",
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
                              controller: controllerForRight,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Tap to select source",
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

  Widget Address() {
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
            height: 100,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      minLines: 3,
                      maxLines: null,
                      controller: edt_Address,
                      decoration: InputDecoration(
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

  Future<bool> _onBackPressed() {
    navigateTo(context, DCustomerListScreen.routeName, clearAllStack: true);
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
            onTap: () => _onTapOfSearchCountryView(_searchCountryDetails == null
                ? ""
                : /*_searchDetails.countryCode*/ ""),
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
        _searchDetails = SearchCountryDetails();
        _searchDetails = value;
        print("CountryName IS From SearchList" + _searchDetails.countryCode);
        edt_QualifiedCountryCode.text = _searchDetails.countryCode;
        edt_QualifiedCountry.text = _searchDetails.countryName;
        _dealerBloc.add(CountryCallEvent(CountryListRequest(
            CountryCode: _searchDetails.countryCode,
            CompanyID: CompanyID.toString())));
      }
    });
  }

  void _onSourceSuccess(CustomerSourceCallEventResponseState state) {
    arr_ALL_Name_ID_For_Source.clear();
    if (state.sourceResponse.details.length != 0) {
      for (var i = 0; i < state.sourceResponse.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name =
            state.sourceResponse.details[i].inquiryStatus;
        categoryResponse123.pkID = state.sourceResponse.details[i].pkID;
        arr_ALL_Name_ID_For_Source.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Source.length != 0) {
        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_Source,
            context1: context,
            controller: edt_Source,
            controllerID: edt_sourceID,
            lable: "Select Source");
      }
    }
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
          onTap: () => _onTapOfSearchStateView(_searchCountryDetails == null
              ? ""
              : _searchCountryDetails.countryCode),
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
        _dealerBloc.add(StateCallEvent(StateListRequest(
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
        _dealerBloc
          ..add(CityCallEvent(CityApiRequest(
              CityName: "",
              CompanyID: CompanyID.toString(),
              StateCode: talukaCode)));
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

  Attachments() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff362d8b), borderRadius: BorderRadius.circular(20)
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
