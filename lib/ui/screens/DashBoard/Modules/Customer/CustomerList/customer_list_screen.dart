import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/Clients/BlueTone/Customer/blue_tone_customer_add_edit.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/customer/customer_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/city_code_to_customer_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_fetch_document_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_paggination_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/city_code_to_customer_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_fetch_document_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/contact_model.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/customer_add_edit.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerList/search_customer_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

///import 'package:whatsapp_share/whatsapp_share.dart';hatsapp_share/whatsapp_share.dart';
import '../../../home_screen.dart';

class CustomerListScreen extends BaseStatefulWidget {
  static const routeName = '/CustomerListScreen';

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

class _CustomerListScreenState extends BaseState<CustomerListScreen>
    with BasicScreen, WidgetsBindingObserver {
  CustomerBloc _CustomerBloc;
  int _pageNo = 0;
  CustomerDetailsResponse _inquiryListResponse;
  bool expanded = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  SearchDetails _searchDetails;
  String foos = 'One';
  int selected = 0; //attention
  bool isExpand = false;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;
  int CompanyID = 0;
  String LoginUserID = "";
  List<ContactModel> _contactsList = [];

  bool isDeleteVisible = true;

  List<CustomerFetchDocumentResponseDetails> documentAPIList = [];

  @override
  void initState() {
    super.initState();

    screenStatusBarColor = colorDarkYellow;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _CustomerBloc = CustomerBloc(baseBloc);

    getUserRights(_menuRightsResponse);

    isExpand = false;
    getContacts();
    _CustomerBloc
      ..add(CustomerListCallEvent(
          1,
          CustomerPaginationRequest(
              companyId: CompanyID,
              loginUserID: LoginUserID,
              CustomerID: "",
              ListMode: "L",
              lstcontact: _contactsList)));

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc
        ..add(CustomerListCallEvent(
            _pageNo + 1,
            CustomerPaginationRequest(
                companyId: CompanyID,
                loginUserID: LoginUserID,
                CustomerID: "",
                ListMode: "L",
                lstcontact: _contactsList))),
      child: BlocConsumer<CustomerBloc, CustomerStates>(
        builder: (BuildContext context, CustomerStates state) {
          if (state is CustomerListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is SearchCustomerListByNumberCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CustomerListCallResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CustomerStates state) {
          if (state is CustomerDeleteCallResponseState) {
            _onCustomerDeleteCallSucess(state, context);
          }
          if (state is CustomerFetchDocumentResponseState) {
            _onFetchCustomer_document_List(state);
          }

          if (state is CityCodeToCustomerListResponseState) {
            _OnCityCodetoCustomerDetails(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is CustomerDeleteCallResponseState ||
              currentState is CustomerFetchDocumentResponseState ||
              currentState is CityCodeToCustomerListResponseState) {
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
        backgroundColor: colorWhite,
        appBar: NewGradientAppBar(
          title: Text('Customer List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _onTapOfSearchView();
              },
              child: Image.asset(
                CUSTOM_SEARCH,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _CustomerBloc.add(CustomerListCallEvent(
                        1,
                        CustomerPaginationRequest(
                            companyId: CompanyID,
                            loginUserID: LoginUserID,
                            CustomerID: "",
                            ListMode: "L")));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        // _buildSearchView(),
                        Expanded(child: _buildInquiryList())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await _onTapOfDeleteALLContact();

                if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                    "BLG3-AF78-TO5F-NW16") {
                  navigateTo(context, BlueToneCustomer_ADD_EDIT.routeName);
                } else {
                  navigateTo(context, Customer_ADD_EDIT.routeName);
                }
              },
              child: Image.asset(
                CUSTOM_INSERT,
                width: 32,
                height: 32,
              ),
              backgroundColor: colorPrimary,
            )
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.only(left: 5, right: 20),
            child: Text("Search Customer",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 3,
          ),*/
          Card(
            elevation: 5,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 70,
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.only(right: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*Icon(
                    Icons.perm_contact_cal_rounded,
                    color: colorGrayDark,
                  ),*/
                  /* CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.network(
                        "http://demo.sharvayainfotech.in/images/profile.png",
                        height: 30,
                        fit: BoxFit.fill,
                        width: 30,
                      )),
                  Spacer(),
                  Spacer(),*/
                  Text(
                    _searchDetails == null
                        ? "Tap to search customer"
                        : _searchDetails.label,
                    style: baseTheme.textTheme.headline3.copyWith(
                        color: _searchDetails == null
                            ? colorGrayDark
                            : colorBlack),
                  ),
                  Spacer(),
                  Spacer(),
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

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_inquiryListResponse == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
              scrollInfo,
            ) &&
            _searchDetails == null) {
          _onInquiryListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _inquiryListResponse.details.length,
      ),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(CustomerListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _searchDetails = null;
        _inquiryListResponse = state.response;
      } else {
        _inquiryListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    _CustomerBloc.add(CustomerListCallEvent(
        _pageNo + 1,
        CustomerPaginationRequest(
            companyId: CompanyID,
            loginUserID: LoginUserID,
            CustomerID: "",
            ListMode: "L",
            lstcontact: _contactsList)));
  }

  ExpantionCustomer(BuildContext context, int index) {
    CustomerDetails model = _inquiryListResponse.details[index];

    return Container(
        padding: EdgeInsets.all(10),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          elevation: 1,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: colorTileBG,
          /* leading: Image.network(
            "http://demo.sharvayainfotech.in/images/profile.png",
            height: 35,
            width: 35,
          ),*/
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.assignment_ind,
                      color: Color(0xff108dcf),
                      size: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                margin: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Color(0xff108dcf),
                  size: 24,
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Flexible(
                child: Text(
                  model.customerName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Card(
                  color: colorBackGroundGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Mo." + model.contactNo1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: colorPrimary,
                        fontSize: _fontSize_Title,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Closing",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.Closing.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Opening",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.Opening.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                )),
                Flexible(
                    child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Debit",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.Debit.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                )),
                Flexible(
                    child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Credit ",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.Credit.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 30),
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    //await _makePhoneCall(model.contactNo1);
                    MakeCall.callto(model.contactNo1);
                  },
                  child: Column(
                    children: [
                      Card(
                        color: colorBackGroundGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: 35,
                          height: 35,
                          child: Center(
                            child: Icon(
                              Icons.call,
                              size: 24,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      ),
                      Text("Call",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: colorPrimary,
                              fontSize: 7,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    ShareMsg.msg(context, model.contactNo1);
                  },
                  child: Column(
                    children: [
                      Card(
                        color: colorBackGroundGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: 35,
                          height: 35,
                          child: Center(
                            child: Icon(
                              Icons.message,
                              size: 24,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      ),
                      Text("Message",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: colorPrimary,
                              fontSize: 7,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    //await _makePhoneCall(model.contactNo1);
                    _CustomerBloc.add(CustomerFetchDocumentApiRequestEvent(
                        true,
                        model,
                        CustomerFetchDocumentApiRequest(
                            CompanyID: CompanyID.toString(),
                            CustomerID: model.customerID.toString())));
                  },
                  child: Column(
                    children: [
                      Card(
                        color: colorBackGroundGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: 35,
                          height: 35,
                          child: Center(
                            child: Icon(
                              Icons.attachment,
                              size: 24,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      ),
                      Text("Attachments",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: colorPrimary,
                              fontSize: 7,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    /* MapsLauncher.launchCoordinates(
                        21.192572, 72.799736, 'Location');*/

                    if (model.Latitude != "" || model.Longitude != "") {
                      print("jdjfds45" +
                          double.parse(model.Latitude).toString() +
                          " Longitude : " +
                          double.parse(model.Longitude).toString());
                      MapsLauncher.launchCoordinates(
                          double.parse(model.Latitude),
                          double.parse(model.Longitude),
                          'Location In');
                    } else {
                      showCommonDialogWithSingleOption(
                          context, "Location In Not Valid !",
                          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        color: colorBackGroundGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: 35,
                          height: 35,
                          child: Center(
                            child: Image.asset(
                              LOCATION_ICON,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      Text("Location",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: colorPrimary,
                              fontSize: 7,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    _CustomerBloc.add(CityCodeToCustomerListRequestEvent(
                        model.cityCode.toString(),
                        CityCodeToCustomerListRequest(
                            CityCode: model.cityCode.toString(),
                            LoginUserID: LoginUserID,
                            CompanyID: CompanyID.toString())));

                    /* if (model.latitudeIN != "" || model.longitude_IN != "") {
                      print("jdjfds45" +
                          double.parse(model.latitudeIN).toString() +
                          " Longitude : " +
                          double.parse(model.longitude_IN).toString());
                      MapsLauncher.launchCoordinates(
                          double.parse(model.latitudeIN),
                          double.parse(model.longitude_IN),
                          'Location In');
                    } else {
                      showCommonDialogWithSingleOption(
                          context, "Location In Not Valid !",
                          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                        Navigator.of(context).pop();
                      });
                    }*/
                  },
                  child: Column(
                    children: [
                      Card(
                        color: colorBackGroundGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: 35,
                          height: 35,
                          child: Center(
                              child: Icon(
                            Icons.people_alt_rounded,
                            size: 24,
                            color: colorPrimary,
                          )),
                        ),
                      ),
                      Text("Near By City",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: colorPrimary,
                              fontSize: 7,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            color: colorBackGroundGray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.source,
                                                color: colorCardBG,
                                              ),
                                              Text("Category",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorCardBG,
                                                    fontSize: 7,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                                model.customerType == ""
                                                    ? "N/A"
                                                    : model.customerType,
                                                //put your own long text here.
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: _fontSize_Title)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.category,
                                                color: colorCardBG,
                                              ),
                                              Text("Source",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorCardBG,
                                                    fontSize: 7,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                                model.customerSourceName ==
                                                        "--Not Available--"
                                                    ? "N/A"
                                                    : model.customerSourceName,
                                                //put your own long text here.
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: _fontSize_Title)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  color: colorBackGroundGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 12, right: 10, top: 5, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.mobile_friendly,
                                              color: colorCardBG,
                                            ),
                                            Text("Mobile",
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: colorCardBG,
                                                  fontSize: 7,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            model.contactNo1 == ""
                                                ? "N/A"
                                                : model.contactNo1,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontWeight: FontWeight.bold,
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Card(
                                  color: colorBackGroundGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 12, right: 10, top: 5, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              color: colorCardBG,
                                            ),
                                            Text("Email",
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: colorCardBG,
                                                  fontSize: 7,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: Text(
                                              model.emailAddress == ""
                                                  ? "N/A"
                                                  : model.emailAddress,
                                              style: TextStyle(
                                                  color: Color(title_color),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: _fontSize_Title,
                                                  overflow: TextOverflow.clip,
                                                  letterSpacing: .3)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            color: colorBackGroundGray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.home_work,
                                        color: colorCardBG,
                                      ),
                                      Text("Address",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorCardBG,
                                            fontSize: 7,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    child: Text(
                                        model.address == ""
                                            ? "N/A"
                                            : model.address + "," + model.area,
                                        //put your own long text here.
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize_Title)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            color: colorBackGroundGray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.home_work,
                                                color: colorCardBG,
                                              ),
                                              Text("City",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorCardBG,
                                                    fontSize: 7,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Text(
                                                model.cityName == ""
                                                    ? "N/A"
                                                    : model.cityName,
                                                //put your own long text here.
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: _fontSize_Title)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.pin_drop,
                                                color: colorCardBG,
                                              ),
                                              Text("PinCode",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorCardBG,
                                                    fontSize: 7,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                                model.pinCode == ""
                                                    ? "N/A"
                                                    : model.pinCode,
                                                //put your own long text here.
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: _fontSize_Title)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Card(
                            color: colorBackGroundGray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.account_balance,
                                                color: colorCardBG,
                                              ),
                                              Text("State",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorCardBG,
                                                    fontSize: 7,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Text(
                                                model.stateName == ""
                                                    ? "N/A"
                                                    : model.stateName,
                                                //put your own long text here.
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: _fontSize_Title)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.home_work,
                                                color: colorCardBG,
                                              ),
                                              Text("Country",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorCardBG,
                                                    fontSize: 7,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                                model.countryName == ""
                                                    ? "N/A"
                                                    : model.countryName,
                                                //put your own long text here.
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: _fontSize_Title)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: colorCardBG,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 300,
                height: 50,
                child: ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    buttonHeight: 52.0,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          // _onTapOfEditCustomer(model);

                          _CustomerBloc.add(
                              CustomerFetchDocumentApiRequestEvent(
                                  false,
                                  model,
                                  CustomerFetchDocumentApiRequest(
                                      CompanyID: CompanyID.toString(),
                                      CustomerID:
                                          model.customerID.toString())));
                        },
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              CUSTOM_UPDATE,
                              height: 24,
                              width: 24,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                            ),
                            Text(
                              'Update',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorWhite),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      isDeleteVisible == true
                          ? GestureDetector(
                              onTap: () {
                                _onTapOfDeleteInquiry(model.customerID);
                              },
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    CUSTOM_DELETE,
                                    height: 29,
                                    width: 29,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                  ),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: colorWhite),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }

  void _onTapOfDeleteInquiry(int id) {
    print("CUSTID" + id.toString());
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Customer?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _CustomerBloc.add(CustomerDeleteByNameCallEvent(
          id, CustomerDeleteRequest(CompanyID: CompanyID.toString())));
      // _CustomerBloc..add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: CompanyID,loginUserID: LoginUserID,CustomerID: "",ListMode: "L")));
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _CustomerBloc.add(SearchCustomerListByNumberCallEvent(
            CustomerSearchByIdRequest(
                companyId: CompanyID,
                loginUserID: LoginUserID,
                CustomerID: _searchDetails.value.toString())));
        //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));
      }
    });
  }

  ///updates data of inquiry list
  void _onInquiryListByNumberCallSuccess(
      SearchCustomerListByNumberCallResponseState state) {
    _inquiryListResponse = state.response;
  }

  void _onCustomerDeleteCallSucess(
      CustomerDeleteCallResponseState state, BuildContext context) {
    /* _inquiryListResponse.details
        .removeWhere((element) => element.customerID == state.id);*/

    print("CustomerDeleted" +
        state.customerDeleteResponse.details[0].column1.toString() +
        "");
    //baseBloc.refreshScreen();
    navigateTo(context, CustomerListScreen.routeName, clearAllStack: true);
  }

  void _onTapOfEditCustomer(CustomerDetails model,
      List<CustomerFetchDocumentResponseDetails> documentAPIList1) {
    if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "BLG3-AF78-TO5F-NW16" /*||
        _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208"*/
        ) {
      navigateTo(context, BlueToneCustomer_ADD_EDIT.routeName,
              arguments: AddUpdateBlueToneCustomerScreenArguments(
                  model, documentAPIList1))
          .then((value) {
        _CustomerBloc
          ..add(CustomerListCallEvent(
              1,
              CustomerPaginationRequest(
                  companyId: CompanyID,
                  loginUserID: LoginUserID,
                  CustomerID: "",
                  ListMode: "L",
                  lstcontact: _contactsList)));
      });
    } else {
      navigateTo(context, Customer_ADD_EDIT.routeName,
              arguments:
                  AddUpdateCustomerScreenArguments(model, documentAPIList1))
          .then((value) {
        _CustomerBloc
          ..add(CustomerListCallEvent(
              1,
              CustomerPaginationRequest(
                  companyId: CompanyID,
                  loginUserID: LoginUserID,
                  CustomerID: "",
                  ListMode: "L",
                  lstcontact: _contactsList)));
      });
    }
  }

  Future<void> getContacts() async {
    _contactsList.clear();
    _contactsList.addAll(await OfflineDbHelper.getInstance().getContacts());
    setState(() {});
  }

  Future<void> _onTapOfDeleteALLContact() async {
    await OfflineDbHelper.getInstance().deleteContactTable();
  }

  void _onFetchCustomer_document_List(
      CustomerFetchDocumentResponseState state) {
    if (state.customerFetchDocumentResponse.details.length != 0) {
      if (state.isforViewDoc == true) {
        if (state.customerFetchDocumentResponse.details.length != 0) {
          documentAPIList.clear();

          for (int i = 0;
              i < state.customerFetchDocumentResponse.details.length;
              i++) {
            CustomerFetchDocumentResponseDetails
                customerFetchDocumentResponseDetails =
                CustomerFetchDocumentResponseDetails();
            customerFetchDocumentResponseDetails.pkID =
                state.customerFetchDocumentResponse.details[i].pkID;
            customerFetchDocumentResponseDetails.customerID =
                state.customerFetchDocumentResponse.details[i].customerID;
            customerFetchDocumentResponseDetails.name =
                state.customerFetchDocumentResponse.details[i].name;
            ;
            customerFetchDocumentResponseDetails.customerName =
                state.customerFetchDocumentResponse.details[i].customerName;
            customerFetchDocumentResponseDetails.createdBy =
                state.customerFetchDocumentResponse.details[i].createdBy;
            customerFetchDocumentResponseDetails.createdDate =
                state.customerFetchDocumentResponse.details[i].createdDate;

            documentAPIList.add(customerFetchDocumentResponseDetails);
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("View File"),
                      getCommonButton(baseTheme, () {
                        Navigator.pop(context);
                      }, "Close", width: 100, height: 30)
                    ],
                  ),
                  content: Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Row(
                              children: [
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
                                            urlToFile(
                                                _offlineCompanyData
                                                        .details[0].siteURL +
                                                    "/CustomerDocs/" +
                                                    documentAPIList[index]
                                                        .name
                                                        .toString(),
                                                documentAPIList[index].name);
                                          },
                                          child: Text(
                                            documentAPIList[index].name,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: colorPrimary),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: documentAPIList.length,
                      )),
                );
              });
        }
      } else {
        if (state.customerFetchDocumentResponse.details.length != 0) {
          documentAPIList.clear();

          for (int i = 0;
              i < state.customerFetchDocumentResponse.details.length;
              i++) {
            CustomerFetchDocumentResponseDetails
                customerFetchDocumentResponseDetails =
                CustomerFetchDocumentResponseDetails();
            customerFetchDocumentResponseDetails.pkID =
                state.customerFetchDocumentResponse.details[i].pkID;
            customerFetchDocumentResponseDetails.customerID =
                state.customerFetchDocumentResponse.details[i].customerID;
            customerFetchDocumentResponseDetails.name =
                state.customerFetchDocumentResponse.details[i].name;

            customerFetchDocumentResponseDetails.customerName =
                state.customerFetchDocumentResponse.details[i].customerName;
            customerFetchDocumentResponseDetails.createdBy =
                state.customerFetchDocumentResponse.details[i].createdBy;
            customerFetchDocumentResponseDetails.createdDate =
                state.customerFetchDocumentResponse.details[i].createdDate;

            documentAPIList.add(customerFetchDocumentResponseDetails);
          }

          _onTapOfEditCustomer(state.customerDetails, documentAPIList);
        } else {
          _onTapOfEditCustomer(state.customerDetails, documentAPIList);
        }
      }
    } else {
      /*  showCommonDialogWithSingleOption(context, "No Attachments Found !",
          positiveButtonTitle: "OK");*/

      _onTapOfEditCustomer(state.customerDetails, documentAPIList);
    }
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

          // var fileexist = file.exists();

          print("7757sds5sdd7" + file.path);

          try {
            await file.writeAsBytes(response.bodyBytes);
          } catch (e) {
            print("hdfhjfdhh" + e.toString());
          }
          OpenFile.open(file.path);
          // MultipleVideoList.add(file);
        }
      } catch (e) {
        print("775757" + e.toString());
      }

      setState(() {});
    }
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {}
  }

  void NearByCityDialog(BuildContext context,
      List<CityCodeToCustomerListResponseDetails> citytocustomerList) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          colorPrimary, //                   <--- border color
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(
                            15.0) //                 <--- border radius here
                        ),
                  ),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Near By Customers",
                        style: TextStyle(
                            color: colorPrimary, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ))),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close_rounded,
                  color: colorPrimary,
                  size: 24,
                ),
              )
            ],
          ),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              CityCodeToCustomerListResponseDetails model =
                                  citytocustomerList[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorTileBG,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.0),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Customer Name. ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: _fontSize_Title,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.customerName == ""
                                                      ? "N/A"
                                                      : model.customerName,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: _fontSize_Title,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Mobile. ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: _fontSize_Title,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.contactNo1 == ""
                                                      ? "N/A"
                                                      : model.contactNo1,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: _fontSize_Title,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Address. ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: _fontSize_Title,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.address == ""
                                                      ? "N/A"
                                                      : model.address,
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: _fontSize_Title,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("City. ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: _fontSize_Title,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.cityname == ""
                                                      ? "N/A"
                                                      : model.cityname,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: _fontSize_Title,
                                                      letterSpacing: .3))
                                            ],
                                          ),
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
                            itemCount: citytocustomerList.length,
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

  void _OnCityCodetoCustomerDetails(CityCodeToCustomerListResponseState state) {
    NearByCityDialog(context, state.response.details);
  }
}
