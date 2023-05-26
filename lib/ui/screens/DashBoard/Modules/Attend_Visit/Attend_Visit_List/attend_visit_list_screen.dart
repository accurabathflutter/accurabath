import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/attend_visit/attend_visit_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/AttendVisit/attend_visit_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/AttendVisit/attend_visit_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:for_practice_the_app/models/api_responses/attendVisit/attend_visit_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_Add_Edit/attend_visit_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_List/attend_visit_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class AttendVisitListScreen extends BaseStatefulWidget {
  static const routeName = '/AttendVisitListScreen';

  @override
  _AttendVisitListScreenState createState() => _AttendVisitListScreenState();
}

/*class JosKeys {
  static final cardA = GlobalKey<ExpansionTileCardState>();
  static final refreshKey  = GlobalKey<RefreshIndicatorState>();
}*/
class _AttendVisitListScreenState extends BaseState<AttendVisitListScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AttendVisitBloc _complaintScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  MenuRightsResponse _menuRightsResponse;

  int CompanyID = 0;
  String LoginUserID = "";
  int _pageNo = 0;
  AttendVisitListResponse _inquiryListResponse;
  ComplaintSearchDetails _searchDetails;
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  bool expanded = true;
  bool isDeleteVisible = true;
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;

    _complaintScreenBloc = AttendVisitBloc(baseBloc);
    _complaintScreenBloc.add(AttendVisitListCallEvent(
        1,
        AttendVisitListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text)));
    getUserRights(_menuRightsResponse);
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
      child: BlocConsumer<AttendVisitBloc, AttendVisitStates>(
        builder: (BuildContext context, AttendVisitStates state) {
          //handle states
          if (state is AttendVisitListCallResponseState) {
            _onGetListCallSuccess(state);
          }

          /* if (state is ComplaintSearchByIDResponseState) {
            _onSearchByIDCallSuccess(state);
          }*/
          if (state is AttendVisitSearchByIDResponseState) {
            _onSearchbyIDResponse(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          if (currentState is AttendVisitListCallResponseState ||
              currentState is AttendVisitSearchByIDResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, AttendVisitStates state) {
          //handle states
          if (state is AttendVisitDeleteResponseState) {
            _onDeleteCallSuccess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is AttendVisitDeleteResponseState) {
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
          title: Text('Attend Visit List'),
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
                    _searchDetails = null;

                    _complaintScreenBloc.add(AttendVisitListCallEvent(
                        1,
                        AttendVisitListRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: edt_FollowupEmployeeUserID.text)));
                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        Column(children: [
                          _buildEmplyeeListView(),
                          SizedBox(
                            height: 5,
                          ),
                          _buildSearchView(),
                        ]),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 2,
                        ),
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
        floatingActionButton: IsAddRights == true
            ? FloatingActionButton(
                onPressed: () async {
                  // Add your onPressed code here!
                  navigateTo(context, AttendVisitAddEditScreen.routeName);
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )
            : Container(),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
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
          Container(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Text("Select Employee",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 1,
          ),
          InkWell(
            onTap: () {
              showcustomdialog(
                  values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
                  context1: context,
                  controller: edt_FollowupEmployeeList,
                  controllerID: edt_FollowupEmployeeUserID,
                  lable: "Select Employee");
            },
            child: Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                //padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void _onGetListCallSuccess(AttendVisitListCallResponseState state) {
    /*for(var i=0;i<responseState.complaintListResponse.details.length;i++){

    }*/
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        // _searchDetails = null;
        _inquiryListResponse = state.response;
      } else {
        _inquiryListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Text("Search Customer",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 1,
          ),
          Card(
            elevation: 5,
            color: Color(0xffE0E0E0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _searchDetails == null
                          ? "Tap to search customer"
                          : _searchDetails.label,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _searchDetails == null
                              ? colorGrayDark
                              : colorBlack),
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

  showcustomdialogofEmployeeDropDown(
      {List<ALL_Name_ID> values,
      BuildContext context1,
      TextEditingController controller,
      TextEditingController controllerID,
      TextEditingController controller2,
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
                                  controller.text = values[index].Name;
                                  controller2.text = values[index].Name1 == null
                                      ? ""
                                      : values[index].Name1;

                                  _complaintScreenBloc.add(
                                      AttendVisitListCallEvent(
                                          1,
                                          AttendVisitListRequest(
                                              CompanyId: CompanyID.toString(),
                                              LoginUserID: controller2.text)));
                                  /* if(controller2!=null)
                                  {
                                    controller2.text = values[index].Name1==null?"":values[index].Name1;

                                  }*/
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
                                        values[index].Name,
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

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchAttendVisitScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _complaintScreenBloc.add(AttendVisitSearchByIDCallEvent(
            _searchDetails.pkID,
            ComplaintSearchByIDRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: edt_FollowupEmployeeUserID.text)));
      }
    });
  }

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
        key: Key('selected'),
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

  void _onInquiryListPagination() {
    //  _complaintScreenBloc.add(ComplaintListCallEvent(_pageNo + 1,ComplaintListRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID)));
    _complaintScreenBloc.add(AttendVisitListCallEvent(
        _pageNo + 1,
        AttendVisitListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text)));
  }

  ExpantionCustomer(BuildContext context, int index) {
    AttendVisitDetails model = _inquiryListResponse.details[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: Color(0xFFC1E0FA),
          leading: CircleAvatar(
              backgroundColor: Color(0xFF504F4F),
              child: Image.network(
                "http://demo.sharvayainfotech.in/images/profile.png",
                height: 35,
                fit: BoxFit.fill,
                width: 35,
              )),
          title: Text(
            model.customerName,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: GestureDetector(
            child: Text(
              model.visitID.toString(),
              style: TextStyle(
                color: Color(0xFF504F4F),
                fontSize: _fontSize_Title,
              ),
            ),
          ),
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Complaint Date",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintDate == null
                                                ? "N/A"
                                                : model.complaintDate
                                                        .getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy") ??
                                                    "-",
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Complaint No. ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintNo == ""
                                                ? "N/A"
                                                : model.complaintNo,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Visit Type",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.visitType == null
                                                ? "N/A"
                                                : model.visitType,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Charge Type",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.visitChargeType == null
                                                ? "N/A"
                                                : model.visitChargeType
                                                    .toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Visit Charge",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.visitCharge == null
                                                ? "N/A"
                                                : model.visitCharge.toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Status",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintStatus == null
                                                ? "N/A"
                                                : model.complaintStatus,
                                            style: TextStyle(
                                                color: model.complaintStatus ==
                                                        "Open"
                                                    ? colorGreenDark
                                                    : colorRedDark,
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Assign From",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.createdBy == null
                                                ? "N/A"
                                                : model.createdBy,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Assign To",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.employeeName == null
                                                ? "N/A"
                                                : model.employeeName,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Schedule Date",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.preferredDate == null
                                                ? "N/A"
                                                : model.preferredDate
                                                        .getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy") ??
                                                    "-",
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Sch.Time",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.timeFrom +
                                                " - " +
                                                model.timeTo,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
            ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonHeight: 52.0,
                buttonMinWidth: 90.0,
                children: <Widget>[
                  IsEditRights == true
                      ? GestureDetector(
                          onTap: () {
                            _onTapOfEditCustomer(model);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                                color: colorPrimary,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(color: colorPrimary),
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
                            showCommonDialogWithTwoOptions(context,
                                "Are you sure you want to Delete this Attend Visit ?",
                                negativeButtonTitle: "No",
                                positiveButtonTitle: "Yes",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                              _onTapOfDeleteInquiry(model.pkID);
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: colorPrimary,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(color: colorPrimary),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ]),
          ],
        ));
  }

  void _onDeleteCallSuccess(AttendVisitDeleteResponseState state) {
    print("CustomerDeleted" +
        state.attendVisitDeleteResponse.details[0].column1.toString() +
        "");
    _complaintScreenBloc.add(AttendVisitListCallEvent(
        1,
        AttendVisitListRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    //baseBloc.refreshScreen();
    //navigateTo(context, ComplaintPaginationListScreen.routeName, clearAllStack: true);
  }

  void _onTapOfDeleteInquiry(int pkID) {
    _complaintScreenBloc.add(AttendVisitDeleteEvent(AttendVisitDeleteRequest(
        pkID: pkID.toString(), CompanyId: CompanyID.toString())));
    // _complaintScreenBloc.add(ComplaintDeleteCallEvent(pkID, ComplaintDeleteRequest(CompanyId: CompanyID.toString())));
  }

  void _onTapOfEditCustomer(AttendVisitDetails detail) {
    navigateTo(context, AttendVisitAddEditScreen.routeName,
            arguments: AddUpdateVisitScreenArguments(detail))
        .then((value) {
      //_leaveRequestScreenBloc.add(LeaveRequestCallEvent(1,LeaveRequestListAPIRequest(EmployeeID: edt_FollowupEmployeeUserID.text,ApprovalStatus:edt_FollowupStatus.text,Month: "",Year: "",CompanyId: CompanyID )));
      _complaintScreenBloc.add(AttendVisitListCallEvent(
          1,
          AttendVisitListRequest(
              CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    });
  }

  void _onSearchbyIDResponse(AttendVisitSearchByIDResponseState state) {
    _inquiryListResponse = state.complaintSearchByIDResponse;
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

    setState(() {});
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgVisit") {
        _complaintScreenBloc.add(UserMenuRightsRequestEvent(
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
