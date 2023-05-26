import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_pkId_details_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/followup_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/followup_history_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/followup_pagination_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/telecaller_followup_history_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_share_screen.dart';
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

class BlueToneFollowupNotificationArgument {
  String pkID;

  BlueToneFollowupNotificationArgument(this.pkID);
}

class BlueToneFollowupNotificationDetailScreen extends BaseStatefulWidget {
  static const routeName = '/BlueToneFollowupNotificationDetailScreen';
  BlueToneFollowupNotificationArgument arguments;

  BlueToneFollowupNotificationDetailScreen(this.arguments);

  @override
  _BlueToneFollowupNotificationDetailScreenState createState() =>
      _BlueToneFollowupNotificationDetailScreenState();
}

class _BlueToneFollowupNotificationDetailScreenState
    extends BaseState<BlueToneFollowupNotificationDetailScreen>
    with BasicScreen, WidgetsBindingObserver {
  FollowupBloc _FollowupBloc;
  int _pageNo = 0;
  //FollowupFilterListResponse _FollowupListResponse;
  // FollowerEmployeeListResponse _FollowerEmployeeListResponse;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  List<FilterDetails> arr_FollowupList = [];

  bool expanded = true;
  bool isListExist = false;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff0066b3; //0x66666666;
  int title_color = 0xff0066b3;
  ALL_Name_ID SelectedStatus;
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  int selected = 0; //attention
  bool isExpand = false;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  var _url = "https://api.whatsapp.com/send?phone=91";
  bool isDeleteVisible = true;
  int TotalCount = 0;
  int FinalTotalCount = 0;

  bool _isForUpdate;
  String ispkIDFromNoti = "";

  String NotificationEmpName = "";
  List<InquirySharedEmpDetails> arr_Inquiry_Share_Emp_List = [];

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  double DEFAULT_HEIGHT_BETWEEN_WIDGET = 3;

  String notipkID = "";

  @override
  void initState() {
    super.initState();

    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _FollowupBloc = FollowupBloc(baseBloc);

    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      notipkID = widget.arguments.pkID;
    } else {
      notipkID = "0";
    }

    _FollowupBloc.add(FollowupPkIdDetailsRequestEvent(
        FollowupPkIdDetailsRequest(
            pkID: notipkID,
            LoginUserID: "admin",
            CompanyId: CompanyID.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc
        ..add(FollowupPkIdDetailsRequestEvent(FollowupPkIdDetailsRequest(
            pkID: notipkID,
            LoginUserID: "admin",
            CompanyId: CompanyID.toString()))),
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is FollowupPkIdDetailsResponseState) {
            _OnGetPKIDtoDetialsResponse(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is FollowupPkIdDetailsResponseState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupDeleteCallResponseState) {
            _onFollowupDeleteCallSucess(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is FollowupDeleteCallResponseState) {
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
          title: Text('Followup List'),
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
                    /* navigateTo(context, FollowupListScreen.routeName,
                        clearAllStack: true);*/
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [Expanded(child: _buildFollowupList())],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
      ),
    );
  }

  ///builds inquiry list
  Widget _buildFollowupList() {
    if (arr_FollowupList.isNotEmpty) {
      return ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildFollowupListItem(index);
        },
        shrinkWrap: true,
        itemCount: arr_FollowupList.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_SEARCH_RESULT_FOUND, height: 200, width: 200),
      );
    }
  }

  ///builds row item view of inquiry list
  Widget _buildFollowupListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    FilterDetails model = arr_FollowupList[index];

    return Container(
      padding: EdgeInsets.all(15),
      child: ExpansionTileCard(
        initiallyExpanded: true,
        initialElevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        elevation: 1,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: model.extpkID != 0 ? Color(0xFFD1C5E0) : Color(0xFFFCFCFC),
        expandedColor: model.extpkID != 0 ? Color(0xFFD1C5E0) : colorTileBG,
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.assignment_ind,
                      color: Color(0xff0066b3),
                      size: 24,
                    ),
                  ],
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
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    model.customerName,
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
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            model.inquiryStatusDesc == "--Not Available--" ||
                    model.inquiryStatusDesc == ""
                ? Container()
                : Text(
                    model.inquiryStatusDesc == "--Not Available--"
                        ? ""
                        : model.inquiryStatusDesc,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
            model.timeIn != "" || model.timeOut != ""
                ? Divider(
                    thickness: 1,
                  )
                : Container(),
            model.timeIn != "" || model.timeOut != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: [
                          Text("In-Time : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10)),
                          Text(
                            getTime(model.timeIn),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: colorPrimary),
                          ),
                        ],
                      ),
                      model.timeOut != ""
                          ? Row(
                              children: [
                                Text("Out-Time : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                Text(
                                  getTime(model.timeOut),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: colorPrimary),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  )
                : Container(),
            SizedBox(
              height: 10,
            )
          ],
        ),

        /*Text(model.inquiryStatus, style: TextStyle(
            color: Color(0xFF504F4F),
            fontSize: _fontSize_Title,
          ),),
*/
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                            /*        model.inquiryNo==""?Container() :*/ SizedBox(
                              width: 15,
                            ),
                            Visibility(
                              visible: /*model.inquiryNo==""?false:*/ true,
                              child: GestureDetector(
                                onTap: () async {
                                  //await _makePhoneCall(model.contactNo1);
                                  //await _makeSms(model.contactNo1);
                                  //  _launchURL(model.contactNo1);
                                  model.extpkID.toString().toLowerCase() != "0"
                                      ? MoveToTeleCallerfollowupHistoryPage(
                                          model.extpkID.toString(), "Followup")
                                      : MoveTofollowupHistoryPage(
                                          model.inquiryNo,
                                          model.customerID.toString());

                                  //MoveToTeleCallerfollowupHistoryPage
                                },
                                child: Column(
                                  children: [
                                    Card(
                                      color: colorBackGroundGray,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                model.meetingNotes = "";
                                model.pkID = 0;
                                model.followupDate = "";
                                model.nextFollowupDate = "";
                                model.preferredTime = "";

                                navigateTo(context,
                                        FollowUpAddEditScreen.routeName,
                                        arguments:
                                            AddUpdateFollowupScreenArguments(
                                                model, edt_FollowupStatus.text))
                                    .then((value) {
                                  setState(() {
                                    // followerEmployeeList();

                                    edt_FollowupStatus.text = value;
                                    _FollowupBloc.add(
                                        FollowupPkIdDetailsRequestEvent(
                                            FollowupPkIdDetailsRequest(
                                                pkID: notipkID,
                                                LoginUserID: "admin",
                                                CompanyId:
                                                    CompanyID.toString())));
                                  });
                                });
                              },
                              child: Column(
                                children: [
                                  Card(
                                    color: colorBackGroundGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                  Text("FollowUp",
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
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                Icon(
                                  Icons.mobile_friendly,
                                  color: colorCardBG,
                                ),
                                Text("Mo.",
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
                                  model.contactNo1 == ""
                                      ? "N/A"
                                      : model
                                          .contactNo1, //put your own long text here.
                                  maxLines: 3,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: colorPrimary,
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
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
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
                                          Icons.calendar_today_outlined,
                                          color: colorCardBG,
                                        ),
                                        Text("Start",
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
                                              color: colorPrimary,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: colorCardBG,
                                        ),
                                        Text("Next.",
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
                                          model.nextFollowupDate
                                                  .getFormattedDate(
                                                      fromFormat:
                                                          "yyyy-MM-ddTHH:mm:ss",
                                                      toFormat: "dd-MM-yyyy") ??
                                              "-", //put your own long text here.
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: colorPrimary,
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
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
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
                                          Icons.category,
                                          color: colorCardBG,
                                        ),
                                        Text("Type",
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
                                          model.inquiryStatus ??
                                              "-", //put your own long text here.
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: colorPrimary,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.confirmation_num,
                                          color: colorCardBG,
                                        ),
                                        Text("Lead #",
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
                                          model.inquiryNo == "" ||
                                                  model.inquiryNo == null
                                              ? '-'
                                              : model
                                                  .inquiryNo, //put your own long text here.
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: colorPrimary,
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
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                Icon(
                                  Icons.dehaze_sharp,
                                  color: colorCardBG,
                                ),
                                Text("Notes",
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
                                  model.meetingNotes == "" ||
                                          model.meetingNotes == null
                                      ? '-'
                                      : model
                                          .meetingNotes, //put your own long text here.
                                  maxLines: 3,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: colorPrimary,
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
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
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
                                          Icons.switch_left,
                                          color: colorCardBG,
                                        ),
                                        Text("Followup",
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
                                          model.noFollowup.toString() == "0"
                                              ? 'No'
                                              : "Yes", //put your own long text here.
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: colorPrimary,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.closed_caption_disabled_rounded,
                                          color: colorCardBG,
                                        ),
                                        Text("Reason",
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
                                          model.noFollClosureName ==
                                                      "--Not Available--" ||
                                                  model.noFollClosureName ==
                                                      null ||
                                                  model.noFollClosureName == ""
                                              ? '-'
                                              : model
                                                  .noFollClosureName, //put your own long text here.
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: colorPrimary,
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
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                Icon(
                                  Icons.person_pin_sharp,
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
                                  model.employeeName == "" ||
                                          model.employeeName == null
                                      ? '-'
                                      : model
                                          .employeeName, //put your own long text here.
                                  maxLines: 3,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: colorPrimary,
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
                    /*  SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),

                    _buildTitleWithValueView("Created by", model.createdBy),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    _buildTitleWithValueView(
                        "Created Date",
                        model.createdDate.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd/MM/yyyy")),*/
                    /*Row(children: [
                        Expanded(
                          child: getCommonButton(baseTheme, () {}, "Edit"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: getCommonButton(baseTheme, () {}, "Delete"),
                        ),
                      ]),*/
                  ],
                ),
              ),
            ),
          ),
          /*model.inquirySource.toString().toLowerCase() == "telecaller"
              ? Container()
              : ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                      IsEditRights == true
                          ? GestureDetector(
                              onTap: () {
                                navigateTo(context,
                                        FollowUpAddEditScreen.routeName,
                                        arguments:
                                            AddUpdateFollowupScreenArguments(
                                                model, edt_FollowupStatus.text))
                                    .then((value) {
                                  setState(() {
                                    // followerEmployeeList();
                                    edt_FollowupStatus.text = value;
                                    _FollowupBloc.add(
                                        FollowupFilterListCallEvent(
                                            value,
                                            FollowupFilterListRequest(
                                                CompanyId: CompanyID.toString(),
                                                LoginUserID:
                                                    edt_FollowupEmployeeUserID
                                                        .text,
                                                PageNo: 1,
                                                PageSize: 10000)));
                                  });
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      IsDeleteRights == true
                          ? GestureDetector(
                              onTap: () {
                                //  cardA.currentState?.collapse();
                                //new ExpansionTileCardState().collapse();
                                _onTapOfDeleteCustomer(model.pkID);
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ]),*/

          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          SizedBox(
            height: 10,
          ),
          IsEditRights == false &&
                  IsDeleteRights == false &&
                  model.inquirySource.toString().toLowerCase() == "telecaller"
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

                                          navigateTo(
                                                  context,
                                                  FollowUpAddEditScreen
                                                      .routeName,
                                                  arguments:
                                                      AddUpdateFollowupScreenArguments(
                                                          model,
                                                          edt_FollowupStatus
                                                              .text))
                                              .then((value) {
                                            setState(() {
                                              print("testDFDdfdF" +
                                                  "PageNo : " +
                                                  _pageNo.toString());
                                              // followerEmployeeList();
                                              _FollowupBloc.add(
                                                  FollowupPkIdDetailsRequestEvent(
                                                      FollowupPkIdDetailsRequest(
                                                          pkID: notipkID,
                                                          LoginUserID: "admin",
                                                          CompanyId: CompanyID
                                                              .toString())));
                                            });
                                          });
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
                                    _onTapOfDeleteCustomer(model.pkID);
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

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Todays";
      } else if (i == 1) {
        all_name_id.Name = "Missed";
      } else if (i == 2) {
        all_name_id.Name = "Future";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
    if (NotificationEmpName.toString() != "") {
      for (int i = 0; i < arr_ALL_Name_ID_For_Folowup_EmplyeeList.length; i++) {
        print("sdlfjddff" +
            " Body :" +
            NotificationEmpName +
            " ArrayItem : " +
            arr_ALL_Name_ID_For_Folowup_EmplyeeList[i].Name);
        if (NotificationEmpName.trim().toString().toLowerCase() ==
            arr_ALL_Name_ID_For_Folowup_EmplyeeList[i]
                .Name
                .trim()
                .toString()
                .toLowerCase()) {
          edt_FollowupEmployeeList.text =
              arr_ALL_Name_ID_For_Folowup_EmplyeeList[i].Name;
          edt_FollowupEmployeeUserID.text =
              arr_ALL_Name_ID_For_Folowup_EmplyeeList[i].Name1.toString();

          print("dsljdfj12" + arr_ALL_Name_ID_For_Folowup_EmplyeeList[i].Name);
          break;
        } else {
          print("dsljdfj" + arr_ALL_Name_ID_For_Folowup_EmplyeeList[i].Name);
        }
      }
    }
    setState(() {});
  }

  void _onTapOfDeleteCustomer(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Followup?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _FollowupBloc.add(FollowupDeleteByNameCallEvent(
          id, FollowupDeleteRequest(CompanyId: CompanyID.toString())));
    });
  }

  void _onFollowupDeleteCallSucess(
      FollowupDeleteCallResponseState state, BuildContext buildContext123) {
    /* _FollowupListResponse.details
        .removeWhere((element) => element.pkID == state.id);*/
    print("CustomerDeleted" +
        state.followupDeleteResponse.details[0].toString() +
        "");
    // baseBloc.refreshScreen();
    navigateTo(buildContext123, FollowupListScreen.routeName,
        clearAllStack: true);
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo, String CustomerID) {
    navigateTo(context, FollowupHistoryScreen.routeName,
            arguments: FollowupHistoryScreenArguments(inquiryNo, CustomerID))
        .then((value) {});
  }

  Future<void> MoveToTeleCallerfollowupHistoryPage(
      String inquiryNo, String CustomerID) {
    navigateTo(context, TeleCallerFollowupHistoryScreen.routeName,
            arguments:
                TeleCallerFollowupHistoryScreenArguments(inquiryNo, CustomerID))
        .then((value) {});
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

  void _onTapOfSahreInquiry(
      List<InquirySharedEmpDetails> arr_inquiry_share_emp_list) {
    navigateTo(context, InquiryShareScreen.routeName,
            arguments:
                AddInquiryShareScreenArguments(arr_inquiry_share_emp_list))
        .then((value) {});
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgFollowup") {
        _FollowupBloc.add(UserMenuRightsRequestEvent(
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

  void _OnFetchTotalCount(FollowUpCountState state) {
    FinalTotalCount =
        state.count.toString() == "" ? 0 : int.parse(state.count.toString());
  }

  void _OnGetPKIDtoDetialsResponse(FollowupPkIdDetailsResponseState state) {
    print("Fdetails" +
        state.followupPkIdDetailsResponse.details[0].rowNum.toString());
    if (state.followupPkIdDetailsResponse.details.isNotEmpty) {
      arr_FollowupList.clear();

      FilterDetails filterDetails = FilterDetails();

      filterDetails.rowNum =
          state.followupPkIdDetailsResponse.details[0].rowNum;
      filterDetails.pkID = state.followupPkIdDetailsResponse.details[0].pkID;
      filterDetails.inquiryNo =
          state.followupPkIdDetailsResponse.details[0].inquiryNo;
      filterDetails.inquiryDate =
          state.followupPkIdDetailsResponse.details[0].inquiryDate;
      filterDetails.extpkID =
          0; //state.followupPkIdDetailsResponse.details[0].extpkID;
      filterDetails.customerID =
          state.followupPkIdDetailsResponse.details[0].customerID;
      filterDetails.customerName =
          state.followupPkIdDetailsResponse.details[0].customerName;
      filterDetails.meetingNotes =
          state.followupPkIdDetailsResponse.details[0].meetingNotes;
      filterDetails.followupDate =
          state.followupPkIdDetailsResponse.details[0].followupDate;
      filterDetails.nextFollowupDate =
          state.followupPkIdDetailsResponse.details[0].nextFollowupDate;
      filterDetails.rating =
          state.followupPkIdDetailsResponse.details[0].rating;
      filterDetails.noFollowup =
          state.followupPkIdDetailsResponse.details[0].noFollowup == false
              ? 0
              : 1;
      filterDetails.inquiryStatusID =
          state.followupPkIdDetailsResponse.details[0].inquiryStatusID;
      filterDetails.followupStatusID =
          state.followupPkIdDetailsResponse.details[0].FollowupStatusID;
      filterDetails.inquiryStatus =
          state.followupPkIdDetailsResponse.details[0].inquiryStatus;
      filterDetails.followupStatus =
          state.followupPkIdDetailsResponse.details[0].FollowupStatus;
      filterDetails.inquirySource =
          state.followupPkIdDetailsResponse.details[0].inquirySource;
      filterDetails.inquiryStatusDesc =
          state.followupPkIdDetailsResponse.details[0].inquiryStatusDesc;
      filterDetails.inquiryStatusDescID =
          state.followupPkIdDetailsResponse.details[0].InquiryStatus_Desc_ID;
      filterDetails.followupPriority =
          state.followupPkIdDetailsResponse.details[0].FollowupPriority;
      filterDetails.employeeName =
          state.followupPkIdDetailsResponse.details[0].employeeName;
      filterDetails.quotationNo =
          state.followupPkIdDetailsResponse.details[0].quotationNo;
      filterDetails.latitude =
          state.followupPkIdDetailsResponse.details[0].latitude;
      filterDetails.longitude =
          state.followupPkIdDetailsResponse.details[0].longitude;
      filterDetails.preferredTime =
          state.followupPkIdDetailsResponse.details[0].preferredTime;
      filterDetails.contactNo1 =
          state.followupPkIdDetailsResponse.details[0].contactNo1;
      filterDetails.contactNo2 =
          state.followupPkIdDetailsResponse.details[0].contactNo2;
      filterDetails.noFollClosureID =
          state.followupPkIdDetailsResponse.details[0].noFollClosureID;
      filterDetails.noFollClosureName =
          state.followupPkIdDetailsResponse.details[0].noFollClosureName;
      filterDetails.contactPerson1 =
          state.followupPkIdDetailsResponse.details[0].contactPerson1;
      filterDetails.contactNumber1 =
          state.followupPkIdDetailsResponse.details[0].contactNumber1;
      filterDetails.FollowUpImage =
          state.followupPkIdDetailsResponse.details[0].FollowUpImage;
      filterDetails.timeIn =
          state.followupPkIdDetailsResponse.details[0].TimeIn;
      filterDetails.timeOut =
          state.followupPkIdDetailsResponse.details[0].TimeOut;

      arr_FollowupList.add(filterDetails);
    }
  }
}
