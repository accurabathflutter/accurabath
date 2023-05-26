import 'dart:developer';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_count_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_filter_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_share_emp_list_request.dart';
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
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/telecaller_followup_history_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_share_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

//import 'package:whatsapp_share/whatsapp_share.dart';

import '../../home_screen.dart';

class FollowupListScreenArguments {
  String EmployeeName;

  FollowupListScreenArguments(this.EmployeeName);
}

class FollowupListScreen extends BaseStatefulWidget {
  static const routeName = '/FollowupListScreen';
  final FollowupListScreenArguments arguments;

  FollowupListScreen(this.arguments);

  @override
  _FollowupListScreenState createState() => _FollowupListScreenState();
}

class _FollowupListScreenState extends BaseState<FollowupListScreen>
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

  String NotificationEmpName = "";
  List<InquirySharedEmpDetails> arr_Inquiry_Share_Emp_List = [];

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  double DEFAULT_HEIGHT_BETWEEN_WIDGET = 3;
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
      NotificationEmpName = widget.arguments.EmployeeName;
    }

    getUserRights(_menuRightsResponse);

    edt_FollowupStatus.text = "Todays";

    FetchFollowupStatusDetails();
    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    /*edt_FollowupStatus.addListener(followupStatusListener);
    edt_FollowupEmployeeList.addListener(followerEmployeeList);
    edt_FollowupEmployeeUserID.addListener(followerEmployeeList);*/
    isExpand = false;

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    _FollowupBloc.add(FollowupFilterListCallEvent(
        edt_FollowupStatus.text,
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10)));

    _FollowupBloc.add(FollowupCountRequestEvent(
        edt_FollowupStatus.text,
        FollowupCountRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            FollowupStatus: edt_FollowupStatus.text)));
  }

  followupStatusListener() {
    print("Current status Text is ${edt_FollowupStatus.text}");
    if (edt_FollowupEmployeeUserID.text == null ||
        edt_FollowupStatus.text == null) {
      _FollowupBloc.add(FollowupFilterListCallEvent(
          "Todays",
          FollowupFilterListRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: edt_FollowupEmployeeUserID.text,
              PageNo: 1,
              PageSize: 10)));
    } else {
      // _FollowupBloc.add(SearchFollowupListByNameCallEvent(SearchFollowupListByNameRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,FollowupStatusID: "",FollowupStatus: edt_FollowupStatus.text,SearchKey: "",Month: "",Year: "")));
      _FollowupBloc.add(FollowupFilterListCallEvent(
          edt_FollowupStatus.text,
          FollowupFilterListRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: edt_FollowupEmployeeUserID.text,
              PageNo: 1,
              PageSize: 10)));
    }
  }

  followerEmployeeList() {
    print(
        "CurrentEMP Text is ${edt_FollowupEmployeeList.text + " USERID : " + edt_FollowupEmployeeUserID.text}");
    if (edt_FollowupEmployeeUserID.text == null ||
        edt_FollowupStatus.text == null) {
      _FollowupBloc.add(FollowupFilterListCallEvent(
          "Todays",
          FollowupFilterListRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: edt_FollowupEmployeeUserID.text,
              PageNo: 1,
              PageSize: 10)));
    } else {
      // _FollowupBloc.add(SearchFollowupListByNameCallEvent(SearchFollowupListByNameRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,FollowupStatusID: "",FollowupStatus: edt_FollowupStatus.text,SearchKey: "",Month: "",Year: "")));
      _FollowupBloc.add(FollowupFilterListCallEvent(
          edt_FollowupStatus.text,
          FollowupFilterListRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: edt_FollowupEmployeeUserID.text,
              PageNo: 1,
              PageSize: 10)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc
        ..add(FollowupFilterListCallEvent(
            edt_FollowupStatus.text,
            FollowupFilterListRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: edt_FollowupEmployeeUserID.text,
                PageNo: 1,
                PageSize: 10))),

      // _FollowupBloc..add(FollowupFilterListCallEvent("todays",FollowupFilterListRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID,PageNo: 1,PageSize: 10))),
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is FollowupFilterListCallResponseState) {
            _onFollowupListCallSuccess(state);
          }

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }

          if (state is FollowUpCountState) {
            _OnFetchTotalCount(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is FollowupFilterListCallResponseState ||
              currentState is UserMenuRightsResponseState ||
              currentState is FollowUpCountState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupDeleteCallResponseState) {
            _onFollowupDeleteCallSucess(state, context);
          }

          if (state is InquiryShareEmpListResponseState) {
            _OnInquiryShareEmpListResponse(state);
          }
          if (state is FollowUpCountState) {
            _OnFetchTotalCount(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is FollowupDeleteCallResponseState ||
              currentState is InquiryShareEmpListResponseState ||
              currentState is FollowUpCountState) {
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
            Align(
              alignment: Alignment.center,
              child: Card(
                color: colorBackGroundGray,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        FinalTotalCount.toString(),
                        //TotalCount.toString(),
                        style: TextStyle(
                            color: colorPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Count",
                        //TotalCount.toString(),
                        style: TextStyle(
                            color: colorPrimary,
                            fontSize: 7,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
                    _FollowupBloc.add(FollowupFilterListCallEvent(
                        edt_FollowupStatus.text,
                        FollowupFilterListRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: edt_FollowupEmployeeUserID.text,
                            PageNo: 1,
                            PageSize: 10)));

                    _FollowupBloc.add(FollowupCountRequestEvent(
                        edt_FollowupStatus.text,
                        FollowupCountRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: edt_FollowupEmployeeUserID.text,
                            FollowupStatus: edt_FollowupStatus.text)));

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
                        /* Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 2),
                          width: double.infinity,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("      Employee",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF000000),
                                                  fontWeight: FontWeight
                                                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                              ),
                                          Icon(
                                            Icons.filter_list_alt,
                                            color: colorGrayDark,
                                          ),
                                          Expanded(
                                            child: Center(
                                                child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xffffff8d),
                                                    Color(0xffffff8d),
                                                    Color(0xffb9f6ca),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: Text(
                                                "Count : " +
                                                    TotalCount.toString(),
                                                style: TextStyle(
                                                    color: colorPrimary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            )),
                                          ),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Status",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF000000),
                                                  fontWeight: FontWeight
                                                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                              ),
                                          Icon(
                                            Icons.filter_list_alt,
                                            color: colorGrayDark,
                                          ),
                                        ]),
                                  ),
                                ),
                              ]),
                        ),

                        SizedBox(
                          height: 5,
                        ),

                        Row(children: [
                          Expanded(
                            flex: 2,
                            child: _buildEmplyeeListView(),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSearchView(),
                          ),
                        ]),*/

                        //_buildSearchView(),
                        Expanded(child: _buildFollowupList())
                      ],
                    ),
                  ),
                ),
              ),

              /*  Padding(
                padding: const EdgeInsets.all(18.0),
                child: _buildSearchView(),//searchUI(Custom_values1),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: _buildFollowupList(),
              ),*/
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn-1",
              onPressed: () async {
                /* edt_FollowupEmployeeList.text = "";
                _onTapOfSearchView();*/
                return showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    return Wrap(
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
                                  _FollowupBloc.add(FollowupFilterListCallEvent(
                                      edt_FollowupStatus.text,
                                      FollowupFilterListRequest(
                                          CompanyId: CompanyID.toString(),
                                          LoginUserID:
                                              edt_FollowupEmployeeUserID.text,
                                          PageNo: 1,
                                          PageSize: 10)));

                                  _FollowupBloc.add(FollowupCountRequestEvent(
                                      edt_FollowupStatus.text,
                                      FollowupCountRequest(
                                          CompanyId: CompanyID.toString(),
                                          LoginUserID:
                                              edt_FollowupEmployeeUserID.text,
                                          FollowupStatus:
                                              edt_FollowupStatus.text)));

                                  Navigator.pop(context);
                                }, "Submit", radius: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: getCommonButton(baseTheme, () {
                                  Navigator.pop(context);
                                  /*edt_FollowupEmployeeList.text = "";

                                  _FollowupBloc.add(FollowupFilterListCallEvent(
                                      "Todays",
                                      FollowupFilterListRequest(
                                          CompanyId: CompanyID.toString(),
                                          LoginUserID: LoginUserID,
                                          PageNo: 1,
                                          PageSize: 10)));*/
                                }, "Close", radius: 15),
                              ),
                            ],
                          )),
                        ),
                        Container(
                          height: 10,
                        ),
                      ],
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
            IsAddRights == true
                ? FloatingActionButton(
                    heroTag: "btn-2",
                    onPressed: () {
                      // Add your onPressed code here!
                      navigateTo(context, FollowUpAddEditScreen.routeName);
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: colorPrimary,
                  )
                : Container(),
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
      ),
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_Folowup_Status,
            context1: context,
            controller: edt_FollowupStatus,
            lable: "Select Status");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Status",
                    style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
                Icon(
                  Icons.filter_list_alt,
                  color: colorGrayDark,
                ),]),*/
          /*  SizedBox(
            height: 5,
          ),
*/
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
                      controller: edt_FollowupStatus,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Select",
                        /* hintStyle: TextStyle(
                    color: Colors.grey, // <-- Change this
                    fontSize: 12,

                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey, // <-- Change this
                    fontSize: 12,

                  ),*/
                      ),
                    ),
                    // dropdown()
                  ),
                  /*Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              showcustomdialog(
                  values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
                  context1: context,
                  controller: edt_FollowupEmployeeList,
                  controller2: edt_FollowupEmployeeUserID,
                  lable: "Select Employee");
            },
            child: Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
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
                        enabled: false,
                        /*  onChanged: (value) => {
                      print("StatusValue " + value.toString() )
                  },*/
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Select"),
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
            ),
          ),
        ],
      ),
    );
  }

  ///builds inquiry list
  Widget _buildFollowupList() {
    if (isListExist == true) {
      /* return ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildFollowupListItem(index);
        },
        shrinkWrap: true,
        itemCount: arr_FollowupList.length,
      );*/
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            _onFollowupListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: ListView.builder(
          key: Key('selected $selected'),
          itemBuilder: (context, index) {
            return _buildFollowupListItem(index);
          },
          shrinkWrap: true,
          itemCount: arr_FollowupList.length,
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
  Widget _buildFollowupListItem(int index) {
    //FilterDetails model = _FollowupListResponse.details[index];

    return ExpantionCustomer(context, index);
  }

  ///builds inquiry row items title and value's common view
  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                /*fontWeight: FontWeight.bold,*/ fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
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
  void _onFollowupListCallSuccess(FollowupFilterListCallResponseState state) {
    /* if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {

        _FollowupListResponse = state.followupFilterListResponse;
      } else {
        _FollowupListResponse.details
            .addAll(state.followupFilterListResponse.details);
      }
      _pageNo = state.newPage;
    }

    if (_FollowupListResponse.details.length != 0) {
      isListExist = true;
      TotalCount = state.followupFilterListResponse.totalCount;
    } else {
      isListExist = false;
      TotalCount = 0;
    }*/

    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        arr_FollowupList.clear();
        for (int i = 0;
            i < state.followupFilterListResponse.details.length;
            i++) {
          arr_FollowupList.add(state.followupFilterListResponse.details[i]);
        }

        if (arr_FollowupList.length != 0) {
          isListExist = true;
          TotalCount = state.followupFilterListResponse.totalCount;
        } else {
          isListExist = false;
          TotalCount = 0;
        }
      } else {
        for (int i = 0;
            i < state.followupFilterListResponse.details.length;
            i++) {
          arr_FollowupList.add(state.followupFilterListResponse.details[i]);
        }

        if (arr_FollowupList.length != 0) {
          isListExist = true;
          TotalCount = state.followupFilterListResponse.totalCount;
        } else {
          isListExist = false;
          TotalCount = 0;
        }
      }

      _pageNo = state.newPage;
    }
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onFollowupListPagination() {
    _FollowupBloc.add(FollowupFilterListCallEvent(
        edt_FollowupStatus.text,
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: _pageNo + 1,
            PageSize: 10)));

    /* if (_FollowupListResponse.details.length < _FollowupListResponse.totalCount) {

    }*/
  }

  ExpantionCustomer(BuildContext context, int index) {
    FilterDetails model = arr_FollowupList[index];

    log("ID:YRRR" +
        " ID: " +
        model.extpkID.toString() +
        "LeadStatus : " +
        model.inquiryStatus.toString());

    //Totcount= _FollowupListResponse.totalCount;
    //  if(_FollowupListResponse.details[index].employeeName == edt_FollowupEmployeeList.text) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ExpansionTileCard(
        /* initialElevation: 5.0,
        elevation: 5.0,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: model.extpkID != 0 ? Color(0xFFD1C5E0) : Color(0xFFFCFCFC),
        expandedColor:
            model.extpkID != 0 ? Color(0xFFD1C5E0) : Color(0xFFC1E0FA),
        leading: CircleAvatar(
            backgroundColor: Color(0xFF504F4F),
            child: */ /*Image.asset(IC_USERNAME,height: 25,width: 25,)*/ /*
                Image.network(
              "http://demo.sharvayainfotech.in/images/profile.png",
              height: 35,
              fit: BoxFit.fill,
              width: 35,
            )),*/

        initialElevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        elevation: 1,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: model.extpkID != 0 ? Color(0xFFD1C5E0) : Color(0xFFFCFCFC),
        expandedColor: model.extpkID != 0 ? Color(0xFFD1C5E0) : colorTileBG,
        /* title: Text(
          model.customerName,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),*/
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
                                child: /*Container(
                                            width:40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: colorPrimary,


                                                              ),
                                            child:
                                            Image.asset(
                                              HISTORY_ICON,
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),*/
                                    Column(
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
                                        FollowupFilterListCallEvent(
                                            value,
                                            FollowupFilterListRequest(
                                                CompanyId: CompanyID.toString(),
                                                LoginUserID:
                                                    edt_FollowupEmployeeUserID
                                                        .text,
                                                PageNo: 1,
                                                PageSize: 10)));
                                  });
                                });

                                //await _makePhoneCall(model.contactNo1);
                                //await _makeSms(model.contactNo1);
                                //  _launchURL(model.contactNo1);
                              },
                              child: /*Container(
                                          width:40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: colorPrimary,


                                                            ),
                                          child:
                                          Image.asset(
                                            HISTORY_ICON,
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),*/
                                  Column(
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
                            model.inquiryNo != ""
                                ? _offlineLoggedInData.details[0].serialKey
                                                .toLowerCase()
                                                .toString() ==
                                            "DOL2-6UH7-PH03-IN5H"
                                                .toLowerCase()
                                                .toString() ||
                                        _offlineLoggedInData
                                                .details[0].serialKey
                                                .toLowerCase()
                                                .toString() ==
                                            "TEST-0000-SI0F-0208"
                                                .toLowerCase()
                                                .toString()
                                    ? GestureDetector(
                                        onTap: () async {
                                          _FollowupBloc.add(
                                              InquiryShareEmpListRequestEvent(
                                                  InquiryShareEmpListRequest(
                                                      InquiryNo:
                                                          model.inquiryNo,
                                                      CompanyId: CompanyID
                                                          .toString())));
                                          // _inquiryBloc..add(InquiryNoToFollowupDetailsRequestCallEvent(model,InquiryNoToFollowupDetailsRequest(InquiryNo:model.inquiryNo,CompanyId: CompanyID.toString(),CustomerID: model.customerID.toString())));
                                        },
                                        child: /*Container(
                                          width:40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: colorPrimary,


                                                            ),
                                          child:
                                          Image.asset(
                                            HISTORY_ICON,
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),*/
                                            Container(
                                          width: 38,
                                          height: 38,
                                          decoration: const BoxDecoration(
                                              color: colorPrimary,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.share,
                                            size: 24,
                                            color: colorWhite,
                                          )),
                                        ),
                                      )
                                    : Container()
                                : Container(),
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
                                          model.nextFollowupDate.getFormattedDate(
                                                      fromFormat:
                                                          "yyyy-MM-ddTHH:mm:ss",
                                                      toFormat: "dd-MM-yyyy") +
                                                  " " +
                                                  model.preferredTime
                                                      .toString() ??
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
                                              edt_FollowupStatus.text = value;
                                              _FollowupBloc.add(
                                                  FollowupFilterListCallEvent(
                                                      value,
                                                      FollowupFilterListRequest(
                                                          CompanyId: CompanyID
                                                              .toString(),
                                                          LoginUserID:
                                                              edt_FollowupEmployeeUserID
                                                                  .text,
                                                          PageNo: _pageNo,
                                                          PageSize: 10)));

                                              _FollowupBloc.add(
                                                  FollowupCountRequestEvent(
                                                      edt_FollowupStatus.text,
                                                      FollowupCountRequest(
                                                          CompanyId: CompanyID
                                                              .toString(),
                                                          LoginUserID:
                                                              edt_FollowupEmployeeUserID
                                                                  .text,
                                                          FollowupStatus:
                                                              edt_FollowupStatus
                                                                  .text)));
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
        state.followupDeleteResponse.details[0].column1.toString() +
        "");

    /* navigateTo(buildContext123, FollowupListScreen.routeName,
        clearAllStack: true);*/
    // baseBloc.refreshScreen();
    /*navigateTo(buildContext123, FollowupListScreen.routeName,
        clearAllStack: true);*/

    showCommonDialogWithSingleOption(
        context, state.followupDeleteResponse.details[0].column1.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _FollowupBloc.add(FollowupFilterListCallEvent(
          edt_FollowupStatus.text,
          FollowupFilterListRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: edt_FollowupEmployeeUserID.text,
              PageNo: 1,
              PageSize: 10)));

      _FollowupBloc.add(FollowupCountRequestEvent(
          edt_FollowupStatus.text,
          FollowupCountRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: edt_FollowupEmployeeUserID.text,
              FollowupStatus: edt_FollowupStatus.text)));
    });
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
}
