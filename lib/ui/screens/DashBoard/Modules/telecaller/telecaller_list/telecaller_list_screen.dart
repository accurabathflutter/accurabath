import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/telecaller/telecaller_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/tele_caller_search_by_name_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/telecaller_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_type_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/tele_caller_search_by_name_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/telecaller_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/telecaller_followup_history_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/FollowUpDialog/telecaller_followup_ADD_EDIT_Screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/telecaller_add_edit/telecaller_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

///import 'package:whatsapp_share/whatsapp_share.dart';

class TeleCallerListScreen extends BaseStatefulWidget {
  static const routeName = '/TeleCallerListScreen';

  @override
  _TeleCallerListScreenState createState() => _TeleCallerListScreenState();
}

class _TeleCallerListScreenState extends BaseState<TeleCallerListScreen>
    with BasicScreen, WidgetsBindingObserver {
  TeleCallerBloc _expenseBloc;
  int _pageNo = 0;
  bool isListExist = false;

  TeleCallerListResponse _expenseListResponse;
  TeleCallerOnlyNameDetails _externalDetails;
  bool expanded = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _key;
  String foos = 'One';
  int selected = 0; //attention
  bool isExpand = false;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  // ExpenseTypeResponse _offlineExpenseType;
  int CompanyID = 0;
  String LoginUserID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();

  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  bool isDeleteVisible = true;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];

  MenuRightsResponse _menuRightsResponse;

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorDarkYellow;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    LeadStatus();
    // _offlineExpenseType = SharedPrefHelper.instance.getExpenseType();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    //_onExpenseTypeSuccessResponse(_offlineExpenseType);
    edt_FollowupStatus.text = "Account";
    edt_LeadStatus.text = "ALL Leads";
    _expenseBloc = TeleCallerBloc(baseBloc);

    getUserRights(_menuRightsResponse);

    // _expenseBloc..add(ExpenseEmployeeListCallEvent(AttendanceEmployeeListRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID)));
    //_expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID)));
    // edt_LeadStatus.addListener(followerEmployeeList);
    //edt_FollowupEmployeeList.addListener(followerEmployeeList);
    _expenseBloc
      ..add(TeleCallerListCallEvent(
          1,
          TeleCallerListRequest(
              pkID: "",
              acid: "",
              LeadStatus:
                  edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));

    //_expenseBloc.add(TeleCallerSearchByIDCallEvent(TeleCallerSearchRequest(CompanyId: CompanyID.toString(),word: "",needALL: "0",LoginUserID: LoginUserID,LeadStatus: edt_LeadStatus.text=="ALL Leads"?"":edt_LeadStatus.text.toString())));

    isExpand = false;
    isDeleteVisible =
        true; //viewvisiblitiyAsperClient(SerailsKey:_offlineLoggedInData.details[0].serialKey,RoleCode: _offlineLoggedInData.details[0].roleCode );
  }

  /* followupStatusListener(){
    print("Current status Text is ${edt_FollowupStatus.text}");

    _expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0")));


  }*/

  /* followerEmployeeList(){
    print("CurrentEMP Text is ${edt_FollowupEmployeeList.text+ " USERID : " + edt_FollowupEmployeeUserID.text}");
    _expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0")));
    setState(() {

    });
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _expenseBloc,
      //_expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0"))),
      child: BlocConsumer<TeleCallerBloc, TeleCallerStates>(
        builder: (BuildContext context, TeleCallerStates state) {
          if (state is TeleCallerListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is TeleCallerSearchByIDResponseState) {
            _onInquirySearchCallSuccess(state);
          }

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is TeleCallerListCallResponseState ||
              currentState is TeleCallerSearchByIDResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, TeleCallerStates state) {
          if (state is TeleCallerDeleteCallResponseState) {
            _onExpenseRequestDeleteCallSucess(state, context);
          }
          /* if (state is ExpenseDeleteCallResponseState) {
            _onExpenseRequestDeleteCallSucess(state,context);
          }
          if (state is ExpenseTypeCallResponseState) {
            _onLeaveRequestTypeSuccessResponse(state);
          }*/
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is TeleCallerDeleteCallResponseState) {
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
          title: Text('TeleCaller List'),
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
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // _expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID)));
                    _expenseBloc.add(TeleCallerListCallEvent(
                        1,
                        TeleCallerListRequest(
                            pkID: "",
                            acid: "",
                            LeadStatus: edt_LeadStatus.text == "ALL Leads"
                                ? ""
                                : edt_LeadStatus.text,
                            LoginUserID: LoginUserID,
                            CompanyId: CompanyID.toString())));

                    getUserRights(_menuRightsResponse);

                    // _expenseBloc.add(TeleCallerSearchByIDCallEvent(TeleCallerSearchRequest(CompanyId: CompanyID.toString(),word: "",needALL: "0",LoginUserID: LoginUserID,LeadStatus: edt_LeadStatus.text=="ALL Leads"?"":edt_LeadStatus.text.toString())));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 20),
                    child: Column(
                      children: [
                        /* Row(children: [
                          Expanded(
                            flex: 2,
                            child: _buildEmplyeeListView(),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSearchView(),
                          ),
                        ]),*/
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
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      /* edt_FollowupEmployeeList.text = "";
                _onTapOfSearchView();*/
                      return showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Wrap(
                              children: [
                                ListTile(
                                  // leading: Icon(Icons.share),
                                  title: Center(
                                    child: Text(
                                      "~~~Filter~~~",
                                      style: TextStyle(color: colorPrimary),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: colorLightGray,
                                ),
                                Container(
                                  height: 5,
                                ),
                                ListTile(
                                  // leading: Icon(Icons.share),
                                  title: _buildEmplyeeListView(),
                                ),
                                ListTile(
                                  // leading: Icon(Icons.copy),
                                  title: _buildSearchView(),
                                ),
                                Container(
                                  height: 10,
                                ),
                                ListTile(
                                  //leading: Icon(Icons.edit),
                                  title: Center(
                                      child: Row(
                                    children: [
                                      Flexible(
                                        child: getCommonButton(baseTheme, () {
                                          Navigator.pop(context);

                                          _expenseBloc.add(TeleCallerListCallEvent(
                                              1,
                                              TeleCallerListRequest(
                                                  pkID: "",
                                                  acid: "",
                                                  LeadStatus:
                                                      edt_LeadStatus.text ==
                                                              "ALL Leads"
                                                          ? ""
                                                          : edt_LeadStatus.text,
                                                  LoginUserID: LoginUserID,
                                                  CompanyId:
                                                      CompanyID.toString(),
                                                  SearchKey:
                                                      edt_FollowupEmployeeList
                                                                  .text.length >
                                                              2
                                                          ? edt_FollowupEmployeeList
                                                              .text
                                                          : "")));
                                          edt_FollowupEmployeeList.text = "";
                                        }, "Submit", radius: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: getCommonButton(baseTheme, () {
                                          Navigator.pop(context);

                                          edt_FollowupEmployeeList.text = "";
                                          _expenseBloc.add(
                                              TeleCallerListCallEvent(
                                                  1,
                                                  TeleCallerListRequest(
                                                      pkID: "",
                                                      acid: "",
                                                      LeadStatus: edt_LeadStatus
                                                                  .text ==
                                                              "ALL Leads"
                                                          ? ""
                                                          : edt_LeadStatus.text,
                                                      LoginUserID: LoginUserID,
                                                      CompanyId: CompanyID
                                                          .toString())));
                                        }, "Close", radius: 15),
                                      ),
                                    ],
                                  )),
                                ),
                                Container(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      CUSTOM_SETTING,
                      width: 32,
                      height: 32,
                    ),
                    backgroundColor: colorPrimary,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () async {
                      // Add your onPressed code here!

                      navigateTo(context, TeleCallerAddEditScreen.routeName);
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: colorPrimary,
                  ),
                ],
              )
            : Container(),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  LeadStatus() {
    arr_ALL_Name_ID_For_LeadStatus.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "ALL Leads";
      } else if (i == 1) {
        all_name_id.Name = "Disqualified";
      } else if (i == 2) {
        all_name_id.Name = "Qualified";
      } else if (i == 3) {
        all_name_id.Name = "InProcess";
      }
      arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
    }
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (isListExist == true) {
      /*return ListView.builder(
        key: Key('selected $selected'),

        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _expenseListResponse.details.length,
      );*/
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
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
          itemCount: _expenseListResponse.details.length,
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_SEARCH_RESULT_FOUND, height: 200, width: 200),
      );
    }
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(TeleCallerListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search

        _expenseListResponse = state.response;
      } else {
        _expenseListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
    if (_expenseListResponse.details.length != 0) {
      isListExist = true;
    } else {
      isListExist = false;
    }
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    // _expenseBloc..add(ExpenseEventsListCallEvent(_pageNo+ 1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID)));
    _expenseBloc.add(TeleCallerListCallEvent(
        _pageNo + 1,
        TeleCallerListRequest(
            pkID: "",
            acid: "",
            LeadStatus:
                edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
    //_expenseBloc.add(TeleCallerSearchByIDCallEvent(TeleCallerSearchRequest(CompanyId: CompanyID.toString(),word:"",needALL: "0",LoginUserID: LoginUserID,LeadStatus: edt_LeadStatus.text=="ALL Leads"?"":edt_LeadStatus.text.toString())));

    /* if (_leaveRequestListResponse.details.length < _leaveRequestListResponse.totalCount) {
       _leaveRequestScreenBloc.add(LeaveRequestCallEvent(_pageNo + 1,LeaveRequestListAPIRequest(CompanyId: CompanyID,LoginUserID: LoginUserID,pkID: "",ApprovalStatus: "",Reason: "")));

     }*/
  }

  ExpantionCustomer(BuildContext context, int index) {
    return _expenseListResponse.details[index].leadSource == "TeleCaller"
        ? Container(
            padding: EdgeInsets.all(15),
            child: ExpansionTileCard(
              initiallyExpanded: false, //attention
              initialElevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              elevation: 1,
              elevationCurve: Curves.easeInOut,
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor: colorTileBG,
              title: Column(
                children: [
                  _expenseListResponse.details[index].companyName.toString() ==
                          ""
                      ? Container()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.home_work,
                                    color: Color(0xff0066b3),
                                    size: 24,
                                  ),
                                ),
                                Text("Company",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xff0066b3),
                                      fontSize: 7,
                                    ))
                              ],
                            ),
                            Container(
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xff0066b3),
                                size: 24,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                _expenseListResponse.details[index].companyName,
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                  _expenseListResponse.details[index].companyName.toString() ==
                          ""
                      ? Container()
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 1,
                        ),
                  _expenseListResponse.details[index].senderName.toString() ==
                          ""
                      ? Container()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.assignment_ind,
                                    color: Color(0xff0066b3),
                                    size: 24,
                                  ),
                                  Text("Sender",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xff0066b3),
                                        fontSize: 7,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xff0066b3),
                                size: 24,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                _expenseListResponse.details[index].senderName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ],
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
                          "Mo." +
                              _expenseListResponse
                                  .details[index].primaryMobileNo,
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
                      color: _expenseListResponse.details[index].leadStatus ==
                              "New"
                          ? Colors.blue
                          : _expenseListResponse.details[index].leadStatus ==
                                  "Qualified"
                              ? Colors.green
                              : _expenseListResponse.details[index].leadStatus
                                          .toLowerCase() ==
                                      "disqualified"
                                  ? Colors.redAccent
                                  : _expenseListResponse
                                              .details[index].leadStatus ==
                                          "InProcess"
                                      ? colorLightGray
                                      : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          _expenseListResponse.details[index].leadStatus,
                          style: TextStyle(
                              color: _expenseListResponse
                                          .details[index].leadStatus ==
                                      "InProcess"
                                  ? colorPrimary
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
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
                  children: [
                    GestureDetector(
                      onTap: () async {
                        //await _makePhoneCall(model.contactNo1);
                        MakeCall.callto(_expenseListResponse
                            .details[index].primaryMobileNo);
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
                        ShareMsg.msg(
                            context,
                            _expenseListResponse
                                .details[index].primaryMobileNo);
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
                        navigateTo(context,
                                FollowUpFromTeleCallerddEditScreen.routeName,
                                arguments:
                                    AddUpdateFollowupFromTeleCallerScreenArguments(
                                        _expenseListResponse.details[index].pkId
                                            .toString()))
                            .then((value) {
                          _expenseBloc.add(TeleCallerListCallEvent(
                              _pageNo + 1,
                              TeleCallerListRequest(
                                  pkID: "",
                                  acid: "",
                                  LeadStatus: edt_LeadStatus.text == "ALL Leads"
                                      ? ""
                                      : edt_LeadStatus.text,
                                  LoginUserID: LoginUserID,
                                  CompanyId: CompanyID.toString())));
                        });

                        //FollowUpFromTeleCallerddEditScreen
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
                                  Icons.add,
                                  size: 24,
                                  color: colorPrimary,
                                ),
                              ),
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
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 10),
                    child: Container(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Card(
                                color: colorBackGroundGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  Text("LeadNo",
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
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
                                                    _expenseListResponse
                                                        .details[index].pkId
                                                        .toString(), //put your own long text here.
                                                    maxLines: 3,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            _fontSize_Title)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: colorCardBG,
                                                  ),
                                                  Text("Query",
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
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
                                                    _expenseListResponse
                                                                .details[index]
                                                                .queryDatetime
                                                                .toString() ==
                                                            ""
                                                        ? "N/A"
                                                        : _expenseListResponse
                                                                .details[index]
                                                                .queryDatetime
                                                                .getFormattedDate(
                                                                    fromFormat:
                                                                        "yyyy-MM-ddTHH:mm:ss",
                                                                    toFormat:
                                                                        "dd-MM-yyyy") ??
                                                            "-", //put your own long text here.
                                                    maxLines: 3,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            _fontSize_Title)),
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
                                            Icons.category,
                                            color: colorCardBG,
                                          ),
                                          Text("Status",
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
                                            _expenseListResponse.details[index]
                                                        .leadStatus ==
                                                    ""
                                                ? "N/A"
                                                : _expenseListResponse
                                                    .details[index]
                                                    .leadStatus, //put your own long text here.
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.assignment_ind,
                                            color: colorCardBG,
                                          ),
                                          Text("Assign",
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
                                            _expenseListResponse
                                                .details[index].employeeName
                                                .toString(), //put your own long text here.
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.assignment_ind,
                                            color: colorCardBG,
                                          ),
                                          Text("Sender",
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
                                            _expenseListResponse.details[index]
                                                        .senderName
                                                        .toString() ==
                                                    ""
                                                ? "N/A"
                                                : _expenseListResponse
                                                    .details[index].senderName
                                                    .toString(), //put your own long text here.
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                  letterSpacing: .3))
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                            _expenseListResponse.details[index]
                                                        .senderMail
                                                        .toString() ==
                                                    ""
                                                ? "N/A"
                                                : _expenseListResponse
                                                    .details[index].senderMail
                                                    .toString(),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.production_quantity_limits,
                                            color: colorCardBG,
                                          ),
                                          Text("Product",
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
                                            _expenseListResponse.details[index]
                                                        .forProduct ==
                                                    ""
                                                ? "N/A"
                                                : _expenseListResponse
                                                    .details[index].forProduct,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            color: colorCardBG,
                                          ),
                                          Text("Created",
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
                                            _expenseListResponse.details[index]
                                                        .createdDate ==
                                                    ""
                                                ? "N/A"
                                                : _expenseListResponse
                                                        .details[index]
                                                        .createdDate
                                                        .getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy HH:mm") ??
                                                    "-",
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
                        // alignment: MainAxisAlignment.spaceAround,
                        alignment: MainAxisAlignment.center,
                        buttonHeight: 40.0,
                        buttonMinWidth: 90.0,
                        children: <Widget>[
                          IsEditRights == true
                              ? GestureDetector(
                                  onTap: () {
                                    _onTapOfEditCustomer(
                                        _expenseListResponse.details[index]);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        CUSTOM_UPDATE,
                                        height: 24,
                                        width: 24,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
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
                                )
                              : Container(),
                          IsDeleteRights == true
                              ? GestureDetector(
                                  onTap: () {
                                    // fkdkdsf
                                    _onTapOfDeleteCustomer(_expenseListResponse
                                        .details[index].pkId);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        CUSTOM_DELETE,
                                        height: 24,
                                        width: 24,
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
                          /* isDeleteVisible == true ? FlatButton(

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    onPressed: () {
                      _onTapOfDeleteCustomer(
                          _expenseListResponse.details[index].pkId);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.delete, color: colorPrimary,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Text(
                          'Delete', style: TextStyle(color: colorPrimary),),
                      ],
                    ),
                  ):Container(),*/
                        ]),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ))
        : Container();
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  ///navigates to search list screen

  ///updates data of inquiry list

  void _onTapOfEditCustomer(TeleCallerListDetails detail) {
    navigateTo(context, TeleCallerAddEditScreen.routeName,
            arguments: AddUpdateTeleCallerScreenArguments(
                _pageNo, edt_LeadStatus.text, detail))
        .then((value) {
      ALL_Name_ID all_name_id = value;
      edt_LeadStatus.text = all_name_id.Name;
      _pageNo = all_name_id.pkID;
      _expenseBloc.add(TeleCallerListCallEvent(
          1,
          TeleCallerListRequest(
              pkID: "",
              acid: "",
              LeadStatus:
                  edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));

      //_expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0")));
    });
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      if (_offlineLoggedInData.details[0].roleCode.toLowerCase().trim() ==
          "admin") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "ALL";
        all_name_id.Name1 = LoginUserID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }

      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  /* void FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for(var i =0 ; i<3;i++)
    {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if(i==0)
      {
        all_name_id.Name = "Pending";
      }
      else if(i==1)
      {
        all_name_id.Name = "Approved";
      }
      else if(i==2)
      {
        all_name_id.Name = "Rejected";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);

    }
  }
*/
  Widget _buildEmplyeeListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Search Customer",
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
                    controller: edt_FollowupEmployeeList,
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
                        hintText: "Search Customer"),
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
    );
  }

  Widget _buildSearchView() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Select Status",
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
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
                      controller: edt_LeadStatus,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                      style: TextStyle(
                          color: Colors.black, // <-- Change this
                          fontSize: 10,
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onExpenseRequestDeleteCallSucess(
      TeleCallerDeleteCallResponseState state, BuildContext buildContext123) {
    print("ExpenseDeleteresponse" +
        " Msg : " +
        state.customerDeleteResponse.details[0].column1.toString());
    navigateTo(buildContext123, TeleCallerListScreen.routeName,
        clearAllStack: true);
  }

  void _onTapOfDeleteCustomer(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this TeleCaller Lead ?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _expenseBloc.add(TeleCallerDeleteCallEvent(
          id, CustomerDeleteRequest(CompanyID: CompanyID.toString())));
    });
  }

  void _onExpenseTypeSuccessResponse(ExpenseTypeResponse state) {
    arr_ALL_Name_ID_For_Folowup_Status.clear();

    for (var i = 0; i < state.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.details[i].expenseTypeName;
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchTeleCallerScreen.routeName,
            arguments: AddUpdateTeleCallerSearchScreenArguments(
                edt_LeadStatus.text == "ALL Leads"
                    ? ""
                    : edt_LeadStatus.text.toString()))
        .then((value) {
      if (value != null) {
        _externalDetails = value;
        edt_FollowupEmployeeList.text = _externalDetails.label;
        /* _inquiryBloc.add(SearchInquiryListByNumberCallEvent(
            SearchInquiryListByNumberRequest(
                searchKey: _searchDetails.label,CompanyId:CompanyID.toString(),LoginUserID: LoginUserID.toString())));*/
        _expenseBloc.add(TeleCallerSearchByIDCallEvent(TeleCallerSearchRequest(
            CompanyId: CompanyID.toString(),
            word: _externalDetails.value.toString(),
            needALL: "0",
            LoginUserID: LoginUserID,
            LeadStatus: edt_LeadStatus.text == "ALL Leads"
                ? ""
                : edt_LeadStatus.text.toString())));
      }
    });
  }

  void _onInquirySearchCallSuccess(TeleCallerSearchByIDResponseState state) {
    _expenseListResponse = state.response;

    isListExist = true;
    /* for(int i=0;i<state.response.details.length;i++)
      {
        print("sddfdf"+state.response.details[i].senderName);
        TeleCallerListDetails teleCallerOnlyNameDetails = new  TeleCallerListDetails();
        teleCallerOnlyNameDetails = state.response.details[i];
        _expenseListResponse.details.add(teleCallerOnlyNameDetails);
      }
*/
    // _expenseListResponse.details.addAll(state.response.details);
  }

  followerEmployeeList() {
    _expenseBloc.add(TeleCallerListCallEvent(
        1,
        TeleCallerListRequest(
            pkID: "",
            acid: "",
            LeadStatus:
                edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString(),
            SearchKey: edt_FollowupEmployeeList.text.length > 2
                ? edt_FollowupEmployeeList.text
                : "")));
    //_expenseBloc.add(TeleCallerSearchByIDCallEvent(TeleCallerSearchRequest(CompanyId: CompanyID.toString(),word: "",needALL: "0",LoginUserID: LoginUserID,LeadStatus: edt_LeadStatus.text=="ALL Leads"?"":edt_LeadStatus.text.toString())));
  }

  Future<void> MoveToTeleCallerfollowupHistoryPage(
      String inquiryNo, String CustomerID) {
    navigateTo(context, TeleCallerFollowupHistoryScreen.routeName,
            arguments:
                TeleCallerFollowupHistoryScreenArguments(inquiryNo, CustomerID))
        .then((value) {});
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgTeleCaller") {
        _expenseBloc.add(UserMenuRightsRequestEvent(
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
}
