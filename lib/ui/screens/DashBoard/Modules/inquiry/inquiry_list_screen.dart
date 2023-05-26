import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:for_practice_the_app/Clients/BlueTone/Inquiry/AddEdit/bluetone_inquiry_add_edit.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/InquiryShareModel.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_followup_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_search_by_pk_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_share_emp_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_list_reponse.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_no_to_product_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/search_inquiry_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/followup_history_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_add_edit.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_fillter/FollowupFromInquiry.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_product_shortcut_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_share_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/search_inquiry_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

///import 'package:whatsapp_share/whatsapp_share.dart';ge:whatsapp_share/whatsapp_share.dart';
import '../../home_screen.dart';
import 'inquiry_fillter/inquiry_filter_screen.dart';

class MessageArguments {
  /// The RemoteMessage
  final RemoteMessage message;

  /// Whether this message caused the application to open.
  final bool openedApplication;

  // ignore: public_member_api_docs
  MessageArguments(this.message, this.openedApplication);
}

class InquiryListScreen extends BaseStatefulWidget {
  static const routeName = '/inquiryListScreen';
  MessageArguments arguments;

  InquiryListScreen(this.arguments);

  @override
  _InquiryListScreenState createState() => _InquiryListScreenState();
}

class _InquiryListScreenState extends BaseState<InquiryListScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  int _pageNo = 0;
  InquiryListResponse _inquiryListResponse;
  bool expanded = true;
  var color = Color(0xFFFCFCFC);

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff0066b3; //0x66666666;
  int title_color = 0xff0066b3;
  SearchInquiryDetails _searchDetails;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;

  int CompanyID = 0;
  String LoginUserID = "";
  var _url = "https://api.whatsapp.com/send?phone=91";
  FilterDetails followupHistoryDetails;
  bool isDeleteVisible = true;
  GlobalKey<NavigatorState> _yourKey = GlobalKey<NavigatorState>();
  List<InquiryShareModel> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  List<InquirySharedEmpDetails> arr_Inquiry_Share_Emp_List = [];
  List<InquirySharedEmpDetails> temparr_inquiry_share_emp_list = [];

  double DEFAULT_HEIGHT_BETWEEN_WIDGET = 3;

  String INQ = "";
  CustomerDetails customerDetails = CustomerDetails();

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  List<ALL_Name_ID> arr_EmployeeList = [];

  final TextEditingController edt_loginUserID = TextEditingController();
  final TextEditingController edt_employeeName = TextEditingController();
  final TextEditingController edt_employeeID = TextEditingController();

  final TextEditingController edt_customerName = TextEditingController();
  final TextEditingController edt_customerpkID = TextEditingController();

  //

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    edt_employeeName.text = _offlineLoggedInData.details[0].employeeName;
    edt_employeeID.text = _offlineLoggedInData.details[0].employeeID.toString();
    _inquiryBloc = InquiryBloc(baseBloc);

    getUserRights(_menuRightsResponse);

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    edt_loginUserID.text = LoginUserID;
    edt_customerName.text = "";
    edt_customerpkID.text = "";

    edt_employeeID.addListener(() {
      /* if (arr_EmployeeList.isNotEmpty) {
        for (int i = 0; i < arr_EmployeeList.length; i++) {
          if (edt_employeeID.text == arr_EmployeeList[i].Name1) {
            LoginUserID = arr_EmployeeList[i].MenuName;
            break;
          }
        }
      }
*/
      _inquiryBloc.add(InquiryListCallEvent(
          1,
          InquiryListApiRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              PkId: "",
              EmployeeID: edt_employeeID.text)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc
        ..add(InquiryListCallEvent(
            1,
            InquiryListApiRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID.toString(),
                PkId: "",
                EmployeeID: edt_employeeID.text))),
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          if (state is InquiryListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is InquirySearchByPkIDResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is InquiryListCallResponseState ||
              currentState is InquirySearchByPkIDResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {
          if (state is InquiryDeleteCallResponseState) {
            _onInquiryDeleteCallSucess(state, context);
          }
          if (state is FollowupHistoryListResponseState) {
            _OnInquiryNoToFollowupDetails(state, context);
          }
          if (state is InquiryShareResponseState) {
            _OnInquiryShareResponseSucess(state);
          }
          if (state is InquiryShareEmpListResponseState) {
            _OnInquiryShareEmpListResponse(state);
          }

          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }

          if (state is InquiryNotoProductResponseState) {
            _OnInquiryNoToProductListResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is InquiryDeleteCallResponseState ||
              currentState is FollowupHistoryListResponseState ||
              currentState is InquiryShareResponseState ||
              currentState is InquiryShareEmpListResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is InquiryNotoProductResponseState) {
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
      onWillPop: () {
        navigateTo(context, HomeScreen.routeName, clearAllStack: true);
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: colorVeryLightCardBG,
        appBar: NewGradientAppBar(
          title: Text('Inquiry List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _onTaptoSearchInquiryView();
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
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _inquiryBloc.add(InquiryListCallEvent(
                        1,
                        InquiryListApiRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID,
                            PkId: "",
                            EmployeeID: edt_employeeID.text)));

                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    /* padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),*/
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        _buildEmplyeeListView(),
                        Expanded(child: _buildInquiryList())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: IsAddRights == true
            ? FloatingActionButton(
                onPressed: () async {
                  await _onTapOfDeleteALLProduct();
                  await _onTapOfDeleteALLPrice();
                  if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "BLG3-AF78-TO5F-NW16") {
                    navigateTo(context, BlueToneInquiryAddEditScreen.routeName);
                  } else {
                    navigateTo(context, InquiryAddEditScreen.routeName);
                  }
                },
                child: Icon(Icons.add),
                heroTag: "fab2",
                backgroundColor: colorPrimary,
              )
            : Container(),
        drawer: build_Drawer(
            context: context,
            UserName: "KISHAN",
            RolCode: LoginUserID.toString()),
      ),
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        //_onTapOfSearchView();

        _onTaptoSearchInquiryView();
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Search Inquiry",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              Icon(
                Icons.filter_list_alt,
                color: colorPrimary,
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
                // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: edt_customerName,
                        enabled: false,
                        style: TextStyle(fontSize: 15),
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
    /*return Theme(
      data: ThemeData(
        //brightness: Brightness.dark,
        primaryColor: Colors.black87,
        accentColor: Colors.black87,
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        //backgroundColor: Colors.amberAccent,
        trailing: isExpanded //assets/collapse_arrow.png
            ? Icon(Icons.arrow_circle_down_rounded)
            : Icon(Icons.arrow_circle_up),
        onExpansionChanged: (bool expanding) =>
            setState(() => isExpanded = expanding),
        title: Container(
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Color.fromRGBO(121, 85, 72, 1)),
              gradient: LinearGradient(
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  // stops: [0.1, 1.0],
                  // tileMode: TileMode.clamp,

                  colors: [
                    isExpanded
                        ? Color.fromRGBO(255, 255, 255, 100)
                        : Color.fromRGBO(197, 181, 176, 1),
                    Color.fromRGBO(197, 181, 176, 1) //closed solid
                  ])),
          child: Text(
            'Header',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        children: <Widget>[Text("Helleoooo")],
      ),
    );*/
  }

  ///builds inquiry row items title and value's common view
  Widget _buildTitleWithValueView(
      String title, String value, String InquirySource, InquiryDetails model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: model.InquirySourceName == "India Mart"
                    ? Color(label_color)
                    : Color(label_color),
                fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        ColorCombination(value, InquirySource, model),
        /*InquirySource == "Close - Success"
            ? Text(value,
                style: TextStyle(
                    fontSize: _fontSize_Title,
                    color:
                        colorGreen) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                )
            : Text(value,
                style:
                    TextStyle(fontSize: _fontSize_Title, color: colorGrayDark)),*/
      ],
    );
  }

  Widget _buildLabelWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12,
                color: Color(
                    0xff030303)) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: baseTheme.textTheme.headline3,
        )
      ],
    );
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(InquiryListCallResponseState state) {
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
    _inquiryBloc.add(InquiryListCallEvent(
        _pageNo + 1,
        InquiryListApiRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID,
            PkId: "",
            EmployeeID: edt_employeeID.text)));

    /* if (_inquiryListResponse.details.length < _inquiryListResponse.totalCount) {
    }*/
  }

  ExpantionCustomer(BuildContext context, int index) {
    InquiryDetails model = _inquiryListResponse.details[index];

    return Container(
      padding: EdgeInsets.all(15),
      child: ExpansionTileCard(
        initialElevation: 5.0,

        /* elevation: 5.0,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: model.InquirySourceName.trim().toString() == "IndiaMart"
            ? Color(0xFFFAF6C3)
            : Color(0xFFFCFCFC),
        expandedColor: model.InquirySourceName.trim().toString() == "IndiaMart"
            ? Color(0xFFFAF6C3)
            : Color(0xFFC1E0FA),*/
        borderRadius: BorderRadius.all(Radius.circular(10)),
        elevation: 1,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: model.InquirySourceName.replaceAll(" ", "")
                    .toLowerCase()
                    .toString()
                    .trim() ==
                "indiamart"
            ? Color(0xFFFAF6C3)
            : Color(0xFFFCFCFC),
        expandedColor: model.InquirySourceName.replaceAll(" ", "")
                    .toLowerCase()
                    .toString()
                    .trim() ==
                "indiamart"
            ? Color(0xFFFAF6C3)
            : colorTileBG,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: model.InquirySourceName.replaceAll(" ", "")
                                .toLowerCase()
                                .toString()
                                .trim() ==
                            "indiamart"
                        ? Color(0xFF8A2CE2)
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ],
        ),
        subtitle: /*Text(
          model.inquiryNo,
          style: TextStyle(
            color: model.InquirySourceName == "India Mart"
                ? Color(0xFF8A2CE2)
                : Color(0xFF8A2CE2),
            fontSize: _fontSize_Title,
          ),
        ),*/
            Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
          child: Row(
            children: [
              Icon(
                Icons.confirmation_num,
                color: Color(0xff108dcf),
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                model.inquiryNo,
                style: TextStyle(
                  color: Color(0xFF504F4F),
                  fontSize: 10,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        MakeCall.callto(model.ContactNo);
                      },
                      child: Container(
                        child: Image.asset(
                          PHONE_CALL_IMAGE,
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        ShareMsg.msg(context, model.ContactNo);
                      },
                      child: Container(
                        child: Image.asset(
                          WHATSAPP_IMAGE,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ])
            ],
          ),
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: true,
                          child: GestureDetector(
                            onTap: () async {
                              MoveTofollowupHistoryPage(
                                  model.inquiryNo, model.customerID.toString());
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
                                        Icons.history,
                                        size: 24,
                                        color: colorPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                Text("History",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: colorPrimary,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () async {
                            _inquiryBloc.add(InquiryShareEmpListRequestEvent(
                                InquiryShareEmpListRequest(
                                    InquiryNo: model.inquiryNo,
                                    CompanyId: CompanyID.toString())));
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
                                    Icons.share,
                                    size: 24,
                                    color: colorPrimary,
                                  )),
                                ),
                              ),
                              Text("Share",
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
                            _inquiryBloc
                              ..add(InquiryNoToFollowupDetailsRequestCallEvent(
                                  model,
                                  InquiryNoToFollowupDetailsRequest(
                                      InquiryNo: model.inquiryNo,
                                      CompanyId: CompanyID.toString(),
                                      CustomerID:
                                          model.customerID.toString())));
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
                                  /*decoration: const BoxDecoration(
                                      color: colorPrimary,
                                      shape: BoxShape.circle),*/
                                  child: Center(
                                      child: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: colorPrimary,
                                  )),
                                ),
                              ),
                              Text("Followup",
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
                            FetchCustomerDetails(model.customerID);
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
                                    Icons.account_box,
                                    size: 24,
                                    color: colorPrimary,
                                  )),
                                ),
                              ),
                              Text("Info.",
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
                            MoveToProductHistoryPage(
                                model.inquiryNo, model.customerID.toString());
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
                                  /*decoration: const BoxDecoration(
                                      color: colorPrimary,
                                      shape: BoxShape.circle),*/
                                  child: Center(
                                      child: Icon(
                                    Icons.shopping_cart,
                                    size: 24,
                                    color: colorPrimary,
                                  )),
                                ),
                              ),
                              Text("Product.",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: colorPrimary,
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                ),
                Card(
                  color: colorBackGroundGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.confirmation_num,
                                      color: colorCardBG,
                                    ),
                                    Text("Lead",
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
                                      model
                                          .inquiryNo, //put your own long text here.
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: colorCardBG,
                                    ),
                                    Text("Inquiry",
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
                                      model.inquiryDate.getFormattedDate(
                                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                              toFormat: "dd-MM-yyyy") ??
                                          "-",
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
                  height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                ),
                Card(
                  color: colorBackGroundGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      model.InquirySourceName.replaceAll(
                                              " ", "") ??
                                          "-", //put your own long text here.
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.category,
                                      color: colorCardBG,
                                    ),
                                    Text("Status",
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
                                  child: Text(model.inquiryStatus ?? "-",
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
                  height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                ),
                Card(
                  color: colorBackGroundGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            Icon(
                              Icons.assignment_ind,
                              color: colorCardBG,
                            ),
                            Text("Ref.",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: colorCardBG,
                                    fontSize: 7,
                                    letterSpacing: .3))
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                              model.referenceName == "" ||
                                      model.referenceName == null
                                  ? '-'
                                  : model
                                      .referenceName, //put your own long text here.
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
                  height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                ),
                Card(
                  color: colorBackGroundGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _inquiryListResponse.details[index].followupDate == ''
                              ? Flexible(
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            color: colorCardBG,
                                          ),
                                          Text("FollowUp",
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
                                            model.followupDate.getFormattedDate(
                                                    fromFormat:
                                                        "yyyy-MM-ddTHH:mm:ss",
                                                    toFormat: "dd-MM-yyyy") ??
                                                "-", //put your own long text here.
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
                              : Container(),
                          Flexible(
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: colorCardBG,
                                    ),
                                    Text("Create",
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
                                      model.createdDate.getFormattedDate(
                                          fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                          toFormat: "dd-MM-yyyy"),
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
                  height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                ),
                Card(
                  color: colorBackGroundGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            Icon(
                              Icons.perm_contact_cal_rounded,
                              color: colorCardBG,
                            ),
                            Text("By",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: colorCardBG,
                                    fontSize: 7,
                                    letterSpacing: .3))
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                              model.createdBy, //put your own long text here.
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
                  height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          SizedBox(
            height: 10,
          ),
          IsEditRights == false && IsDeleteRights == false
              ? Container()
              : Card(
                  color: colorCardBG,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: 300,
                    height: 50,
                    child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        buttonHeight: 52.0,
                        buttonMinWidth: 90.0,
                        children: <Widget>[
                          IsEditRights == true
                              ? Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // _onTapOfEditCustomer(model);

                                          _onTapOfEditInquiry(model);
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
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
                                    ],
                                  ),
                                )
                              : Container(),
                          IsDeleteRights == true
                              ? GestureDetector(
                                  onTap: () {
                                    _onTapOfDeleteInquiry(model.pkID);
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
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchInquiryScreenFilter.routeName).then((value) {
      if (value != null) {
        InquiryDetails model = value;

        /* _inquiryBloc.add(SearchInquiryListByNumberCallEvent(
            SearchInquiryListByNumberRequest(
                searchKey: _searchDetails.label,CompanyId:CompanyID.toString(),LoginUserID: LoginUserID.toString())));*/
        _inquiryBloc.add(InquirySearchByPkIDCallEvent(
            model.pkID.toString(),
            InquirySearchByPkIdRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
      }
    });
  }

  ///updates data of inquiry list
  void _onInquiryListByNumberCallSuccess(
      InquirySearchByPkIDResponseState state) {
    _inquiryListResponse = state.response;
  }

  void _onTapOfEditInquiry(InquiryDetails model) {
    if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
        "BLG3-AF78-TO5F-NW16" ) {
      navigateTo(context, BlueToneInquiryAddEditScreen.routeName,
              arguments: AddUpdateBlueToneInquiryScreenArguments(model))
          .then((value) {
        _inquiryBloc
          ..add(InquiryListCallEvent(
              1,
              InquiryListApiRequest(
                  CompanyId: CompanyID.toString(),
                  LoginUserID: LoginUserID,
                  PkId: "",
                  EmployeeID: edt_employeeID.text)));
      });
    } else {
      navigateTo(context, InquiryAddEditScreen.routeName,
              arguments: AddUpdateInquiryScreenArguments(model))
          .then((value) {
        _inquiryBloc
          ..add(InquiryListCallEvent(
              1,
              InquiryListApiRequest(
                  CompanyId: CompanyID.toString(),
                  LoginUserID: LoginUserID,
                  PkId: "",
                  EmployeeID: edt_employeeID.text)));
      });
    }
  }

  void _onTapOfSahreInquiry(
      List<InquirySharedEmpDetails> arr_inquiry_share_emp_list) {
    navigateTo(context, InquiryShareScreen.routeName,
            arguments:
                AddInquiryShareScreenArguments(arr_inquiry_share_emp_list))
        .then((value) {
      _inquiryBloc
        ..add(InquiryListCallEvent(
            1,
            InquiryListApiRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID,
                PkId: "",
                EmployeeID: edt_employeeID.text)));
    });
  }

  void _onTapOfDeleteInquiry(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Inquiry Request ?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _inquiryBloc.add(InquiryDeleteByNameCallEvent(
          id, FollowupDeleteRequest(CompanyId: CompanyID.toString())));
    });
  }

  void _onInquiryDeleteCallSucess(
      InquiryDeleteCallResponseState state, BuildContext buildContext123) {
    /* _FollowupListResponse.details
        .removeWhere((element) => element.pkID == state.id);*/
    print("CustomerDeleted" +
        state.inquiryDeleteResponse.details[0].column1.toString() +
        "");
    // baseBloc.refreshScreen();
    navigateTo(buildContext123, InquiryListScreen.routeName,
        clearAllStack: true);
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLInquiryProduct();
  }

  Future<void> _onTapOfDeleteALLPrice() async {
    await OfflineDbHelper.getInstance().deleteAllBlueToneProductItems();

    await OfflineDbHelper.getInstance().deleteAllProductPriceList();

    //
  }

//
  Widget ColorCombination(
      String value, String inquirySource, InquiryDetails model) {
    if (inquirySource == "Close - Success") {
      return Text(value,
          style: TextStyle(
              fontSize: _fontSize_Title,
              color:
                  colorGreen) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
          );
    } else if (inquirySource == "Work In Progress") {
      return Text(value,
          style:
              TextStyle(fontSize: _fontSize_Title, color: Color(0xFF0E0EFF)));
    } else {
      return Text(value,
          style: TextStyle(
              fontSize: _fontSize_Title,
              color: model.InquirySourceName == "India Mart"
                  ? colorGrayDark
                  : colorGrayDark));
    }
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo, String CustomerID) {
    navigateTo(context, FollowupHistoryScreen.routeName,
            arguments: FollowupHistoryScreenArguments(inquiryNo, CustomerID))
        .then((value) {});
  }

  Future<void> MoveToProductHistoryPage(String inquiryNo, String CustomerID) {
    navigateTo(context, ProductHistoryScreen.routeName,
            arguments: ProductHistoryScreenArguments(inquiryNo, CustomerID))
        .then((value) {});
  }

  void _OnInquiryNoToFollowupDetails(
      FollowupHistoryListResponseState state, BuildContext context) {
    followupHistoryDetails = FilterDetails();
    if (state.followupHistoryListResponse.details.length != 0) {
      for (var i = 0;
          i < state.followupHistoryListResponse.details.length;
          i++) {
        followupHistoryDetails.pkID = 0;
        followupHistoryDetails.inquiryNo =
            state.followupHistoryListResponse.details[0].inquiryNo;
        followupHistoryDetails.followupDate = "";
        followupHistoryDetails.nextFollowupDate = "";
        followupHistoryDetails.meetingNotes = "";
        followupHistoryDetails.contactNumber1 =
            state.followupHistoryListResponse.details[0].contactNumber1;
        followupHistoryDetails.customerName =
            state.followupHistoryListResponse.details[0].customerName;
        followupHistoryDetails.customerID =
            state.followupHistoryListResponse.details[0].customerID;
        followupHistoryDetails.followupStatus =
            state.followupHistoryListResponse.details[0].followupStatus;
        followupHistoryDetails.followupStatusID =
            state.followupHistoryListResponse.details[0].followupStatusID;
        followupHistoryDetails.followupPriority =
            state.followupHistoryListResponse.details[0].followupPriority;
        followupHistoryDetails.inquiryStatus =
            state.followupHistoryListResponse.details[0].inquiryStatus;
        followupHistoryDetails.inquiryStatusID =
            state.followupHistoryListResponse.details[0].inquiryStatusID;
        followupHistoryDetails.inquiryStatusDesc =
            state.followupHistoryListResponse.details[0].inquiryStatusDesc;
        followupHistoryDetails.noFollClosureName =
            state.followupHistoryListResponse.details[0].noFollClosureName;
        followupHistoryDetails.noFollClosureID =
            state.followupHistoryListResponse.details[0].noFollClosureID;
        followupHistoryDetails.rating =
            state.followupHistoryListResponse.details[0].rating;
        followupHistoryDetails.preferredTime = "";
        followupHistoryDetails.FollowUpImage = "";
      }

      navigateTo(context, FollowUpFromInquiryAddEditScreen.routeName,
              arguments: AddUpdateFollowupFromInquiryScreenArguments(
                  followupHistoryDetails))
          .then((value) {
        _inquiryBloc
          ..add(InquiryListCallEvent(
              1,
              InquiryListApiRequest(
                  CompanyId: CompanyID.toString(),
                  LoginUserID: LoginUserID,
                  PkId: "",
                  EmployeeID: edt_employeeID.text)));
      });
    } else {
      if (state.inquiryDetails != 0) {
        followupHistoryDetails = FilterDetails();
        followupHistoryDetails.customerName = state.inquiryDetails.customerName;
        followupHistoryDetails.customerID = state.inquiryDetails.customerID;
        followupHistoryDetails.inquiryNo = state.inquiryDetails.inquiryNo;
        followupHistoryDetails.pkID = 0;
        followupHistoryDetails.FollowUpImage = "";
        followupHistoryDetails.rating = 0;

        followupHistoryDetails.pkID = 0;
        followupHistoryDetails.followupDate = "";
        followupHistoryDetails.nextFollowupDate = "";
        followupHistoryDetails.meetingNotes = "";
        followupHistoryDetails.contactNumber1 = state.inquiryDetails.ContactNo;
        followupHistoryDetails.followupStatus = "";
        followupHistoryDetails.followupStatusID = 0;
        followupHistoryDetails.followupPriority = 0;
        followupHistoryDetails.inquiryStatus = "";
        followupHistoryDetails.inquiryStatusID = 0;
        followupHistoryDetails.inquiryStatusDesc = "";
        followupHistoryDetails.noFollClosureName = "";
        followupHistoryDetails.noFollClosureID = 0;
        followupHistoryDetails.preferredTime = "";
        followupHistoryDetails.FollowUpImage = "";

        navigateTo(context, FollowUpFromInquiryAddEditScreen.routeName,
                arguments: AddUpdateFollowupFromInquiryScreenArguments(
                    followupHistoryDetails))
            .then((value) {});
      }

      // navigateTo(context, FollowUpAddEditScreen.routeName,clearAllStack: true);
    }
  }

  void _OnInquiryShareResponseSucess(InquiryShareResponseState state) {
    for (var i = 0; i < state.inquiryShareResponse.details.length; i++) {
      print("ResponseMsgShare" +
          "Column1 : " +
          state.inquiryShareResponse.details[0].column1.toString() +
          "\n" +
          "Column2 : " +
          state.inquiryShareResponse.details[0].column2);
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();
    arr_EmployeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        InquiryShareModel all_name_id = InquiryShareModel(
            LoginUserID,
            state.details[i].pkID.toString(),
            CompanyID.toString(),
            "",
            false,
            state.details[i].employeeName);
        /* all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        all_name_id.isChecked = false;*/
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);

        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = state.details[i].employeeName;
        all_name_id1.Name1 = state.details[i].pkID.toString();
        all_name_id1.MenuName = state.details[i].userID;
        arr_EmployeeList.add(all_name_id1);
      }
    }
  }

  showcustomdialogWithCheckBox(
      {List<InquiryShareModel> values,
      BuildContext context1,
      /*TextEditingController controller,
      TextEditingController controllerID,
      TextEditingController controller2,*/
      List<ALL_Name_ID> all_name_id,
      String lable,
      bool isChecked12 = false}) async {
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
                          new ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (BuildContext context, int index) {
                                return new Card(
                                  child: new Container(
                                    padding: new EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        new CheckboxListTile(
                                            activeColor: Colors.pink[300],
                                            dense: true,
                                            //font change
                                            title: new Text(
                                              values[index].EmployeeName,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5),
                                            ),
                                            value: values[index].ISCHECKED,
                                            secondary: Container(
                                              height: 50,
                                              width: 50,
                                            ),
                                            onChanged: (bool val) {
                                              setState(() {
                                                itemChange(val, index, values);
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              }),

                          /*ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            children: values
                                .map(
                                  (InquiryShareModel item) => CheckboxListTile(
                                    title: Text(item.EmployeeName),
                                    value: item.ISCHECKED,
                                    onChanged: (bool val) async {
                                      print(val);
                                      item.ISCHECKED = await val;
                                      setState(() {

                                      });

                                    },
                                  ),
                                )
                                .toList(),
                          ),*/
                          /*  ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 25,
                                        top: 10,
                                        bottom: 10,
                                        right: 10),
                                    child: Row(
                                      children: [



                                      ],
                                    ),
                                  ),
                                );


                              },
                              itemCount: values.length,
                            ),*/
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(90, 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(24.0),
                                ),
                              ),
                            ),
                            child: Text("Share Inquiry"),
                            onPressed: () => {generateShare(values)},
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

  generateShare(List<InquiryShareModel> all_name_id) {
    for (var i = 0; i < all_name_id.length; i++) {
      print("MessageStorate" +
          "EMpName" +
          all_name_id[i].EmployeeName +
          "ISChecked" +
          all_name_id[i].ISCHECKED.toString());
    }
  }

  void itemChange(bool val, int index, List<InquiryShareModel> values) {
    setState(() {
      values[index].ISCHECKED = val;
    });
  }

  void _OnInquiryShareEmpListResponse(InquiryShareEmpListResponseState state) {
    arr_Inquiry_Share_Emp_List.clear();

    if (state.response.totalCount != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        InquirySharedEmpDetails inquirySharedEmpDetails =
            state.response.details[i];
        arr_Inquiry_Share_Emp_List.add(inquirySharedEmpDetails);
      }
    } else {
      InquirySharedEmpDetails inquirySharedEmpDetails =
          InquirySharedEmpDetails();
      inquirySharedEmpDetails.inquiryNo = state.InquiryNo;
      inquirySharedEmpDetails.employeeID =
          _offlineLoggedInData.details[0].employeeID;
      inquirySharedEmpDetails.createdBy =
          _offlineLoggedInData.details[0].userID;
      arr_Inquiry_Share_Emp_List.add(inquirySharedEmpDetails);
    }

    if (arr_Inquiry_Share_Emp_List.length != 0) {
      _onTapOfSahreInquiry(arr_Inquiry_Share_Emp_List);
    }
  }

  void _onTaptoSearchInquiryView() {
    navigateTo(context, SearchInquiryScreen.routeName,
            arguments: AddUpdateSearchInquiryScreenArguments(
                edt_employeeID.text, edt_employeeName.text))
        .then((value) {
      if (value != null) {
        SearchInquiryDetails model = value;
        edt_customerpkID.text = model.pkID.toString();
        edt_customerName.text = model.customerName.toString();
        _inquiryBloc.add(InquirySearchByPkIDCallEvent(
            model.pkID.toString(),
            InquirySearchByPkIdRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
        setState(() {});

        /* _inquiryBloc.add(SearchInquiryListByNumberCallEvent(
            SearchInquiryListByNumberRequest(
                searchKey: _searchDetails.label,CompanyId:CompanyID.toString(),LoginUserID: LoginUserID.toString())));*/
      }
    });
  }

  void FetchCustomerDetails(int customerID321) {
    _inquiryBloc.add(SearchCustomerListByNumberCallEvent(
        CustomerSearchByIdRequest(
            companyId: CompanyID,
            loginUserID: LoginUserID,
            CustomerID: customerID321.toString())));
  }

  void _ONOnlyCustomerDetails(
      SearchCustomerListByNumberCallResponseState state) {
    for (int i = 0; i < state.response.details.length; i++) {
      print("CustomerDetailsw" +
          "CustomerName : " +
          state.response.details[i].customerName +
          " Customer ID : " +
          state.response.details[i].customerID.toString());
    }

    customerDetails = CustomerDetails();
    customerDetails.customerName = state.response.details[0].customerName;
    customerDetails.customerType = state.response.details[0].customerType;
    customerDetails.customerSourceName =
        state.response.details[0].customerSourceName;
    customerDetails.contactNo1 = state.response.details[0].contactNo1;
    customerDetails.emailAddress = state.response.details[0].emailAddress;
    customerDetails.address = state.response.details[0].address;
    customerDetails.area = state.response.details[0].area;
    customerDetails.pinCode = state.response.details[0].pinCode;
    customerDetails.countryName = state.response.details[0].countryName;
    customerDetails.stateName = state.response.details[0].stateName;
    customerDetails.cityName = state.response.details[0].cityName;
    customerDetails.cityName = state.response.details[0].cityName;

    showcustomdialog(
      context1: context,
      customerDetails123: customerDetails,
    );
  }

  showcustomdialog({
    BuildContext context1,
    CustomerDetails customerDetails123,
  }) async {
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
                    "Customer Details",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              customerDetails123.customerName,
                              style: TextStyle(color: colorBlack),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Category  ",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                        .customerType
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Source",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .customerSourceName ==
                                                            "--Not Available--"
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .customerSourceName,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("Contact No1.",
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Color(
                                                              label_color),
                                                          fontSize:
                                                              _fontSize_Label,
                                                          letterSpacing: .3)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      customerDetails123
                                                                  .contactNo1 ==
                                                              ""
                                                          ? "N/A"
                                                          : customerDetails123
                                                              .contactNo1,
                                                      style: TextStyle(
                                                          color: Color(
                                                              title_color),
                                                          fontSize:
                                                              _fontSize_Title,
                                                          letterSpacing: .3))
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () async {
                                                          MakeCall.callto(
                                                              customerDetails123
                                                                  .contactNo1);
                                                        },
                                                        child: Container(
                                                          child: Image.asset(
                                                            PHONE_CALL_IMAGE,
                                                            width: 32,
                                                            height: 32,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          ShareMsg.msg(
                                                              context,
                                                              customerDetails123
                                                                  .contactNo1);
                                                        },
                                                        child: Container(
                                                          child: Image.asset(
                                                            WHATSAPP_IMAGE,
                                                            width: 32,
                                                            height: 32,
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: sizeboxsize,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Email",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Color(label_color),
                                                    fontSize: _fontSize_Label,
                                                    letterSpacing: .3)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                customerDetails123
                                                            .emailAddress ==
                                                        ""
                                                    ? "N/A"
                                                    : customerDetails123
                                                        .emailAddress,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontSize: _fontSize_Title,
                                                    letterSpacing: .3)),
                                          ],
                                        )
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Address",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .address ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .address,
                                                    style:
                                                        TextStyle(
                                                            color: Color(
                                                                title_color),
                                                            fontSize:
                                                                _fontSize_Title,
                                                            letterSpacing: .3)),
                                              ],
                                            ))
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Area",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123.area ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .area,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Pin-Code",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .pinCode ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .pinCode,
                                                    style:
                                                        TextStyle(
                                                            color: Color(
                                                                title_color),
                                                            fontSize:
                                                                _fontSize_Title,
                                                            letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Country",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .countryName
                                                                .toString() ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .countryName
                                                            .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("State",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123.stateName
                                                                .toString() ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .stateName
                                                            .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("City",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .cityName ==
                                                            null
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .cityName,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context1);
                                      },
                                      child: Center(
                                          child: Text(
                                        "Close",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: colorPrimary,
                                            fontWeight: FontWeight.bold),
                                      )))
                                ],
                              ),
                            ),
                          ],
                        ))),
                  ],
                )),
          ],
        );
      },
    );
  }

  void _OnInquiryNoToProductListResponse(
      InquiryNotoProductResponseState state) {
    List<InquiryProductDetails> arr_ProductListArray = [];

    for (var i = 0; i < state.inquiryNoToProductResponse.details.length; i++) {
      /* String LoginUserID="abc";
    String CompanyId="0";
    String InquiryNo="0";*/

      InquiryProductDetails inquiryProductDetails = InquiryProductDetails();

      inquiryProductDetails.productName =
          state.inquiryNoToProductResponse.details[i].productName;

      inquiryProductDetails.quantity =
          state.inquiryNoToProductResponse.details[i].quantity;
      inquiryProductDetails.unitPrice =
          state.inquiryNoToProductResponse.details[i].unitPrice;
      //double totamnt = double.parse(Quantity) * double.parse(UnitPrice);
      // String TotalAmount = totamnt.toString();
      arr_ProductListArray.add(inquiryProductDetails);
    }

    showcustomdialogWithOnlyName(
        values: arr_ProductListArray,
        context1: context,
        lable: "Product Details");
  }

  showcustomdialogWithOnlyName(
      {List<InquiryProductDetails> values,
      BuildContext context1,
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
                                  //controller.text = values[index].Name;
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
                                      Text(
                                        values[index].productName,
                                        style: TextStyle(color: colorPrimary),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        values[index]
                                            .quantity
                                            .toStringAsFixed(2),
                                        style: TextStyle(color: colorPrimary),
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

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgInquiry") {
        _inquiryBloc.add(UserMenuRightsRequestEvent(
            menuRightsResponse.details[i].menuId.toString(),
            UserMenuRightsRequest(
                MenuID: menuRightsResponse.details[i].menuId.toString(),
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
        break;
      }
    }
  }

  void _OnMenuRightsSucess(UserMenuRightsResponseState state) {
    for (int i = 0; i < state.userMenuRightsResponse.details.length; i++) {
      print("DSFsdfkk" +
          " MenuName :" +
          state.userMenuRightsResponse.details[i].addFlag1.toString());

      IsAddRights = state.userMenuRightsResponse.details[i].addFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsEditRights = state.userMenuRightsResponse.details[i].editFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsDeleteRights = state.userMenuRightsResponse.details[i].delFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
    }
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);

        showcustomdialogWithTWOName(
            values: arr_EmployeeList,
            context1: context,
            controller: edt_employeeName,
            controller1: edt_employeeID,
            lable: "Select Employee");
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Select Employee",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              Icon(
                Icons.filter_list_alt,
                color: colorPrimary,
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
                // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: edt_employeeName,
                        enabled: false,
                        style: TextStyle(fontSize: 15),
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
      ),
    );
  }
}
