import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/Clients/BlueTone/Customer/bt_country_list_screen.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/customer/customer_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/bt_country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_add_edit_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_category_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_delete_document_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_id_to_contact_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_id_to_delete_all_contacts_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_upload_document_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/district_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/taluka_api_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/bt_country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_category_list.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_fetch_document_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/district_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/taluka_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/contact_model.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/country_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/distict_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_taluka_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerList/customer_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddUpdateBlueToneCustomerScreenArguments {
  // SearchDetails editModel;

  CustomerDetails editModel;
  List<CustomerFetchDocumentResponseDetails> documentAPIList1;
  AddUpdateBlueToneCustomerScreenArguments(
      this.editModel, this.documentAPIList1);
}

class BlueToneCustomer_ADD_EDIT extends BaseStatefulWidget {
  static const routeName = '/BlueToneCustomer_ADD_EDIT';

  //ALL_Name_ID all_name_id;
  // final CountryArguments arguments;
  final AddUpdateBlueToneCustomerScreenArguments arguments;

  BlueToneCustomer_ADD_EDIT(this.arguments);

  @override
  _BlueToneCustomer_ADD_EDITState createState() =>
      _BlueToneCustomer_ADD_EDITState();
}

class _BlueToneCustomer_ADD_EDITState
    extends BaseState<BlueToneCustomer_ADD_EDIT>
    with BasicScreen, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode;
  FocusNode PicCodeFocus;

  CustomerBloc _CustomerBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;

  //CustomerCategoryResponse _offlineCustomerCategoryData;
  // CustomerSourceResponse _offlineCustomerSourceData;

  int CompanyID = 0;
  String LoginUserID = "";

  final TextEditingController edt_Customer_Name = TextEditingController();
  final TextEditingController edt_Customer_Contact1_Name =
      TextEditingController();

  final TextEditingController edt_Customer_Contact1_CountryCode =
      TextEditingController();
  final TextEditingController edt_Customer_Contact2_Name =
      TextEditingController();
  final TextEditingController edt_GST_Name = TextEditingController();
  final TextEditingController edt_PAN_Name = TextEditingController();
  final TextEditingController edt_Email_Name = TextEditingController();
  final TextEditingController edt_Website_Name = TextEditingController();
  final TextEditingController edt_Address = TextEditingController();
  final TextEditingController edt_Area = TextEditingController();
  final TextEditingController edt_Category = TextEditingController();

  final TextEditingController edt_Source = TextEditingController();

  //final TextEditingController edt_Country = TextEditingController();
  //final TextEditingController edt_CountryID = TextEditingController();

  final TextEditingController edt_District = TextEditingController();
  final TextEditingController edt_DistrictID = TextEditingController();

  final TextEditingController edt_Taluka = TextEditingController();
  final TextEditingController edt_TalukaID = TextEditingController();

  final TextEditingController edt_Pincode = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchControllerState = TextEditingController();
  final TextEditingController _searchControllerDistrict =
      TextEditingController();
  final TextEditingController edt_sourceID = TextEditingController();

  final TextEditingController edt_openingBalance = TextEditingController();
  final TextEditingController edt_debitBalance = TextEditingController();
  final TextEditingController edt_creditBalance = TextEditingController();
  final TextEditingController edt_closingBalance = TextEditingController();

  String dropdownValue = 'One';
  List<String> drop = ['One', 'Two', 'Free', 'Four'];
  CustomerCategoryResponse arrcustomerCategory;
  CustomerSourceResponse arrCustomerSourceResponse;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Category = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Source = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Country = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_State = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_District = [];

  List<ALL_Name_ID> _listFilteredCountry = [];

  List<ALL_Name_ID> _listFilteredState = [];

  List<ALL_Name_ID> _listFilteredDistrict = [];
  List<ALL_Name_ID> _listFilteredTaluka = [];
  List<ALL_Name_ID> _listFilteredCity = [];

  Function refreshList;
  BTCountryListResponseDetails _searchDetails;
  SearchDistrictDetails _searchDistrictDetails;
  SearchTalukaDetails _searchTalukaDetails;

  BTCountryListResponseDetails _searchCountryDetails;
  SearchStateDetails _searchStateDetails;
  SearchCityDetails _searchCityDetails;

  bool _isSwitched;
  bool _isForUpdate;
  CustomerDetails _editModel;
  List<CustomerFetchDocumentResponseDetails> _documentAPIList1;
  int customerID = 0;
  List<ContactModel> _contactsList = [];

  String Token;
  double CardViewHieght = 35;

  final TextEditingController edt_QualifiedCountry = TextEditingController();
  final TextEditingController edt_QualifiedCountryCode =
      TextEditingController();

  final TextEditingController edt_QualifiedState = TextEditingController();

  final TextEditingController edt_QualifiedStateCode = TextEditingController();

  final TextEditingController edt_QualifiedCity = TextEditingController();
  final TextEditingController edt_QualifiedCityCode = TextEditingController();
  bool emailValid;

  List<File> MultipleVideoList = [];
  final imagepicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    //_offlineCustomerCategoryData = SharedPrefHelper.instance.getCustomerCategoryData();
    //_offlineCustomerSourceData = SharedPrefHelper.instance.getCustomerSourceData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    //getOfflineCustomerCategoryData(_offlineCustomerCategoryData);
    // onSourceSuccess(_offlineCustomerSourceData);
    emailValid = false;
    screenStatusBarColor = colorPrimary;
    _CustomerBloc = CustomerBloc(baseBloc);
    myFocusNode = FocusNode();
    PicCodeFocus = FocusNode();

    /* _CustomerBloc
      ..add(CountryCallEvent(
          CountryListRequest(CountryCode: "", CompanyID: "8033")));*/
    /* _CustomerBloc
      ..add(StateCallEvent(StateListRequest(
          CountryCode: "IND", CompanyId: "8033", word: "", Search: "1")));
    _CustomerBloc
      ..add(DistrictCallEvent(DistrictApiRequest(
          DistrictName: "", CompanyId: "8033", StateCode: "12")));
    _CustomerBloc
      ..add(TalukaCallEvent(
          TalukaApiRequest(TalukaName: "", CompanyId: "8033",DistrictCode: "12")));
    _CustomerBloc
      ..add(CityCallEvent(
          CityApiRequest(CityName: "", CompanyID: "8033",TalukaCode: "8")));*/

    /*
    _isSwitched = true;
    if (_isForUpdate !=null) {
      _editModel = widget.arguments.editModel;
      fillData();
    }*/
    edt_Source.addListener(() {
      myFocusNode.requestFocus();
    });

    /* edt_City.addListener(() {
      PicCodeFocus.requestFocus();
    });*/

    if (widget.arguments != null) {
      _editModel = widget.arguments.editModel;
      _documentAPIList1 = widget.arguments.documentAPIList1;
      fillData();
    } else {
      _searchStateDetails = SearchStateDetails();
      edt_openingBalance.text = "0.00";
      edt_debitBalance.text = "0.00";
      edt_creditBalance.text = "0.00";
      edt_closingBalance.text = "0.00";

      edt_QualifiedCountry.text = "India";
      edt_QualifiedCountryCode.text = "IND";
      _searchStateDetails.value = _offlineLoggedInData.details[0].stateCode;
      edt_QualifiedState.text = _offlineLoggedInData.details[0].StateName;
      edt_QualifiedStateCode.text =
          _offlineLoggedInData.details[0].stateCode.toString();

      edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
      edt_QualifiedCityCode.text =
          _offlineLoggedInData.details[0].CityCode.toString();
      _isSwitched = true;

      setState(() {});
    }

    /* edt_openingBalance.addListener(() {
      double opening = 0.00;
      double debit = 0.00;
      double credit = 0.00;
      double closing = 0.00;

      opening = edt_openingBalance.text.toString() != ""
          ? 0.00
          : double.parse(edt_openingBalance.text);
      debit = edt_debitBalance.text.toString() != ""
          ? 0.00
          : double.parse(edt_debitBalance.text);
      credit = edt_creditBalance.text.toString() != ""
          ? 0.00
          : double.parse(edt_creditBalance.text);
      closing = edt_closingBalance.text.toString() != ""
          ? 0.00
          : double.parse(edt_closingBalance.text);

      closing = (opening + debit) - credit;
      edt_closingBalance.text = closing.toStringAsFixed(2);
    });*/
  }

  ///listener to multiple states of bloc to handles api responses
  ///use only BlocListener if only need to listen to events
/*
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenStates>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, HomeScreenStates state) {
        if (state is HomeScreenResponseState) {
          _onHomeScreenCallSuccess(state.response);
        }
      },
      child: super.build(context),
    );
  }
*/

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    myFocusNode.dispose();
    PicCodeFocus.dispose();
  }

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<CustomerBloc, CustomerStates>(
        builder: (BuildContext context, CustomerStates state) {
          //handle states

          if (state is BTCountryListResponseState) {
            _onCountryListSuccess(state);
          }
          if (state is StateListEventResponseState) {
            _onStateListSuccess(state);
          }
          if (state is DistrictListEventResponseState) {
            _onDistrictListSuccess(state);
          }
          if (state is TalukaListEventResponseState) {
            _onTalukaListSuccess(state);
          }
          if (state is CityListEventResponseState) {
            _onCityListSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          if (currentState is BTCountryListResponseState) {
            return true;
          } else if (currentState is StateListEventResponseState) {
            return true;
          } else if (currentState is DistrictListEventResponseState) {
            return true;
          } else if (currentState is TalukaListEventResponseState) {
            return true;
          } else if (currentState is CityListEventResponseState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, CustomerStates state) {
          //handle states

          if (state is StateListEventResponseState) {
            _onStateListSuccess(state);
          }
          if (state is CustomerAddEditEventResponseState) {
            _onCustomerAddEditSuccess(state);
          }
          if (state is CustomerContactSaveResponseState) {
            _OnCustomerContactSucess(state);
          }
          if (state is CustomerIdToCustomerListResponseState) {
            _OnCustomerIdToFetchContactDetails(state);
          }
          if (state is CustomerIdToDeleteAllContactResponseState) {
            _OnCustomerIdToDeleteAllContactResponse(state);
          }
          if (state is CustomerCategoryCallEventResponseState) {
            _OnCustomerCategoryCallEventResponse(state);
          }

          if (state is CustomerSourceCallEventResponseState) {
            _onSourceSuccess(state);
          }
          if (state is CustomerUploadDocumentResponseState) {
            _onUploadDocumentResponse(state);
          }

          if (state is CustomerDeleteDocumentResponseState) {
            _onCustomerDeletedocumentSucess(state);
          }
          /*  if (state is DistrictListEventResponseState) {
            _onDistrictListSuccess(state);
          }
          if (state is TalukaListEventResponseState) {
            _onTalukaListSuccess(state);
          }*/
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          /* if (currentState is StateListEventResponseState) {
            return true;
          }
          if (currentState is DistrictListEventResponseState) {
            return true;
          }*/

          if (currentState is CustomerAddEditEventResponseState) {
            return true;
          } else if (currentState is CustomerContactSaveResponseState) {
            return true;
          } else if (currentState is CustomerIdToCustomerListResponseState) {
            return true;
          } else if (currentState
              is CustomerIdToDeleteAllContactResponseState) {
            return true;
          } else if (currentState is CustomerCategoryCallEventResponseState) {
            return true;
          } else if (currentState is CustomerSourceCallEventResponseState) {
            return true;
          } else if (currentState is CustomerUploadDocumentResponseState) {
            return true;
          } else if (currentState is CustomerDeleteDocumentResponseState) {
            return true;
          }

          //

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
          title: Text('Customer Details..'),
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
                  _onTapOfLogOut();
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
                    CustomerName(),
                    SizedBox(height: Constant.SIZEBOXHEIGHT),
                    /* CustomDropDown1("Category", "Source",
                        enable1: false,
                        enable2: false,
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_Category,
                        controllerForRight: edt_Source,
                        Custom_values1: arr_ALL_Name_ID_For_Category,
                        Custom_values2: arr_ALL_Name_ID_For_Source),
                    SizedBox(height: Constant.SIZEBOXHEIGHT),*/
                    // SwitchNoFollowup(),
                    // SizedBox(height: Constant.SIZEBOXHEIGHT),
                    ContactCollapse(),
                    SizedBox(height: Constant.SIZEBOXHEIGHT),
                    EmailWebSite(),
                    SizedBox(height: Constant.SIZEBOXHEIGHT),
                    //GSTPAN(),
                    //SizedBox(height: Constant.SIZEBOXHEIGHT),
                    // Address(),
                    // SizedBox(height: Constant.SIZEBOXHEIGHT),
                    //Area(),
                    //SizedBox(height: Constant.SIZEBOXHEIGHT),
                    Row(
                      children: [
                        Expanded(flex: 1, child: QualifiedCountry()),
                        Expanded(flex: 1, child: QualifiedState()),
                      ],
                    ),
                    SizedBox(
                      height: Constant.SIZEBOXHEIGHT,
                    ),
                    Row(
                      children: [
                        Expanded(flex: 1, child: QualifiedCity()),
                        /* Expanded(
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
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10),
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
                            )),*/
                      ],
                    ),
                    SizedBox(
                      height: Constant.SIZEBOXHEIGHT,
                    ),
                    // Ladger(),

                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        // getContactarray();
                        _onTapOfSaveCustomerAPICall();
                        // navigateTo(context, ContactsListScreen.routeName);
                      }, "Save", width: 600),
                    ),
                    /* FlatButton(onPressed: (){
                      FirebaseMessaging.instance.getToken().then((token){
                        print(token);
                        setState(() {
                          Token = token;

                        });
                      });
                    },
                        child: Text("Token")),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: SelectableText(
                        "$Token",
                        style: const TextStyle(color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                        textAlign: TextAlign.center,
                        onTap: () => print('Tapped'),
                        toolbarOptions: const ToolbarOptions(copy: true, selectAll: true,),
                        showCursor: true,
                        cursorWidth: 2,
                        cursorColor: Colors.red,
                        cursorRadius: const Radius.circular(5),

                      ),
                    ),*/
                    /* ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange,
                        minimumSize: Size(double.infinity, 50), // double.infinity is the width and 30 is the height
                      ),
                      onPressed: () {},
                      child: Text('Save'),
                    )*/
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapOfLogOut() async {
    //await SharedPrefHelper.instance.clear();
    await _onTapOfDeleteALLContact();
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  Future<void> _onTapOfCustomer() async {
    //await SharedPrefHelper.instance.clear();
    navigateTo(context, CountryListScreen.routeName, clearAllStack: true);
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    // CommonUtils.showToast(context, "Back presses");
    // Navigator.defaultRouteName.
    await _onTapOfDeleteALLContact();
    navigateTo(context, CustomerListScreen.routeName);
  }

  Widget CustomDropDown1(String Category, String Source,
      {bool enable1,
      bool enable2,
      Icon icon,
      TextEditingController controllerForLeft,
      TextEditingController controllerForRight,
      List<ALL_Name_ID> Custom_values1,
      List<ALL_Name_ID> Custom_values2}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => _CustomerBloc.add(CustomerCategoryCallEvent(
                CustomerCategoryRequest(
                    pkID: "", CompanyID: CompanyID.toString()))),

            /*showcustomdialog(
    values: Custom_values1,
    context1: context,
    controller: controllerForLeft,
    lable: "Select $Category"),*/

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Category *",
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
                                contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: "Tap to select category",
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
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () =>
                /* showcustomdialog(
                    values: Custom_values2,
                    context1: context,
                    controller: controllerForRight,
                    controller2: edt_sourceID,
                    lable: "Select $Source")*/
                _CustomerBloc.add(CustomerSourceCallEvent(CustomerSourceRequest(
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
                              onChanged: (value) =>
                                  {myFocusNode.requestFocus()},
                              //myFocusNode.requestFocus(),
                              controller: controllerForRight,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget CustomDropDown(String Category, String Source,
      {bool enable1,
      bool enable2,
      Icon icon,
      TextEditingController controllerForLeft,
      TextEditingController controllerForRight}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => _onTapOfSearchCityView(_searchStateDetails == null
                ? ""
                : _searchStateDetails.value.toString()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("City *",
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
                                hintText: "Tap to search city",
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
                          Icons.location_city_outlined,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            /*Container(
                child:
                    Text(
                  _searchDetails == null
                      ? "search country"
                      : _searchDetails.countryName,
                  style: baseTheme.textTheme.headline3.copyWith(
                      color:
                          _searchDetails == null ? colorGrayDark : colorBlack),
                ),
              ),*/
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
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
                              focusNode: PicCodeFocus,
                              controller: controllerForRight,
                              keyboardType: TextInputType.number,
                              maxLength: 14,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Tap to enter PinCode",
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
                          Icons.pin_drop_sharp,
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

  Widget ContactCollapse() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Contact No.1 *",
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
            Row(
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHieght,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: 100,
                    child: TextField(
                        controller: edt_Customer_Contact1_CountryCode,
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10),
                          counterText: "",
                          hintText: "+91",
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
                ),
                Flexible(
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
                                controller: edt_Customer_Contact1_Name,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: myFocusNode,
                                maxLength: 14,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 10),
                                  counterText: "",
                                  hintText: "Contact No.1",
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
                            Icons.phone_android,
                            color: colorGrayDark,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: Constant.SIZEBOXHEIGHT,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Contact No.2",
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
                          controller: edt_Customer_Contact2_Name,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLength: 14,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            counterText: "",
                            hintText: "Tap to enter Contact No.2",
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
                      Icons.phone_android,
                      color: colorGrayDark,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }

  Widget EmailWebSite() {
    return Container(
        child: Column(
      children: [
        Column(
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
                          controller: edt_Email_Name,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            counterText: "",
                            hintText: "Tap to enter email",
                            labelStyle: TextStyle(
                              color: Color(0xFF000000),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    Icon(
                      Icons.email,
                      color: colorGrayDark,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ));

    /* return Container(
        child: Column(
      children: [
        buildUserNameTextFiled(
            userName_Controller: edt_Email_Name,
            labelName: "Email ID",
            icon: Icon(Icons.email),
            maxline: 1,
            baseTheme: baseTheme),
        SizedBox(
          height: Constant.SIZEBOXHEIGHT,
        ),
        buildUserNameTextFiled(
            userName_Controller: edt_Website_Name,
            labelName: "Web Site",
            icon: Icon(Icons.web),
            maxline: 1,
            baseTheme: baseTheme),
      ],
    ));*/
  }

  void onSourceSuccess(CustomerSourceResponse response) {
    arr_ALL_Name_ID_For_Source.clear();
    for (var i = 0; i < response.details.length; i++) {
      print("CustomerCategoryResponse2 : " + response.details[i].inquiryStatus);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name = response.details[i].inquiryStatus;
      categoryResponse123.Name1 = response.details[i].pkID.toString();
      arr_ALL_Name_ID_For_Source.add(categoryResponse123);

      //children.add(new ListTile());
    }
  }

  void _onCountryListSuccess(BTCountryListResponseState responseState) {
    arr_ALL_Name_ID_For_Country.clear();
    for (var i = 0;
        i < responseState.btCountryListResponse.details.length;
        i++) {
      print("CustomerCategoryResponse2 : " +
          responseState.btCountryListResponse.details[i].countryName);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          responseState.btCountryListResponse.details[i].countryName;
      categoryResponse123.Name1 =
          responseState.btCountryListResponse.details[i].countryCode;
      categoryResponse123.MenuName =
          responseState.btCountryListResponse.details[i].telephonicCode;
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

  void _onDistrictListSuccess(DistrictListEventResponseState responseState) {
    arr_ALL_Name_ID_For_District.clear();
    for (var i = 0;
        i < responseState.districtApiResponseList.details.length;
        i++) {
      print("CustomerCategoryResponse2 : " +
          responseState.districtApiResponseList.details[i].districtName);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          responseState.districtApiResponseList.details[i].districtName;
      categoryResponse123.pkID =
          responseState.districtApiResponseList.details[i].districtCode;
      arr_ALL_Name_ID_For_District.add(categoryResponse123);
      _listFilteredDistrict.add(categoryResponse123);
      //children.add(new ListTile());
    }
  }

  void _onTalukaListSuccess(TalukaListEventResponseState responseState) {
    arr_ALL_Name_ID_For_District.clear();
    for (var i = 0; i < responseState.talukaApiRespose.details.length; i++) {
      print("CustomerCategoryResponse2 : " +
          responseState.talukaApiRespose.details[i].talukaName);
      ALL_Name_ID categoryResponse123 = ALL_Name_ID();
      categoryResponse123.Name =
          responseState.talukaApiRespose.details[i].talukaName;
      categoryResponse123.pkID =
          responseState.talukaApiRespose.details[i].talukaCode;
      arr_ALL_Name_ID_For_District.add(categoryResponse123);
      _listFilteredTaluka.add(categoryResponse123);
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

  Future<void> _onTapOfSearchCountryView(String sw) async {
    navigateTo(context, BTSearchCountryScreen.routeName,
            arguments: BTCountryArguments(sw))
        .then((value) {
      if (value != null) {
        _searchDetails = BTCountryListResponseDetails();
        _searchDetails = value;
        print("CountryName IS From SearchList" + _searchDetails.countryCode);
        edt_QualifiedCountryCode.text = _searchDetails.countryCode;
        edt_QualifiedCountry.text = _searchDetails.countryName;
        edt_Customer_Contact1_CountryCode.text =
            _searchDetails.telephonicCode.toString();

        /*  _CustomerBloc.add(CountryCallEvent(CountryListRequest(
            CountryCode: _searchDetails.countryCode,
            CompanyID: CompanyID.toString())));*/

        _CustomerBloc
          ..add(BTCountryListRequestEvent(BTCountryListRequest(
            CompanyId: CompanyID.toString(),
            CountryCode: _searchDetails.countryCode,
            ListMode: "L",
          )));
      }
    });
  }

  Future<void> _onTapOfSearchStateView(String sw1) async {
    print('CountryCodedd' +
        " CountryCode : " +
        edt_QualifiedCountryCode.text.toString());
    navigateTo(context, SearchStateScreen.routeName,
            arguments: StateArguments(edt_QualifiedCountryCode.text))
        .then((value) {
      if (value != null) {
        _searchStateDetails = value;
        edt_QualifiedStateCode.text = _searchStateDetails.value.toString();
        edt_QualifiedState.text = _searchStateDetails.label.toString();
        _CustomerBloc.add(StateCallEvent(StateListRequest(
            CountryCode: edt_QualifiedCountryCode.text,
            CompanyId: CompanyID.toString(),
            word: "",
            Search: "0")));
      }
    });
  }

  Future<void> _onTapOfSearchDistrictView(String stateCode) async {
    navigateTo(context, SearchDistrictScreen.routeName,
            arguments: DistrictArguments(stateCode))
        .then((value) {
      if (value != null) {
        _searchDistrictDetails = value;
        edt_DistrictID.text = _searchDistrictDetails.districtCode.toString();
        edt_District.text = _searchDistrictDetails.districtName.toString();
        _CustomerBloc
          ..add(DistrictCallEvent(DistrictApiRequest(
              DistrictName: "",
              CompanyId: CompanyID.toString(),
              StateCode: stateCode)));
      }
    });
  }

  Future<void> _onTapOfSearchTalukaView(String districtCode) async {
    navigateTo(context, SearchTalukaScreen.routeName,
            arguments: TalukaArguments(districtCode))
        .then((value) {
      if (value != null) {
        _searchTalukaDetails = value;
        edt_TalukaID.text = _searchTalukaDetails.talukaCode.toString();
        edt_Taluka.text = _searchTalukaDetails.talukaName.toString();
        _CustomerBloc
          ..add(TalukaCallEvent(TalukaApiRequest(
              TalukaName: "",
              CompanyId: CompanyID.toString(),
              DistrictCode: districtCode)));
      }
    });
  }

  Future<void> _onTapOfSearchCityView(String talukaCode) async {
    navigateTo(context, SearchCityScreen.routeName,
            arguments: CityArguments(talukaCode))
        .then((value) {
      if (value != null) {
        _searchCityDetails = value;
        edt_QualifiedCityCode.text = _searchCityDetails.cityCode.toString();
        edt_QualifiedCity.text = _searchCityDetails.cityName.toString();
        _CustomerBloc
          ..add(CityCallEvent(CityApiRequest(
              CityName: "",
              CompanyID: CompanyID.toString(),
              StateCode: talukaCode)));
      }
    });
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
                        contentPadding: EdgeInsets.only(bottom: 10),
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

  _onTapOfSaveCustomerAPICall() async {
    if (edt_Email_Name.text.toString().trim() != "") {
      emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(edt_Email_Name.text);
    } else {
      emailValid =
          false; //RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(edt_Email_Name.text);
    }
    await getContacts();

    int nofollowupvalue = 1;

    if (_isSwitched == false) {
      nofollowupvalue = 0;
    } else {
      nofollowupvalue = 1;
    }

    print("CustomerAddEdit : " +
        "CountryCode : " +
        edt_QualifiedCountryCode.text +
        " StateCode : " +
        edt_QualifiedStateCode.text +
        " DistrictCode : " +
        edt_DistrictID.text +
        " TalukaCode : " +
        edt_TalukaID.text +
        " CityCode : " +
        edt_QualifiedCityCode.text +
        " SourceID : " +
        edt_sourceID.text +
        "");

    if (edt_Customer_Name.text.toString().trim() != "") {
      if (edt_Category.text.toString().trim() != "") {
        if (edt_Customer_Contact1_Name.text.toString().trim() != "") {
          if (emailValid == true ||
              edt_Email_Name.text.toString().trim() == "") {
            if (edt_QualifiedCountry.text.toString().trim() != "") {
              if (edt_QualifiedState.text.toString().trim() != "") {
                if (edt_QualifiedCity.text.toString().trim() != "") {
                  if (edt_Pincode.text.toString().trim() == "" ||
                      edt_Pincode.text.toString().trim().length == 6) {
                    showCommonDialogWithTwoOptions(
                        context, "Are you sure you want to Save this Customer?",
                        negativeButtonTitle: "No",
                        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                      Navigator.of(context).pop();

                      _CustomerBloc.add(CustomerAddEditCallEvent(
                          context,
                          CustomerAddEditApiRequest(
                              customerID: customerID.toString(),
                              customerName: edt_Customer_Name.text,
                              customerType: edt_Category.text,
                              address: edt_Address.text,
                              area: edt_Area.text,
                              pinCode: edt_Pincode.text,
                              gSTNo: edt_GST_Name.text,
                              pANNo: edt_PAN_Name.text,
                              contactNo1: edt_Customer_Contact1_Name.text,
                              contactNo2: edt_Customer_Contact2_Name.text,
                              emailAddress: edt_Email_Name.text,
                              websiteAddress: edt_Website_Name.text,
                              latitude: SharedPrefHelper.instance.getLatitude(),
                              longitude:
                                  SharedPrefHelper.instance.getLongitude(),
                              loginUserID: LoginUserID,
                              countryCode: edt_QualifiedCountryCode.text,
                              blockCustomer: nofollowupvalue.toString(),
                              customerSourceID: edt_sourceID.text,
                              companyId: CompanyID.toString(),
                              stateCode: edt_QualifiedStateCode.text,
                              cityCode: edt_QualifiedCityCode.text)));
                    });
                  } else {
                    showCommonDialogWithSingleOption(
                        context, "PinCode is not Valid !",
                        positiveButtonTitle: "OK");
                  }
                } else {
                  showCommonDialogWithSingleOption(context, "City is required!",
                      positiveButtonTitle: "OK");
                }
              } else {
                showCommonDialogWithSingleOption(context, "State is required!",
                    positiveButtonTitle: "OK");
              }
            } else {
              showCommonDialogWithSingleOption(context, "Country is required!",
                  positiveButtonTitle: "OK");
            }
          } else {
            showCommonDialogWithSingleOption(context, "Enter valid email !",
                positiveButtonTitle: "OK");
          }
        } else {
          showCommonDialogWithSingleOption(context, "Contact No.1 is required!",
              positiveButtonTitle: "OK");
        }
      } else {
        showCommonDialogWithSingleOption(context, "Category is required!",
            positiveButtonTitle: "OK");
      }
    } else {
      showCommonDialogWithSingleOption(context, "Customer Name is required!",
          positiveButtonTitle: "OK");
    }

    /*  _CustomerBloc
      ..add(CustomerAddEditCallEvent(
          CustomerAddEditApiRequest(customerID: "",customerName: edt_Customer_Name.text,
              customerType:edt_Category.text,address: edt_Address.text,area:edt_Area.text,
              pinCode: edt_Pincode.text,address1: "",area1: "",cityCode1: "",pinCode1: "",gSTNo: edt_GST_Name.text,pANNo: edt_PAN_Name.text,
              cINNo: "",contactNo1: edt_Customer_Contact1_Name.text,contactNo2: edt_Customer_Contact2_Name.text,
            emailAddress: edt_Email_Name.text,websiteAddress: edt_Website_Name.text,latitude: "123.000",longitude: "321.000",birthDate: "",
            anniversaryDate: "",loginUserID: "admin",countryCode: edt_CountryID.text,countryCode1:"",blockCustomer: "1",
              customerSourceID: edt_sourceID.text,districtCode: edt_DistrictID.text,
              talukaCode: edt_TalukaID.text
              ,districtCode1: "",talukaCode1: "",companyId: "8033",stateCode:edt_StateID.text,stateCode1:"",cityCode: edt_CityID.text
          )));*/
  }

  _onCustomerAddEditSuccess(CustomerAddEditEventResponseState state) async {
    String Msg = "";
    print("CustomerResultMsg" +
        " Resp : " +
        state.customerAddEditApiResponse.details[0].column2 +
        " Testttt " +
        state.customerAddEditApiResponse.details[0].column1.toString());

    // _CustomerBloc.add(CustomerUploadDocumentApiRequestEvent())

    if (_contactsList.length != 0) {
      if (state.customerAddEditApiResponse.details[0].column2 ==
              "Customer Information Added Successfully" ||
          state.customerAddEditApiResponse.details[0].column2 ==
              "Customer Information Updated Successfully") {
        if (customerID != 0 || customerID != null) {
          _CustomerBloc.add(CustomerIdToDeleteAllContactCallEvent(
              customerID,
              CustomerIdToDeleteAllContactRequest(
                  CompanyId: CompanyID.toString())));
        }

        updateCustomerId(
            state.customerAddEditApiResponse.details[0].column1.toString());
        _CustomerBloc.add(CustomerContactSaveCallEvent(_contactsList));
      } else {
        showCommonDialogWithSingleOption(Globals.context,
            state.customerAddEditApiResponse.details[0].column2,
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          if (state.customerAddEditApiResponse.details[0].column2 ==
                  "Customer Information Added Successfully" ||
              state.customerAddEditApiResponse.details[0].column2 ==
                  "Customer Information Updated Successfully") {
            navigateTo(context, CustomerListScreen.routeName,
                clearAllStack: true);
          }
        });
        //Navigator.of(context).pop();
      }
    } else {
      if (MultipleVideoList.length != 0) {
        _CustomerBloc.add(CustomerDeleteDocumentApiRequestEvent(
            state.customerAddEditApiResponse.details[0].column1.toString(),
            CustomerDeleteDocumentApiRequest(CompanyID: CompanyID.toString())));

        _CustomerBloc.add(CustomerUploadDocumentApiRequestEvent(
            state.customerAddEditApiResponse.details[0].column2,
            MultipleVideoList,
            CustomerUploadDocumentApiRequest(
                pkID: "0",
                Name: MultipleVideoList[0].path.split('/').last,
                CustomerID: state.customerAddEditApiResponse.details[0].column1
                    .toString(),
                CompanyID: CompanyID.toString(),
                LoginUserId: LoginUserID.toString(),
                file: MultipleVideoList[0])));
      } else {
        if (state.customerAddEditApiResponse.details[0].column2 ==
                "Customer Information Added Successfully" ||
            state.customerAddEditApiResponse.details[0].column2 ==
                "Customer Information Updated Successfully") {
          showCommonDialogWithSingleOption(Globals.context,
              state.customerAddEditApiResponse.details[0].column2,
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            navigateTo(context, CustomerListScreen.routeName,
                clearAllStack: true);
          });
        } else {
          showCommonDialogWithSingleOption(state.context,
              state.customerAddEditApiResponse.details[0].column2,
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            // Navigator.pop(context);
            Navigator.pop(state.context);
          });
        }
      }
      /*  await showCommonDialogWithSingleOption(
          Globals.context, state.customerAddEditApiResponse.details[0].column2,
          positiveButtonTitle: "OK");

      if (state.customerAddEditApiResponse.details[0].column2 ==
              "Customer Information Added Successfully" ||
          state.customerAddEditApiResponse.details[0].column2 ==
              "Customer Information Updated Successfully") {
        navigateTo(context, CustomerListScreen.routeName, clearAllStack: true);
      }*/
    }
  }

  Widget SwitchNoFollowup() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Active Status",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(children: [
              Container(
                child: Text("InActive",
                    style: TextStyle(
                        fontSize: 12,
                        color: colorGrayDark,
                        fontWeight: FontWeight.w100)),
              ),
              Container(
                child: Container(
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
              ),
              Container(
                child: Text("Active",
                    style: TextStyle(
                        fontSize: 12,
                        color: colorGrayDark,
                        fontWeight: FontWeight.w100)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void fillData() async {
    customerID = _editModel.customerID;
    edt_Customer_Name.text = _editModel.customerName;
    edt_Category.text = _editModel.customerType;
    edt_Address.text = _editModel.address;
    edt_Area.text = _editModel.area;
    edt_Pincode.text = _editModel.pinCode;
    edt_GST_Name.text = _editModel.gSTNO;
    edt_PAN_Name.text = _editModel.pANNO;
    edt_Customer_Contact1_Name.text = _editModel.contactNo1;
    edt_Customer_Contact2_Name.text = _editModel.contactNo2;
    edt_Email_Name.text = _editModel.emailAddress;
    edt_Website_Name.text = _editModel.websiteAddress;
    edt_sourceID.text = _editModel.customerSourceID.toString();
    edt_Source.text = _editModel.customerSourceName;

    edt_QualifiedCountry.text = _editModel.countryName;
    edt_QualifiedCountryCode.text = _editModel.countryCode;
    edt_QualifiedState.text = _editModel.stateName;
    edt_QualifiedStateCode.text = _editModel.stateCode.toString();
    edt_QualifiedCity.text = _editModel.cityName;
    edt_QualifiedCityCode.text = _editModel.cityCode.toString();
    _searchStateDetails = SearchStateDetails();
    _searchStateDetails.value = _editModel.stateCode;
    _searchStateDetails.label = _editModel.stateName;
    _isSwitched = _editModel.blockCustomer;

    edt_openingBalance.text = _editModel.Opening.toStringAsFixed(2);
    edt_debitBalance.text = _editModel.Debit.toStringAsFixed(2);
    edt_creditBalance.text = _editModel.Credit.toStringAsFixed(2);
    edt_closingBalance.text = _editModel.Closing.toStringAsFixed(2);

    if (_editModel.gSTNO.length == 15) {
      edt_PAN_Name.text =
          _editModel.gSTNO.substring(2, _editModel.gSTNO.length - 3);
    }

    print("BlockCustomer" + _editModel.blockCustomer.toString());
    if (customerID != null) {
      await _onTapOfDeleteALLContact();

      _CustomerBloc.add(CustomerIdToCustomerListCallEvent(
          CustomerIdToCustomerListRequest(
              CustomerID: customerID.toString(),
              CompanyId: CompanyID.toString())));
    }

    if (_documentAPIList1.length != 0) {
      for (int i = 0; i < _documentAPIList1.length; i++) {
        if (_documentAPIList1[i].name != "") {
          String ImageURLFromListing = _offlineCompanyData.details[0].siteURL +
              "/CustomerDocs/" +
              _documentAPIList1[i].name.toString();

          getDetailsOfImage(
              ImageURLFromListing, _documentAPIList1[i].name.toString());
        }
      }
    }

    /* if (_editModel.blockCustomer == _editModel.blockCustomer) {
      _isSwitched = false;
    } else {
      _isSwitched = true;
    }*/

    /*

    customerID: "",
                          customerName: edt_Customer_Name.text,
                          customerType: edt_Category.text,
                          address: edt_Address.text,
                          area: edt_Area.text,
                          pinCode: edt_Pincode.text,
                          address1: "",
                          area1: "",
                          cityCode1: "",
                          pinCode1: "",
                          gSTNo: edt_GST_Name.text,
                          pANNo: edt_PAN_Name.text,
                          cINNo: "",
                          contactNo1: edt_Customer_Contact1_Name.text,
                          contactNo2: edt_Customer_Contact2_Name.text,
                          emailAddress: edt_Email_Name.text,
                          websiteAddress: edt_Website_Name.text,
                          latitude: "123.000",
                          longitude: "321.000",
                          birthDate: "",
                          anniversaryDate: "",
                          loginUserID: "admin",
                          countryCode: edt_CountryID.text,
                          countryCode1: "",
                          blockCustomer: nofollowupvalue.toString(),
                          customerSourceID: edt_sourceID.text,
                          districtCode: edt_DistrictID.text,
                          talukaCode: edt_TalukaID.text,
                          districtCode1: "",
                          talukaCode1: "",
                          companyId: "8033",
                          stateCode: edt_StateID.text,
                          stateCode1: "",
                          cityCode: edt_CityID.text

    */
  }

  Future<void> getContacts() async {
    _contactsList.clear();
    List<ContactModel> temp = await OfflineDbHelper.getInstance().getContacts();
    _contactsList.addAll(temp);
    setState(() {});
  }

  void getOfflineCustomerCategoryData(
      CustomerCategoryResponse offlineCustomerCategoryData123) {
    for (var i = 0; i < offlineCustomerCategoryData123.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = offlineCustomerCategoryData123.details[i].categoryName;
      all_name_id.pkID = offlineCustomerCategoryData123.details[i].pkID;
      arr_ALL_Name_ID_For_Category.add(all_name_id);
    }
  }

  Future<void> _onTapOfDeleteALLContact() async {
    await OfflineDbHelper.getInstance().deleteContactTable();
  }

  void _OnCustomerContactSucess(CustomerContactSaveResponseState state) async {
    print("CustomerResultMsg1234" +
        " Resp : " +
        state.contactSaveResponse.details[0].column2 +
        " Testttt " +
        state.contactSaveResponse.details[0].column2.toString());
    navigateTo(context, CustomerListScreen.routeName, clearAllStack: true);

    //Navigator.of(context).pop();
  }

  void updateCustomerId(String ReturnCustomerID) {
    _contactsList.forEach((element) {
      element.CustomerID = ReturnCustomerID;
      element.LoginUserID = LoginUserID;
      element.CompanyId = CompanyID.toString();
    });
  }

  _OnCustomerIdToFetchContactDetails(
      CustomerIdToCustomerListResponseState state) {
    for (var i = 0;
        i < state.customerIdToContactListResponse.details.length;
        i++) {
      String CustomerID = state
          .customerIdToContactListResponse.details[i].customerID
          .toString();
      String ContactDesignationName =
          state.customerIdToContactListResponse.details[i].desigName;
      String ContactDesigCode1 = state
          .customerIdToContactListResponse.details[i].contactDesigCode1
          .toString();
      String ContactPerson1 =
          state.customerIdToContactListResponse.details[i].contactPerson1;
      String ContactNumber1 =
          state.customerIdToContactListResponse.details[i].contactNumber1;
      String ContactEmail1 =
          state.customerIdToContactListResponse.details[i].contactEmail1;

      _OnTaptoAddContactDetails(CustomerID, ContactDesignationName,
          ContactDesigCode1, ContactPerson1, ContactNumber1, ContactEmail1);
    }
  }

  _OnTaptoAddContactDetails(
      String CustomerID,
      String ContactDesignationName,
      String ContactDesigCode1,
      String ContactPerson1,
      String ContactNumber1,
      String ContactEmail1) async {
    await OfflineDbHelper.getInstance().insertContact(ContactModel(
        "0",
        CustomerID,
        ContactDesignationName,
        ContactDesigCode1,
        "0",
        ContactPerson1,
        ContactNumber1,
        ContactEmail1,
        "admin"));
  }

  _OnCustomerIdToDeleteAllContactResponse(
      CustomerIdToDeleteAllContactResponseState state) {
    print("CustomerDeletteAllContact" +
        " Resp : " +
        state.response.details[0].column2.toString());
  }

  void _OnCustomerCategoryCallEventResponse(
      CustomerCategoryCallEventResponseState state) {
    arr_ALL_Name_ID_For_Category.clear();
    if (state.categoryResponse.details != 0) {
      for (var i = 0; i < state.categoryResponse.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.categoryResponse.details[i].categoryName;
        arr_ALL_Name_ID_For_Category.add(all_name_id);
      }

      if (arr_ALL_Name_ID_For_Category.length != 0) {
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_Category,
            context1: context,
            controller: edt_Category,
            lable: "Select Category");
      }
    }
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
                : _searchDetails.countryCode),
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

  Ladger() {
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
                  "Ledger Balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: Container(child: Icon(Icons.currency_rupee)),
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
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text("Opening",
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
                                            controller: edt_openingBalance,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 10),
                                              counterText: "",
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text("Debit",
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
                                            enabled: false,
                                            controller: edt_debitBalance,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 10),
                                              counterText: "",
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text("Credit",
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
                                            enabled: false,
                                            controller: edt_creditBalance,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 10),
                                              counterText: "",
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text("Closing",
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
                                            enabled: false,
                                            controller: edt_closingBalance,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 10),
                                              counterText: "",
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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

  void _onUploadDocumentResponse(
      CustomerUploadDocumentResponseState state) async {
    //print("sdffg" + state.designationApiResponse.totalCount.t);

    await showCommonDialogWithSingleOption(Globals.context, state.HeaderMsg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, CustomerListScreen.routeName, clearAllStack: true);
    });
  }

  void getDetailsOfImage(String docURLFromListing, String docname) async {
    await urlToFile(docURLFromListing, docname.toString());
  }

  urlToFile(String imageUrl, String filenamee) async {
    if (Uri.parse(imageUrl).isAbsolute == true) {
      try {
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

          MultipleVideoList.add(file);
        }
      } catch (e) {
        print("775757" + e.toString());
      }

      setState(() {});
    }
  }

  void _onCustomerDeletedocumentSucess(
      CustomerDeleteDocumentResponseState state) {
    print("documentdelete" +
        state.customerDeleteDocumentResponse.details[0].column2);
  }
}
