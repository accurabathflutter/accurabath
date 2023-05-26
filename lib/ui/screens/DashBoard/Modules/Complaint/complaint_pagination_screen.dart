import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/complaint/complaint_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Complaint/complaint_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Complaint/complaint_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class ComplaintPaginationListScreen extends BaseStatefulWidget {
  static const routeName = '/ComplaintPaginationListScreen';

  @override
  _ComplaintPaginationListScreenState createState() =>
      _ComplaintPaginationListScreenState();
}

/*class JosKeys {
  static final cardA = GlobalKey<ExpansionTileCardState>();
  static final refreshKey  = GlobalKey<RefreshIndicatorState>();
}*/
class _ComplaintPaginationListScreenState
    extends BaseState<ComplaintPaginationListScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  ComplaintScreenBloc _complaintScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  int _pageNo = 0;
  ComplaintListResponse _inquiryListResponse;
  ComplaintSearchDetails _searchDetails;
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  bool expanded = true;
  bool isDeleteVisible = true;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _complaintScreenBloc = ComplaintScreenBloc(baseBloc);

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
      create: (BuildContext context) => _complaintScreenBloc
        ..add(ComplaintListCallEvent(
            1,
            ComplaintListRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID))),
      child: BlocConsumer<ComplaintScreenBloc, ComplaintScreenStates>(
        builder: (BuildContext context, ComplaintScreenStates state) {
          //handle states
          if (state is ComplaintListResponseState) {
            _onGetListCallSuccess(state);
          }
          if (state is ComplaintSearchByIDResponseState) {
            _onSearchByIDCallSuccess(state);
          }

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          if (currentState is ComplaintListResponseState ||
              currentState is ComplaintSearchByIDResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ComplaintScreenStates state) {
          //handle states
          if (state is ComplaintDeleteResponseState) {
            _onDeleteCallSuccess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is ComplaintDeleteResponseState) {
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
          title: Text('Complaint List'),
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
                    _complaintScreenBloc.add(ComplaintListCallEvent(
                        1,
                        ComplaintListRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID)));

                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [
                        _buildSearchView(),
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
                  navigateTo(context, ComplaintAddEditScreen.routeName);
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

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void _onGetListCallSuccess(ComplaintListResponseState state) {
    /*for(var i=0;i<responseState.complaintListResponse.details.length;i++){

    }*/
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        // _searchDetails = null;
        _inquiryListResponse = state.complaintListResponse;
      } else {
        _inquiryListResponse.details
            .addAll(state.complaintListResponse.details);
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
            height: 5,
          ),
          Card(
            elevation: 5,
            color: Color(0xffE0E0E0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
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

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchComplaintScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _complaintScreenBloc.add(ComplaintSearchByIDCallEvent(
            _searchDetails.pkID,
            ComplaintSearchByIDRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
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
    _complaintScreenBloc.add(ComplaintListCallEvent(
        _pageNo + 1,
        ComplaintListRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
  }

  ExpantionCustomer(BuildContext context, int index) {
    ComplaintDetails model = _inquiryListResponse.details[index];

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
              model.complaintNo,
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
                                        Text("Complaint Notes ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintNotes == ""
                                                ? "N/A"
                                                : model.complaintNotes,
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
                                        Text("Ref.#",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.referenceNo == null
                                                ? "N/A"
                                                : model.referenceNo,
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
                            _onTapOfDeleteInquiry(model.pkID);
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

  void _onDeleteCallSuccess(ComplaintDeleteResponseState state) {
    print("CustomerDeleted" +
        state.complaintDeleteResponse.details[0].column1.toString() +
        "");
    //baseBloc.refreshScreen();
    navigateTo(context, ComplaintPaginationListScreen.routeName,
        clearAllStack: true);
  }

  void _onTapOfDeleteInquiry(int pkID) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to Delete Complaint Details ?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _complaintScreenBloc.add(ComplaintDeleteCallEvent(
          pkID, ComplaintDeleteRequest(CompanyId: CompanyID.toString())));
    });
  }

  void _onSearchByIDCallSuccess(ComplaintSearchByIDResponseState state) {
    _inquiryListResponse = state.complaintSearchByIDResponse;
  }

  void _onTapOfEditCustomer(ComplaintDetails detail) {
    navigateTo(context, ComplaintAddEditScreen.routeName,
            arguments: AddUpdateComplaintScreenArguments(detail))
        .then((value) {
      //_leaveRequestScreenBloc.add(LeaveRequestCallEvent(1,LeaveRequestListAPIRequest(EmployeeID: edt_FollowupEmployeeUserID.text,ApprovalStatus:edt_FollowupStatus.text,Month: "",Year: "",CompanyId: CompanyID )));
      _complaintScreenBloc.add(ComplaintListCallEvent(
          1,
          ComplaintListRequest(
              CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    });
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgComplaint") {
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
