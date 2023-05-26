import 'dart:collection';
import 'dart:io';

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/todo/todo_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/punch_attendence_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/punch_without_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/constant_master/constant_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_filter_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/toDo_request/to_do_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/to_do_office/to_do_office_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/to_do/todo_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/to_do_office/to_do_office_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/OfficeTODO/office_Followup/office_followup_add_edit.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/OfficeTODO/office_to_do_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home_screen.dart';

class OfficeToDoScreen extends BaseStatefulWidget {
  static const routeName = '/OfficeToDoScreen';

  @override
  _OfficeToDoScreenState createState() => _OfficeToDoScreenState();
}

class _OfficeToDoScreenState extends BaseState<OfficeToDoScreen>
    with BasicScreen, WidgetsBindingObserver {
  ToDoBloc _officeToDoScreenBloc;

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
  final GlobalKey<ScaffoldState> _key123 = GlobalKey(); // Create a key

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  int CompanyID = 0;
  String LoginUserID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  bool pressAttention = true;
  bool pressFAttention = true;

  bool pressAttention1 = true;
  //List<OfficeToDoListResponseDetails> TODOTODAYSLIST=[];


  OfficeToDoListResponse _FollowupTodayListResponse;
  OfficeToDoListResponse _FollowupListPending_OverDueResponse;

  OfficeToDoListResponse _FollowupListOverDueResponse;
  OfficeToDoListResponse _FollowupFutureListResponse;

  OfficeToDoListResponse _FollowupListCompletedResponse;

  FollowupFilterListResponse _FTodaysListResponse;
  FollowupFilterListResponse _FMissedListResponse;
  FollowupFilterListResponse _FFutureListResponse;

  final TextEditingController edt_FollowupEmployeeList =
  TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
  TextEditingController();


  TextEditingController Remarks = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  int _pageNo = 0;
  int TotalTodayCount = 0;
  int TotalOverDueCount = 0;
  int TotalPendingOverDueCount = 0;

  int TotalTodoFutureCount = 0;

  int TotalCompltedCount = 0;


  int _FpageNo = 0;

  int TotalFTodayCount = 0;
  int TotalMissedCount = 0;
  int TotalFutureCount = 0;


  bool IsExpandedTodays = false;
  bool IsExpandedOverDue = false;
  bool IsExpandedPendingOverDue = false;

  bool IsExpandedTodoFuture = false;

  bool IsExpandedCompleted = false;


  bool IsExpandedFTodays = false;
  bool IsExpandedMissed = false;
  bool IsExpandedFuture = false;

  List<ToDoDetails> arrToDoDetails = [];


  ///Attendance Veriables
  bool isPunchIn = false;
  bool isPunchOut = false;
  bool isLunchIn = false;
  bool isLunchOut = false;


  bool isSendEmail = false;

  final TextEditingController PuchInTime = TextEditingController();
  final TextEditingController PuchOutTime = TextEditingController();
  final TextEditingController LunchInTime = TextEditingController();
  final TextEditingController LunchOutTime = TextEditingController();
  final TextEditingController ImgFromTextFiled = TextEditingController();
  String ConstantMAster = "";
  bool isCurrentTime = true;

  bool is_LocationService_Permission;
  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;

  Location location = new Location();
  String MapAPIKey = "";
  String Address = "";

  TextEditingController EmailTO = TextEditingController();
  TextEditingController EmailBCC = TextEditingController();
  String SiteURL = "";
  String Password = "";

  bool isLoading = true;

  final urlController = TextEditingController();
  String url = "";
  bool onWebLoadingStop = false;

  bool islodding = true;

  ContextMenu contextMenu;

  InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  PullToRefreshController pullToRefreshController;
  double progress = 0;
  int prgresss = 0;
  DateTime selectedDate = DateTime.now();


  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorDarkYellow;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;
    edt_FollowupEmployeeList.text = _offlineLoggedInData.details[0].employeeName;

    _officeToDoScreenBloc = ToDoBloc(baseBloc);

    _officeToDoScreenBloc.add(ToDoTodayListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Todays",
        PageNo: 1,
        PageSize: 10000
        )));
    /*_officeToDoScreenBloc.add(ToDoOverDueListCallEvent(ToDoListApiRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Today",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        PageNo: 1,
        PageSize: 10000)));*/


    _officeToDoScreenBloc.add(ToDoFutureListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Future",
        PageNo: 1,
        PageSize: 10000)));
    //
    _officeToDoScreenBloc.add(ToDoOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Pending",
        PageNo: 1,
        PageSize: 10000)));


    _officeToDoScreenBloc.add(ToDoPendingOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Pending-OverDue",
        PageNo: 1,
        PageSize: 10000)));

    //
    _officeToDoScreenBloc.add(ToDoTComplitedListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Completed",
        PageNo: 1,
        PageSize: 10000)));


    _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
        "Todays",
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10000)));

    _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
        "Missed",
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10000)));


    _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
        "Future",
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10000)));

//


    edt_FollowupEmployeeUserID.addListener(followupStatusListener);


    isExpand = false;


    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password = _offlineLoggedInData.details[0].userPassword;
    MapAPIKey = _offlineCompanyData.details[0].MapApiKey;

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    EmailTO.text = "";

    _officeToDoScreenBloc.add(ConstantRequestEvent(
        CompanyID.toString(),
        ConstantRequest(
            ConstantHead: "AttendenceWithImage",
            CompanyId: CompanyID.toString())));

    _officeToDoScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));

    if (_offlineLoggedInData.details[0].EmployeeImage != "" ||
        _offlineLoggedInData.details[0].EmployeeImage != null) {
      setState(() {
        ImgFromTextFiled.text = _offlineCompanyData.details[0].siteURL +
            _offlineLoggedInData.details[0].EmployeeImage.toString();
      });
    } else {
      ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";
    }


    getAddressFromLatLong();

    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _officeToDoScreenBloc,
      //..add(LoanApprovalListCallEvent(LoanApprovalListRequest(pkID: "",ApprovalStatus: edt_FollowupStatus.text,LoginUserID: LoginUserID,CompanyId: CompanyID))),

      child: BlocConsumer<ToDoBloc, ToDoStates>(
        builder: (BuildContext context, ToDoStates state) {
          if (state is ToDoTodayListCallResponseState) {
            _onFollowupTodayListCallSuccess(state);
          }

          if (state is ToDoFutureListCallResponseState) {
            _onTODOFutureListResponse(state);
          }
          if (state is ToDoPendingOverDueListResponseState) {
            _onTo_Do_PendingOverDueListCallSuccess(state);
          }
          if (state is ToDoOverDueListCallResponseState) {
            _onFollowupOverDueListCallSuccess(state);
          }
          if (state is ToDoCompletedListCallResponseState) {
            _onFollowupCompletedListCallSuccess(state);
          }

          if (state is FollowupFilterListCallResponseState) {
            _onTodaysFollowupResponse(state);
          }
          if (state is FollowupMissedFilterListCallResponseState) {
            _onMissedFollowupResponse(state);
          }
          if (state is FollowupFutureFilterListCallResponseState) {
            _onFutureFollowupResponse(state);
          }
          if (state is AttendanceListCallResponseState) {
            _OnAttendanceListResponse(state);
          }
          if (state is ConstantResponseState) {
            _onGetConstant(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ToDoTodayListCallResponseState ||
              currentState is ToDoPendingOverDueListResponseState ||
              currentState is ToDoOverDueListCallResponseState ||
              currentState is ToDoCompletedListCallResponseState ||
              currentState is FollowupFilterListCallResponseState ||
              currentState is FollowupMissedFilterListCallResponseState ||
              currentState is FollowupFutureFilterListCallResponseState ||
              currentState is AttendanceListCallResponseState ||
              currentState is ConstantResponseState ||
              currentState is ToDoFutureListCallResponseState


          ) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ToDoStates state) {
          if (state is ToDoSaveHeaderState) {
            _OnTODOSaveResponse(state);
          }
          if (state is ToDoDeleteResponseState) {
            _OnTaptoDeleteTodo(state);
          }

          if (state is PunchAttendenceSaveResponseState) {
            _onPunchAttandanceSaveResponse(state);
          }

          if (state is AttendanceSaveCallResponseState) {
            _onAttandanceSaveResponse(state);
          }

          if (state is PunchWithoutAttendenceSaveResponseState) {
            _OnPunchOutWithoutImageSucess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ToDoSaveHeaderState ||
              currentState is ToDoDeleteResponseState ||
              currentState is AttendanceSaveCallResponseState ||
              currentState is PunchAttendenceSaveResponseState ||
              currentState is PunchWithoutAttendenceSaveResponseState
          ) {
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
        //98E0FF
        backgroundColor: Color(0xff1e6091),
        appBar: AppBar(
          elevation: 0.1,
          toolbarHeight: 100,
          backgroundColor: Color(0xff1e6091),
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: 100,
          title: Text(
            "Activity Summary",
            style: TextStyle(color: colorWhite, fontWeight: FontWeight.bold),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                //alignment: Alignment(),
                icon: Image.asset(
                  NAV_ICON,
                  height: 48,
                  width: 48,
                  color: colorWhite,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations
                    .of(context)
                    .openAppDrawerTooltip,
              );
            },
          ),
          actions: <Widget>[
            //LADY_ICON
            Container(
              margin: EdgeInsets.only(right: 30),
              child: IconButton(
                  icon: Image.asset(
                    LADY_ICON,
                    height: 48,
                    width: 48,
                  ),
                  onPressed: () {
                    //_onTapOfLogOut();
                    navigateTo(context, HomeScreen.routeName,
                        clearAllStack: true);
                  }),
            )
          ],
        ),
        body:
        DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Color(0xff1e6091),
            body: SafeArea(
              child: Stack(
                children: [

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SegmentedTabControl(
                      // Customization of widget
                      radius: Radius.circular(15),
                      backgroundColor: Color(0xff1e6091),
                      indicatorColor: Colors.orange.shade200,
                      tabTextColor: Colors.black45,
                      selectedTabTextColor: Colors.white,
                      squeezeIntensity: 2,
                      height: 45,
                      tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                      // Options for selection
                      // All specified values will override the [SegmentedTabControl] setting
                      tabs: [
                        SegmentTab(
                          label: 'To-Do',

                          backgroundColor: Colors.blue.shade100,

                          // For example, this overrides [indicatorColor] from [SegmentedTabControl]
                          color: Colors.yellow.shade200,
                          selectedTextColor: colorPrimary,
                          textColor: Colors.black26,

                        ),
                        SegmentTab(
                          label: 'Follow-Up',
                          backgroundColor: Colors.blue.shade100,
                          color: Colors.yellow.shade200,
                          selectedTextColor: colorPrimary,
                          textColor: Colors.black26,
                        ),
                        SegmentTab(
                          label: 'Daily',
                          backgroundColor: Colors.blue.shade100,
                          color: Colors.yellow.shade200,
                          selectedTextColor: colorPrimary,
                          textColor: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  // Sample pages
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [

                        Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    navigateTo(
                                        context, OfficeToDoScreen.routeName,
                                        clearAllStack: true);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [

                                        SizedBox(
                                          height: 5,
                                        ),
                                        TaskStatus(),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // TaskPendingList(),
                                        pressAttention == true
                                            ? TO_DO()
                                            : Container(),
                                        IsExpandedTodays == true
                                            ? pressAttention == true
                                            ? _buildFollowupTodayList()
                                            : Container()
                                            : Container(),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        pressAttention == true
                                            ? OVER_DUEU()
                                            : Container(),
                                        IsExpandedOverDue == true
                                            ? pressAttention == true
                                            ? _buildFollowupOverDueList()
                                            : Container()
                                            : Container(),


                                        ///Pending OverDue
                                        pressAttention == true
                                            ? PENDING_OVER_DUEU()
                                            : Container(),
                                        IsExpandedPendingOverDue == true
                                            ? pressAttention == true
                                            ? _buildPendingOverDueList()
                                            : Container()
                                            : Container(),

                                        ///========
                                        //IsExpandedPendingOverDue
                                        //TodoFuture
                                        pressAttention == true
                                            ? TODO_FUTURE()
                                            : Container(),
                                        IsExpandedTodoFuture == true
                                            ? pressAttention == true
                                            ? _buildFollowupTodoFutureList()
                                            : Container()
                                            : Container(),

                                        pressAttention == false
                                            ? TodayCompleted()
                                            : Container(),
                                        pressAttention == false
                                            ? IsExpandedCompleted == true
                                            ? _buildFollowupCompletedList()
                                            : Container()
                                            : Container(),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    //  navigateTo(context, OfficeToDoScreen.routeName,clearAllStack: true);
                                    _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
                                        "Todays",
                                        FollowupFilterListRequest(
                                            CompanyId: CompanyID.toString(),
                                            LoginUserID: edt_FollowupEmployeeUserID.text,
                                            PageNo: 1,
                                            PageSize: 10000)));
                                    _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
                                        "Missed",
                                        FollowupFilterListRequest(
                                            CompanyId: CompanyID.toString(),
                                            LoginUserID: edt_FollowupEmployeeUserID.text,
                                            PageNo: 1,
                                            PageSize: 10000)));
                                    _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
                                        "Future",
                                        FollowupFilterListRequest(
                                            CompanyId: CompanyID.toString(),
                                            LoginUserID: edt_FollowupEmployeeUserID.text,
                                            PageNo: 1,
                                            PageSize: 10000)));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [

                                        SizedBox(
                                          height: 5,
                                        ),
                                      _buildEmplyeeListView(),

                                        Container(margin:EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20),height: 1,color: colorWhite,),
                                        // TaskPendingList(),
                                        FOLLOWUP(),
                                         Visibility(
                                             visible:IsExpandedFTodays ,
                                             child:  _buildFTodayList()),

                                        Missed(),
                                       Visibility(
                                           visible: IsExpandedMissed,
                                           child: _buildFollowupMissedList()),
                                        FUTURE(),
                                        Visibility(
                                            visible: IsExpandedFuture,
                                            child: _buildFollowupFutureList()),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        RefreshIndicator(
                          onRefresh: () async {
                            getAddressFromLatLong();

                            _officeToDoScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
                                pkID: "",
                                EmployeeID:
                                _offlineLoggedInData.details[0].employeeID.toString(),
                                Month: selectedDate.month.toString(),
                                Year: selectedDate.year.toString(),
                                CompanyId: CompanyID.toString(),
                                LoginUserID: LoginUserID)));
                            _officeToDoScreenBloc.add(ConstantRequestEvent(
                                CompanyID.toString(),
                                ConstantRequest(
                                    ConstantHead: "AttendenceWithImage",
                                    CompanyId: CompanyID.toString())));
                          },
                          
                          child: Container(


                            child:
                            SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      TimeOfDay selectedTime = TimeOfDay.now();
                                      getAddressFromLatLong();
                                      print("sfjsdf8988" + Address);

                                      if (isCurrentTime == true) {
                                        if (isPunchIn == true) {
                                          showCommonDialogWithSingleOption(
                                              context,
                                              _offlineLoggedInData.details[0].employeeName +
                                                  " \n Punch In : " +
                                                  PuchInTime.text,
                                              positiveButtonTitle: "OK");
                                        } else {
                                          if (await Permission.storage.isDenied) {
                                            //await Permission.storage.request();

                                            checkPhotoPermissionStatus();
                                          } else {
                                            if (ConstantMAster.toString() == "" ||
                                                ConstantMAster.toString().toLowerCase() ==
                                                    "no") {
                                              _officeToDoScreenBloc.add(
                                                  PunchWithoutImageAttendanceSaveRequestEvent(
                                                      PunchWithoutImageAttendanceSaveRequest(
                                                          Mode: "punchin",
                                                          pkID: "0",
                                                          EmployeeID: _offlineLoggedInData
                                                              .details[0].employeeID
                                                              .toString(),
                                                          PresenceDate: selectedDate.year
                                                              .toString() +
                                                              "-" +
                                                              selectedDate.month.toString() +
                                                              "-" +
                                                              selectedDate.day.toString(),
                                                          TimeIn: selectedTime.hour
                                                              .toString() +
                                                              ":" +
                                                              selectedTime.minute.toString(),
                                                          TimeOut: "",
                                                          LunchIn: "",
                                                          LunchOut: "",
                                                          LoginUserID: LoginUserID,
                                                          Notes: "",
                                                          Latitude: SharedPrefHelper.instance
                                                              .getLatitude(),
                                                          Longitude: SharedPrefHelper.instance
                                                              .getLongitude(),
                                                          LocationAddress: Address,
                                                          CompanyId: CompanyID.toString())));
                                            } else {
                                              final imagepicker = ImagePicker();

                                              XFile file = await imagepicker.pickImage(
                                                source: ImageSource.camera,
                                                imageQuality: 85,
                                              );

                                              if (file != null) {
                                                File file1 = File(file.path);

                                                final dir = await path_provider
                                                    .getTemporaryDirectory();

                                                final extension = p.extension(file1.path);

                                                int timestamp1 =
                                                    DateTime.now().millisecondsSinceEpoch;

                                                String filenamepunchin = _offlineLoggedInData
                                                    .details[0].employeeID
                                                    .toString() +
                                                    "_" +
                                                    DateTime.now().day.toString() +
                                                    "_" +
                                                    DateTime.now().month.toString() +
                                                    "_" +
                                                    DateTime.now().year.toString() +
                                                    "_" +
                                                    timestamp1.toString() +
                                                    extension;

                                                final targetPath =
                                                    dir.absolute.path + "/" + filenamepunchin;
                                                File file1231 = await testCompressAndGetFile(
                                                    file1, targetPath);
                                                final bytes =
                                                    file1.readAsBytesSync().lengthInBytes;
                                                final kb = bytes / 1024;
                                                final mb = kb / 1024;

                                                print("Image File Is Largre" +
                                                    " KB : " +
                                                    kb.toString() +
                                                    " MB : " +
                                                    mb.toString());
                                                final snackBar = SnackBar(
                                                  content: Text(" KB : " +
                                                      kb.toStringAsFixed(2) +
                                                      " MB : " +
                                                      mb.toStringAsFixed(2) +
                                                      " Location : " +
                                                      " Lat : " +
                                                      SharedPrefHelper.instance
                                                          .getLatitude() +
                                                      " Long : " +
                                                      SharedPrefHelper.instance
                                                          .getLongitude() +
                                                      " Address : " +
                                                      Address),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);

                                                _officeToDoScreenBloc
                                                    .add(PunchAttendanceSaveRequestEvent(
                                                    file1231,
                                                    PunchAttendanceSaveRequest(
                                                      pkID: "0",
                                                      CompanyId: CompanyID.toString(),
                                                      Mode: "punchIN",
                                                      EmployeeID: _offlineLoggedInData
                                                          .details[0].employeeID
                                                          .toString(),
                                                      FileName: filenamepunchin,
                                                      PresenceDate: selectedDate.year
                                                          .toString() +
                                                          "-" +
                                                          selectedDate.month.toString() +
                                                          "-" +
                                                          selectedDate.day.toString(),
                                                      Time: selectedTime.hour.toString() +
                                                          ":" +
                                                          selectedTime.minute.toString(),
                                                      Notes: "",
                                                      Latitude: SharedPrefHelper.instance
                                                          .getLatitude(),
                                                      Longitude: SharedPrefHelper.instance
                                                          .getLongitude(),
                                                      LocationAddress: Address,
                                                      LoginUserId: LoginUserID,
                                                    )));
                                              } /*else {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  "Something Went Wrong File Not Found Exception!",
                                                  positiveButtonTitle:
                                                      "OK");
                                            }*/
                                            }
                                          }
                                        }
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:20,top:10,bottom: 10),
                                      child: Row(

                                        children: [
                                          Icon(
                                            isPunchIn == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isPunchIn == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          Card(
                                            elevation: 5,
                                            color: PuchInTime.text == ""
                                                ? colorRED
                                                : colorPresentDay,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15)),
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Punch In",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            // <-- Change this
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          isPunchIn == true
                                              ? Icon(
                                            Icons.access_alarm,
                                            color: colorPresentDay,
                                          )
                                              : Container(),
                                          isPunchIn == true
                                              ? Text(
                                            PuchInTime.text,
                                            style: TextStyle(
                                                fontSize: 15, color: colorPresentDay),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      TimeOfDay selectedTime = TimeOfDay.now();

                                      print("yryry123" + Address.toString());

                                      if (isCurrentTime == true) {
                                        if (isPunchIn == true) {
                                          if (isPunchOut == false) {
                                            if (isLunchIn == true) {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  _offlineLoggedInData
                                                      .details[0].employeeName +
                                                      " \n Lunch In : " +
                                                      LunchInTime.text,
                                                  positiveButtonTitle: "OK");
                                            } else {
                                              if (ConstantMAster.toString() == "" ||
                                                  ConstantMAster.toString().toLowerCase() ==
                                                      "no") {
                                                _officeToDoScreenBloc.add(
                                                    PunchWithoutImageAttendanceSaveRequestEvent(
                                                        PunchWithoutImageAttendanceSaveRequest(
                                                            Mode: "lunchin",
                                                            pkID: "0",
                                                            EmployeeID: _offlineLoggedInData
                                                                .details[0].employeeID
                                                                .toString(),
                                                            PresenceDate: selectedDate.year
                                                                .toString() +
                                                                "-" +
                                                                selectedDate.month
                                                                    .toString() +
                                                                "-" +
                                                                selectedDate.day.toString(),
                                                            TimeIn: "",
                                                            TimeOut: "",
                                                            LunchIn: selectedTime
                                                                .hour
                                                                .toString() +
                                                                ":" +
                                                                selectedTime
                                                                    .minute
                                                                    .toString(),
                                                            LunchOut: "",
                                                            LoginUserID: LoginUserID,
                                                            Notes: "",
                                                            Latitude: SharedPrefHelper
                                                                .instance
                                                                .getLatitude(),
                                                            Longitude: SharedPrefHelper
                                                                .instance
                                                                .getLongitude(),
                                                            LocationAddress: Address,
                                                            CompanyId:
                                                            CompanyID.toString())));
                                              } else {
                                                final imagepicker = ImagePicker();

                                                XFile file = await imagepicker.pickImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 85,
                                                );

                                                if (file != null) {
                                                  File file1 = File(file.path);

                                                  final dir = await path_provider
                                                      .getTemporaryDirectory();

                                                  final extension = p.extension(file1.path);

                                                  int timestamp1 =
                                                      DateTime.now().millisecondsSinceEpoch;

                                                  String filenameLunchIn =
                                                      _offlineLoggedInData
                                                          .details[0].employeeID
                                                          .toString() +
                                                          "_" +
                                                          DateTime.now().day.toString() +
                                                          "_" +
                                                          DateTime.now().month.toString() +
                                                          "_" +
                                                          DateTime.now().year.toString() +
                                                          "_" +
                                                          timestamp1.toString() +
                                                          extension;

                                                  final targetPath = dir.absolute.path +
                                                      "/" +
                                                      filenameLunchIn;
                                                  File file1231 =
                                                  await testCompressAndGetFile(
                                                      file1, targetPath);
                                                  final bytes =
                                                      file1.readAsBytesSync().lengthInBytes;
                                                  final kb = bytes / 1024;
                                                  final mb = kb / 1024;

                                                  print("Image File Is Largre" +
                                                      " KB : " +
                                                      kb.toString() +
                                                      " MB : " +
                                                      mb.toString());
                                                  final snackBar = SnackBar(
                                                    content: Text(" KB : " +
                                                        kb.toStringAsFixed(2) +
                                                        " MB : " +
                                                        mb.toStringAsFixed(2) +
                                                        " Location : " +
                                                        " Lat : " +
                                                        SharedPrefHelper.instance
                                                            .getLatitude() +
                                                        " Long : " +
                                                        SharedPrefHelper.instance
                                                            .getLongitude() +
                                                        " Address : " +
                                                        Address),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);

                                                  _officeToDoScreenBloc
                                                      .add(PunchAttendanceSaveRequestEvent(
                                                      file1231,
                                                      PunchAttendanceSaveRequest(
                                                        pkID: "0",
                                                        CompanyId: CompanyID.toString(),
                                                        Mode: "lunchin",
                                                        EmployeeID: _offlineLoggedInData
                                                            .details[0].employeeID
                                                            .toString(),
                                                        FileName: filenameLunchIn,
                                                        PresenceDate: selectedDate.year
                                                            .toString() +
                                                            "-" +
                                                            selectedDate.month
                                                                .toString() +
                                                            "-" +
                                                            selectedDate.day.toString(),
                                                        Time:
                                                        selectedTime.hour.toString() +
                                                            ":" +
                                                            selectedTime.minute
                                                                .toString(),
                                                        Notes: "",
                                                        Latitude: SharedPrefHelper
                                                            .instance
                                                            .getLatitude(),
                                                        Longitude: SharedPrefHelper
                                                            .instance
                                                            .getLongitude(),
                                                        LocationAddress: Address,
                                                        LoginUserId: LoginUserID,
                                                      )));
                                                }
                                              }
                                            }
                                          } else {
                                            if (isLunchIn == false) {
                                              showCommonDialogWithSingleOption(context,
                                                  "After Punch Out, You can't be able to do Lunch In!!",
                                                  positiveButtonTitle: "OK");
                                            }
                                          }
                                        } else {
                                          showCommonDialogWithSingleOption(
                                              context, "Punch in Is Required !",
                                              positiveButtonTitle: "OK");
                                        }
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:20,top: 10, bottom: 10),
                                      child: Row(

                                        children: [
                                          Icon(
                                            isLunchIn == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isLunchIn == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          Card(
                                            elevation: 5,
                                            color: LunchInTime.text == ""
                                                ? colorRED
                                                : colorPresentDay,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15)),
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Lunch In",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            // <-- Change this
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          isLunchIn == true
                                              ? Icon(
                                            Icons.access_alarm,
                                            color: colorPresentDay,
                                          )
                                              : Container(),
                                          isLunchIn == true
                                              ? Text(
                                            LunchInTime.text,
                                            style: TextStyle(
                                                fontSize: 15, color: colorPresentDay),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (isCurrentTime == true) {
                                        lunchoutLogic();
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:20,top: 10, bottom: 10),
                                      child: Row(

                                                                                children: [
                                          Icon(
                                            isLunchOut == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isLunchOut == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          Card(
                                            elevation: 5,
                                            color: LunchOutTime.text == ""
                                                ? colorRED
                                                : colorPresentDay,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15)),
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Lunch Out",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            // <-- Change this
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          isLunchOut == true
                                              ? Icon(
                                            Icons.access_alarm,
                                            color: colorPresentDay,
                                          )
                                              : Container(),
                                          isLunchOut == true
                                              ? Text(
                                            LunchOutTime.text,
                                            style: TextStyle(
                                                fontSize: 15, color: colorPresentDay),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (isCurrentTime == true) {
                                        punchoutLogic();
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:20,top: 10, bottom: 10),
                                      child: Row(

                                                                                children: [
                                          Icon(
                                            isPunchOut == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isPunchOut == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          Card(
                                            elevation: 5,
                                            color: PuchOutTime.text == ""
                                                ? colorRED
                                                : colorPresentDay,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15)),
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Punch Out",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            // <-- Change this
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          isPunchOut == true
                                              ? Icon(
                                            Icons.access_alarm,
                                            color: colorPresentDay,
                                          )
                                              : Container(),
                                          isPunchOut == true
                                              ? Text(
                                            PuchOutTime.text,
                                            style: TextStyle(
                                                fontSize: 15, color: colorPresentDay),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      SendEmailOnlyImg(context1: context, Email: "");
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:20,top: 10, bottom: 10),
                                      child: Row(

                                                                                children: [
                                          Icon(
                                            isSendEmail == true
                                                ? Icons.email
                                                : Icons.email_outlined,
                                            color: isSendEmail == true
                                                ? colorPresentDay
                                                : colorYellow,
                                            size: 42,
                                          ),
                                          Card(
                                            elevation: 5,
                                            color: isSendEmail == false
                                                ? colorYellow
                                                : colorPresentDay,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15)),
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Daily Report",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            // <-- Change this
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  HeaderTabList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
              color: Color(0xffb4d0ea),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                  width: 100,
                  height: 33,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(
                      "Project",
                      style: TextStyle(color: Color(0xff5a5a5a), fontSize: 14),
                    ),
                  ))),
          Card(
              color: Color(0xff0066ff),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                  width: 100,
                  height: 33,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(
                      "My Task",
                      style: TextStyle(color: colorWhite, fontSize: 14),
                    ),
                  ))),
          Card(
              color: Color(0xffb4d0ea),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                  width: 100,
                  height: 33,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(
                      "Schedule",
                      style: TextStyle(color: Color(0xff5a5a5a), fontSize: 14),
                    ),
                  ))),
          Card(
              color: Color(0xffb4d0ea),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                  width: 100,
                  height: 33,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(
                      "Note",
                      style: TextStyle(color: Color(0xff5a5a5a), fontSize: 14),
                    ),
                  )))
        ],
      ),
    );
  }

  TWOCARDDesign() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
            color: Color(0xff0066ff),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
                width: 178,
                height: 180,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 54,
                        right: 54,
                        top: 32,
                      ),
                      child: Container(
                        child: CircularPercentIndicator(
                          radius: 25,
                          lineWidth: 2,
                          animation: true,
                          percent: 0.7,
                          backgroundColor: Color(0xff0066ff),
                          center: Text(
                            "70.0%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.white),
                          ),
                          /*  footer: Text(
                                                "Daily Task",
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),*/
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Daily Task",
                      style: TextStyle(
                          fontSize: 10,
                          color: colorWhite,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Remaining Task:   2",
                      style: TextStyle(fontSize: 10, color: colorWhite),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Total Task:   10",
                      style: TextStyle(fontSize: 10, color: colorWhite),
                    )
                  ],
                ))),
        Card(
            color: Color(0xff0066ff),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
                width: 178,
                height: 180,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 54,
                        right: 54,
                        top: 32,
                      ),
                      child: Container(
                        child: CircularPercentIndicator(
                          radius: 25,
                          lineWidth: 2,
                          animation: true,
                          percent: 0.5,
                          backgroundColor: Color(0xff0066ff),
                          // arcBackgroundColor: Colors.red,
                          center: Text(
                            "50.0%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.white),
                          ),
                          /*  footer: Text(
                                                "Daily Task",
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),*/
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Weekly Task",
                      style: TextStyle(
                          fontSize: 10,
                          color: colorWhite,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Remaining Task:   20",
                      style: TextStyle(fontSize: 10, color: colorWhite),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Total Task:   40",
                      style: TextStyle(fontSize: 10, color: colorWhite),
                    )
                  ],
                ))),
      ],
    );
  }

















  TaskStatus() {
    int TotalTodoCount = TotalTodayCount + TotalOverDueCount + TotalTodoFutureCount + TotalPendingOverDueCount;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              //pressAttention = true;
              // doSomething("Pending");
              pressAttention = !pressAttention;
              pressAttention1 = false;
            });
          },
          child: Card(
              color: Color(0xffef6f6c),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child:


                    Text(
                      "To-Do " + " (" + TotalTodoCount.toString() + ")",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {
            //doSomething("Completed");

            setState(() {
              //pressAttention = true;
              // doSomething("Pending");
              pressAttention1 = !pressAttention1;
              pressAttention = false;
            });
          },
          child: Card(
              color: Color(0xff39c3aa),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(
                      "Completed ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ))),
        ),
      ],
    );
  }

  Widget _buildFollowupTodayList() {
    if (_FollowupTodayListResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            _onFollowupTodayListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _FollowupTodayListResponse.details[index].taskStatus ==
                  "Todays" /*&&
                      _FollowupListResponse.details[index].taskStatus ==
                          "Completed-OverDue"*/
                  ? Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.

                    SlidableAction(
                      // padding: EdgeInsets.only(left: 10),
                      onPressed: (c) {
                        /*  showcustomdialog123(
                                    context1: context,
                                    finalCheckingItems:
                                        _FollowupListResponse.details[index],
                                    index1: index);*/
                      },
                      backgroundColor: colorGreen,
                      foregroundColor: Colors.white,
                      icon: Icons.done,
                      label: 'Complete',
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: _buildFollowupTodayListItem(index),
              )
                  : _buildFollowupTodayListItem(index);

              // return _buildFollowupListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FollowupTodayListResponse.details.length,
          ),
        ),
      );
    }
  }

  Widget _buildFollowupOverDueList() {
    if (_FollowupListOverDueResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            _onFollowupOverDueListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _FollowupListOverDueResponse.details[index].taskStatus ==
                  "Pending1" /*&&
                      _FollowupListResponse.details[index].taskStatus ==
                          "Completed-OverDue"*/
                  ? Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.

                    SlidableAction(
                      // padding: EdgeInsets.only(left: 10),
                      onPressed: (c) {
                        /*  showcustomdialog123(
                                    context1: context,
                                    finalCheckingItems:
                                        _FollowupListResponse.details[index],
                                    index1: index);*/
                      },
                      backgroundColor: colorGreen,
                      foregroundColor: Colors.white,
                      icon: Icons.done,
                      label: 'Complete',
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: _buildFollowupOverDueListItem(index),
              )
                  : _buildFollowupOverDueListItem(index);

              // return _buildFollowupListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FollowupListOverDueResponse.details.length,
          ),
        ),
      );
    }
  }


  Widget _buildPendingOverDueList() {
    if (_FollowupListPending_OverDueResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            _onFollowupOverDueListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _FollowupListPending_OverDueResponse.details[index].taskStatus ==
                  "Pending1" /*&&
                      _FollowupListResponse.details[index].taskStatus ==
                          "Completed-OverDue"*/
                  ? Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.

                    SlidableAction(
                      // padding: EdgeInsets.only(left: 10),
                      onPressed: (c) {
                        /*  showcustomdialog123(
                                    context1: context,
                                    finalCheckingItems:
                                        _FollowupListResponse.details[index],
                                    index1: index);*/
                      },
                      backgroundColor: colorGreen,
                      foregroundColor: Colors.white,
                      icon: Icons.done,
                      label: 'Complete',
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: _buildPendingOverDueListItem(index),
              )
                  : _buildPendingOverDueListItem(index);

              // return _buildFollowupListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FollowupListPending_OverDueResponse.details.length,
          ),
        ),
      );
    }
  }


  Widget _buildFollowupTodoFutureList() {


    if (_FollowupFutureListResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            _onFollowupTODOFutureListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _FollowupFutureListResponse.details[index].taskStatus ==
                  "Pending1" /*&&
                      _FollowupListResponse.details[index].taskStatus ==
                          "Completed-OverDue"*/
                  ? Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.

                    SlidableAction(
                      // padding: EdgeInsets.only(left: 10),
                      onPressed: (c) {
                        /*  showcustomdialog123(
                                    context1: context,
                                    finalCheckingItems:
                                        _FollowupListResponse.details[index],
                                    index1: index);*/
                      },
                      backgroundColor: colorGreen,
                      foregroundColor: Colors.white,
                      icon: Icons.done,
                      label: 'Complete',
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: _buildFollowupTODOFUTUREListItem(index),
              )
                  : _buildFollowupTODOFUTUREListItem(index);

              // return _buildFollowupListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FollowupFutureListResponse.details.length,
          ),
        ),
      );
    }
  }


  Widget _buildFollowupMissedList() {
    if (_FMissedListResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            //_onFollowupOverDueListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildFollowupMissedListItem(index);

              // return _buildFollowupListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FMissedListResponse.details.length,
          ),
        ),
      );
    }
  }

  Widget _buildFollowupFutureList() {
    if (_FFutureListResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            //_onFollowupOverDueListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildFollowupFutureListItem(index);

              // return _buildFollowupListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FFutureListResponse.details.length,
          ),
        ),
      );
    }
  }

  Widget _buildFollowupCompletedList() {
    if (_FollowupListCompletedResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            _onFollowupCompletedListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _FollowupListCompletedResponse.details[index].taskStatus ==
                  "Pending1" /*&&
                      _FollowupListResponse.details[index].taskStatus ==
                          "Completed-OverDue"*/
                  ? Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.

                    SlidableAction(
                      // padding: EdgeInsets.only(left: 10),
                      onPressed: (c) {
                        /*  showcustomdialog123(
                                    context1: context,
                                    finalCheckingItems:
                                        _FollowupListResponse.details[index],
                                    index1: index);
                        */
                      },
                      backgroundColor: colorGreen,
                      foregroundColor: Colors.white,
                      icon: Icons.done,
                      label: 'Complete',
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: _buildFollowupCompletedListItem(index),
              )
                  : _buildFollowupCompletedListItem(index);

              // return _buildFollowupListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FollowupListCompletedResponse.details.length,
          ),
        ),
      );
    }
  }

  void _onFollowupTodayListPagination() {
    if (_FollowupTodayListResponse.details.length <
        _FollowupTodayListResponse.totalCount) {

    }
  }

  void _onFollowupOverDueListPagination() {
    if (_FollowupListOverDueResponse.details.length <
        _FollowupListOverDueResponse.totalCount) {

    }
  }

  void _onFollowupTODOFutureListPagination() {
    if (_FollowupFutureListResponse.details.length <
        _FollowupFutureListResponse.totalCount) {

    }
  }

  //_FollowupFutureListResponse
  void _onFollowupCompletedListPagination() {
    if (_FollowupListCompletedResponse.details.length <
        _FollowupListCompletedResponse.totalCount) {

    }
  }

  Widget _buildFollowupTodayListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(onTap: () {
          navigateTo(context, OfficeToDoAddEditScreen.routeName,
              arguments: AddUpdateOfficeTODOScreenArguments(
                  _FollowupTodayListResponse.details[index]))
              .then((value) {

          });
        }, child: ExpantionTodayCustomer(context, index))

      ],
    );
  }

  Widget _buildFTodayListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(onTap: () {

        }, child: ExpantionFTodayCustomer(context, index))

      ],
    );
  }

  //

  Widget _buildFollowupOverDueListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(onTap: () {
          /* showcustomdialog123(
              context1: context,
              finalCheckingItems:
              _FollowupListOverDueResponse.details[index],
              index1: index);*/
          navigateTo(context, OfficeToDoAddEditScreen.routeName,
              arguments: AddUpdateOfficeTODOScreenArguments(
                  _FollowupListOverDueResponse.details[index]))
              .then((value) {

          });
        }, child: ExpantionOverDueCustomer(context, index),)

      ],
    );
  }
  Widget _buildPendingOverDueListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(onTap: () {
          /* showcustomdialog123(
              context1: context,
              finalCheckingItems:
              _FollowupListOverDueResponse.details[index],
              index1: index);*/
          navigateTo(context, OfficeToDoAddEditScreen.routeName,
              arguments: AddUpdateOfficeTODOScreenArguments(
                  _FollowupListPending_OverDueResponse.details[index]))
              .then((value) {

          });
        }, child: ExpantionPendingOverDueCustomer(context, index),)

      ],
    );
  }

  Widget _buildFollowupTODOFUTUREListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(onTap: () {
          /* showcustomdialog123(
              context1: context,
              finalCheckingItems:
              _FollowupListOverDueResponse.details[index],
              index1: index);*/
          navigateTo(context, OfficeToDoAddEditScreen.routeName,
              arguments: AddUpdateOfficeTODOScreenArguments(
                  _FollowupFutureListResponse.details[index]))
              .then((value) {

          });
        }, child: ExpantionTODOFUTURECustomer(context, index),)

      ],
    );
  }


  Widget _buildFollowupMissedListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(onTap: () {


        }, child: ExpantionMissedCustomer(context, index),)

      ],
    );
  }

  Widget _buildFollowupFutureListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(onTap: () {


        }, child: ExpantionFutureCustomer(context, index),)

      ],
    );
  }


  Widget _buildFollowupCompletedListItem(int index) {
    // ToDoDetails model = _FollowupListResponse.details[index];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        ExpantionCompletedCustomer(context, index)
      ],
    );
  }

  ExpantionTodayCustomer(BuildContext context, int index) {
    OfficeToDoListResponseDetails model = _FollowupTodayListResponse.details[index];
    var colorwe = model.taskStatus == "Pending" ? Color(0xFFFCFCFC) : Color(
        0xFFC1E0FA);
    return Container(
      //  color: Color(0xff98e0ff),
      // padding: EdgeInsets.only(left: 10, right: 10),
        child: // _FollowupTodayListResponse.details[index].taskStatus == "Pending" || _FollowupTodayListResponse.details[index].taskStatus == "Todays"
        Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),


            children: [

              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;
                  _officeToDoScreenBloc.add(ToDoSaveHeaderEvent(context,
                      _FollowupTodayListResponse.details[index].pkID,
                      ToDoHeaderSaveRequest(
                          Priority: "Medium",
                          TaskDescription: _FollowupTodayListResponse.details
                              [index].taskDescription,
                          Location: _FollowupTodayListResponse.details
                              [index].location,
                          TaskCategoryID: _FollowupTodayListResponse.details
                              [index].taskCategoryId
                              .toString(),
                          StartDate: _FollowupTodayListResponse.details[index]
                              .startDate.getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          DueDate: _FollowupTodayListResponse.details[index]
                              .dueDate
                              .getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          CompletionDate: _FollowupTodayListResponse.details
                              [index].startDate
                              .getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd"),
                          LoginUserID: LoginUserID,
                          EmployeeID: _FollowupTodayListResponse.details[index]
                              .employeeID.toString(),
                          Reminder: "",
                          ReminderMonth: "",
                          Latitude: "",
                          Longitude: "",
                          ClosingRemarks: _FollowupTodayListResponse.details
                              [index].closingRemarks,
                          CompanyId: CompanyID.toString())));
                },

                //Color(0xff39c3aa) Green = Color(0xff39c3aa)
                backgroundColor: Color(0xff39c3aa),
                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),


          child: IgnorePointer(
            child: InkWell(
                onTap: () {
                  navigateTo(context, OfficeToDoAddEditScreen.routeName,
                      arguments: AddUpdateOfficeTODOScreenArguments(model))
                      .then((value) {

                  });
                },
                child: /*ExpansionTileCard(
                      elevationCurve: Curves.easeInOut,
                      trailing: SizedBox(
                        height: 1,
                        width: 1,
                      ),
                      shadowColor: Color(0xFF504F4F),
                      baseColor: Colors.white ,
                      expandedColor:
                          Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
                      leading: Container(
                          height: 35, width: 35, child: Icon(Icons.access_alarm)),

                      title: Text(
                        model.taskDescription,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black),
                      ),

                    ),*/
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(


                    border: Border.all(
                        color: colorWhite, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    // Make rounded corner of border
                  ),
                  child: Row(

                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          child: Icon(Icons.access_alarm, color: colorWhite,)),
                      SizedBox(width: 2,),
                      Expanded(
                        child: Text(model.taskDescription,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorWhite),),
                      )
                    ],),
                )
            ),
          ),
        ));
    /*: IgnorePointer(
                child: ExpansionTileCard(
                  elevationCurve: Curves.easeInOut,
                  trailing: SizedBox(
                    height: 1,
                    width: 1,
                  ),
                  shadowColor: Color(0xFF504F4F),

                  baseColor: Color(0xFFBB0909),//Color(0xFF9CF1A3),
                  expandedColor:
                      Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
                  leading: Container(
                      height: 35, width: 35, child: Icon(Icons.access_alarm)),

                  title: Text(
                    model.taskDescription,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  ),

                ),
              ));*/
  }

  ExpantionFTodayCustomer(BuildContext context, int index) {
    FilterDetails model = _FTodaysListResponse.details[index];

    return Container(
      //  color: Color(0xff98e0ff),
      // padding: EdgeInsets.only(left: 10, right: 10),
        child: // _FollowupTodayListResponse.details[index].taskStatus == "Pending" || _FollowupTodayListResponse.details[index].taskStatus == "Todays"
        Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),


            children: [

              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;



                 /* return showDialog(
                      context: context,
                      builder: (context) {
                        bool isChecked = false;
                        // timeChangesEvent();

                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                          title: Column(
                            children: [
                              Text(
                                "Update Follow-Up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: colorPrimary),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                          content: Container(
                              height: 400,
                              width: double.infinity,
                              child: OfficeFollowUpAddEditScreen(OfficeFollowupScreenArguments(editModel:model,FollowupStatus:"Todays")
                              )),
                          actions: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: *//*getCommonButton(baseTheme, () {
                                  Navigator.pop(context);
                                }, "Close"),*//*
                                Column(
                                  children: [
                                    Divider(
                                      thickness: 2,
                                    ),
                                    getCommonButton(baseTheme, () {
                                      Navigator.pop(context);
                                    }, "Close", radius: 25.0),
                                    *//*Text(
                                      "Close",
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),*//*
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      });*/


                  navigateTo(context,
                      OfficeFollowUpAddEditScreen.routeName,
                      arguments:
                      OfficeFollowupScreenArguments(editModel:model,FollowupStatus:"Todays"))
                      .then((value) {
                    setState(() {
                      // followerEmployeeList();

                      _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
                          "Todays",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));
                      _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
                          "Missed",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));
                      _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
                          "Future",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));

                      print("dfjhdjh" + value);

                    });
                  });
                },

                //Color(0xff39c3aa) Green = Color(0xff39c3aa)
                backgroundColor: Color(0xff39c3aa),
                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),


          child: IgnorePointer(
            child: InkWell(
                onTap: () {

                },
                child:
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(


                    border: Border.all(
                        color: colorWhite, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    // Make rounded corner of border
                  ),
                  child: Row(

                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          child: Icon(Icons.perm_contact_calendar_sharp, color: colorWhite,)),
                      SizedBox(width: 2,),
                      Expanded(
                        child: Text(model.customerName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorWhite),),
                      )
                    ],),
                )
            ),
          ),
        ));
  }


  ExpantionOverDueCustomer(BuildContext context, int index) {
    OfficeToDoListResponseDetails model = _FollowupListOverDueResponse.details[index];
    return Container(
      /*width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(


          border: Border.all(
              color: colorWhite, // Set border color
              width: 1.0),   // Set border width
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)), // Set rounded corner radius
          // Make rounded corner of border
        ),*/
      // padding: EdgeInsets.only(left: 10, right: 10),
        child: _FollowupListOverDueResponse.details[index].taskStatus ==
            "Pending"
            ? Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              /* SlidableAction(
                onPressed: (c){
                 // print("Dleif" + "Delete Itme");
                  _officeToDoScreenBloc.add(ToDoDeleteEvent(model.pkID,
                      ToDoDeleteRequest(CompanyId: CompanyID.toString())));
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,

              ),*/
              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  /*showcustomdialog123(
                                  context1: context,
                                  finalCheckingItems:
                                      _FollowupListResponse.details[index],
                                  index1: index);*/
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;

                  DateTime selectedDate = DateTime.now();


                  _officeToDoScreenBloc.add(ToDoSaveHeaderEvent(context,
                      _FollowupListOverDueResponse.details[index].pkID,
                      ToDoHeaderSaveRequest(
                          Priority: "Medium",
                          TaskDescription: _FollowupListOverDueResponse
                              .details[index].taskDescription,
                          Location: _FollowupListOverDueResponse
                              .details[index].location,
                          TaskCategoryID: _FollowupListOverDueResponse
                              .details[index].taskCategoryId
                              .toString(),
                          StartDate: _FollowupListOverDueResponse.details[index]
                              .startDate.getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          DueDate: _FollowupListOverDueResponse.details[index]
                              .dueDate
                              .getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          CompletionDate: selectedDate.year.toString() + "-" +
                              selectedDate.month.toString() + "-" +
                              selectedDate.day.toString(),
                          LoginUserID: LoginUserID,
                          EmployeeID: _FollowupListOverDueResponse
                              .details[index].employeeID.toString(),
                          Reminder: "",
                          ReminderMonth: "",
                          Latitude: "",
                          Longitude: "",
                          ClosingRemarks: _FollowupListOverDueResponse
                              .details[index].closingRemarks,
                          CompanyId: CompanyID.toString())));
                },
                backgroundColor: Color(0xff39c3aa),

                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: IgnorePointer(
            child: InkWell(
                onTap: () {
                  /*  showcustomdialog123(
                                  context1: context,
                                  finalCheckingItems:
                                  _FollowupListOverDueResponse.details[index],
                                  index1: index);*/

                  navigateTo(context, OfficeToDoAddEditScreen.routeName,
                      arguments: AddUpdateOfficeTODOScreenArguments(model))
                      .then((value) {

                  });
                },
                child: /*ExpansionTileCard(
                elevationCurve: Curves.easeInOut,
                trailing: SizedBox(height: 1,width: 1,),
                shadowColor: Color(0xFF504F4F),
                baseColor: Color(0xFFFCFCFC),
                expandedColor:
                Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
                leading: Container(
                    height: 35, width: 35, child: Icon(Icons.access_alarm)),

                title: Text(
                  model.taskDescription,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),*/
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(


                    border: Border.all(
                        color: colorWhite, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    // Make rounded corner of border
                  ),
                  child: Row(

                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          child: Icon(Icons.access_alarm, color: colorWhite,)),
                      SizedBox(width: 2,),
                      Expanded(
                        child: Text(model.taskDescription,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorWhite),),
                      )
                    ],),
                )

            ),
          ),
        )
            : IgnorePointer(
          child: InkWell(
              onTap: () {
                /* showcustomdialog123(
                  context1: context,
                  finalCheckingItems:
                  _FollowupListOverDueResponse.details[index],
                  index1: index);*/
              },
              child: /* ExpansionTileCard(
              elevationCurve: Curves.easeInOut,
              trailing: SizedBox(
                height: 1,
                width: 1,
              ),
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor:
              Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
              leading: Container(
                  height: 35, width: 35, child: Icon(Icons.access_alarm)),

              title: Text(
                model.taskDescription,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),

            ),*/ Row(

                children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Icon(Icons.access_alarm, color: colorWhite,)),
                  SizedBox(width: 2,),
                  Expanded(
                    child: Text(model.taskDescription,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colorWhite),),
                  )
                ],)
          ),
        ));
  }

  ExpantionPendingOverDueCustomer(BuildContext context, int index) {
    OfficeToDoListResponseDetails model = _FollowupListPending_OverDueResponse.details[index];
    return Container(
      /*width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(


          border: Border.all(
              color: colorWhite, // Set border color
              width: 1.0),   // Set border width
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)), // Set rounded corner radius
          // Make rounded corner of border
        ),*/
      // padding: EdgeInsets.only(left: 10, right: 10),
        child: _FollowupListPending_OverDueResponse.details[index].taskStatus ==
            "Pending-OverDue"
            ? Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              /* SlidableAction(
                onPressed: (c){
                 // print("Dleif" + "Delete Itme");
                  _officeToDoScreenBloc.add(ToDoDeleteEvent(model.pkID,
                      ToDoDeleteRequest(CompanyId: CompanyID.toString())));
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,

              ),*/
              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  /*showcustomdialog123(
                                  context1: context,
                                  finalCheckingItems:
                                      _FollowupListResponse.details[index],
                                  index1: index);*/
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;

                  DateTime selectedDate = DateTime.now();


                  _officeToDoScreenBloc.add(ToDoSaveHeaderEvent(context,
                      _FollowupListPending_OverDueResponse.details[index].pkID,
                      ToDoHeaderSaveRequest(
                          Priority: "Medium",
                          TaskDescription: _FollowupListPending_OverDueResponse
                              .details[index].taskDescription,
                          Location: _FollowupListPending_OverDueResponse
                              .details[index].location,
                          TaskCategoryID: _FollowupListPending_OverDueResponse
                              .details[index].taskCategoryId
                              .toString(),
                          StartDate: _FollowupListPending_OverDueResponse.details[index]
                              .startDate.getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          DueDate: _FollowupListPending_OverDueResponse.details[index]
                              .dueDate
                              .getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          CompletionDate: selectedDate.year.toString() + "-" +
                              selectedDate.month.toString() + "-" +
                              selectedDate.day.toString(),
                          LoginUserID: LoginUserID,
                          EmployeeID: _FollowupListPending_OverDueResponse
                              .details[index].employeeID.toString(),
                          Reminder: "",
                          ReminderMonth: "",
                          Latitude: "",
                          Longitude: "",
                          ClosingRemarks: _FollowupListPending_OverDueResponse
                              .details[index].closingRemarks,
                          CompanyId: CompanyID.toString())));
                },
                backgroundColor: Color(0xff39c3aa),

                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: IgnorePointer(
            child: InkWell(
                onTap: () {
                  /*  showcustomdialog123(
                                  context1: context,
                                  finalCheckingItems:
                                  _FollowupListOverDueResponse.details[index],
                                  index1: index);*/

                  navigateTo(context, OfficeToDoAddEditScreen.routeName,
                      arguments: AddUpdateOfficeTODOScreenArguments(model))
                      .then((value) {

                  });
                },
                child: /*ExpansionTileCard(
                elevationCurve: Curves.easeInOut,
                trailing: SizedBox(height: 1,width: 1,),
                shadowColor: Color(0xFF504F4F),
                baseColor: Color(0xFFFCFCFC),
                expandedColor:
                Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
                leading: Container(
                    height: 35, width: 35, child: Icon(Icons.access_alarm)),

                title: Text(
                  model.taskDescription,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),*/
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(


                    border: Border.all(
                        color: colorWhite, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    // Make rounded corner of border
                  ),
                  child: Row(

                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          child: Icon(Icons.access_alarm, color: colorWhite,)),
                      SizedBox(width: 2,),
                      Expanded(
                        child: Text(model.taskDescription,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorWhite),),
                      )
                    ],),
                )

            ),
          ),
        )
            : IgnorePointer(
          child: InkWell(
              onTap: () {
                /* showcustomdialog123(
                  context1: context,
                  finalCheckingItems:
                  _FollowupListOverDueResponse.details[index],
                  index1: index);*/
              },
              child: /* ExpansionTileCard(
              elevationCurve: Curves.easeInOut,
              trailing: SizedBox(
                height: 1,
                width: 1,
              ),
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor:
              Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
              leading: Container(
                  height: 35, width: 35, child: Icon(Icons.access_alarm)),

              title: Text(
                model.taskDescription,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),

            ),*/ Row(

                children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Icon(Icons.access_alarm, color: colorWhite,)),
                  SizedBox(width: 2,),
                  Expanded(
                    child: Text(model.taskDescription,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colorWhite),),
                  )
                ],)
          ),
        ));
  }


  ExpantionTODOFUTURECustomer(BuildContext context, int index) {
    OfficeToDoListResponseDetails model = _FollowupFutureListResponse.details[index];
    return Container(
      /*width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(


          border: Border.all(
              color: colorWhite, // Set border color
              width: 1.0),   // Set border width
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)), // Set rounded corner radius
          // Make rounded corner of border
        ),*/
      // padding: EdgeInsets.only(left: 10, right: 10),
        child: _FollowupFutureListResponse.details[index].taskStatus ==
            "Future"
            ? Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              /* SlidableAction(
                onPressed: (c){
                 // print("Dleif" + "Delete Itme");
                  _officeToDoScreenBloc.add(ToDoDeleteEvent(model.pkID,
                      ToDoDeleteRequest(CompanyId: CompanyID.toString())));
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,

              ),*/
              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  /*showcustomdialog123(
                                  context1: context,
                                  finalCheckingItems:
                                      _FollowupListResponse.details[index],
                                  index1: index);*/
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;

                  DateTime selectedDate = DateTime.now();


                  _officeToDoScreenBloc.add(ToDoSaveHeaderEvent(context,
                      _FollowupFutureListResponse.details[index].pkID,
                      ToDoHeaderSaveRequest(
                          Priority: "Medium",
                          TaskDescription: _FollowupFutureListResponse
                              .details[index].taskDescription,
                          Location: _FollowupFutureListResponse
                              .details[index].location,
                          TaskCategoryID: _FollowupFutureListResponse
                              .details[index].taskCategoryId
                              .toString(),
                          StartDate: _FollowupFutureListResponse.details[index]
                              .startDate.getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          DueDate: _FollowupFutureListResponse.details[index]
                              .dueDate
                              .getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          CompletionDate: selectedDate.year.toString() + "-" +
                              selectedDate.month.toString() + "-" +
                              selectedDate.day.toString(),
                          LoginUserID: LoginUserID,
                          EmployeeID: _FollowupFutureListResponse
                              .details[index].employeeID.toString(),
                          Reminder: "",
                          ReminderMonth: "",
                          Latitude: "",
                          Longitude: "",
                          ClosingRemarks: _FollowupFutureListResponse
                              .details[index].closingRemarks,
                          CompanyId: CompanyID.toString())));
                },
                backgroundColor: Color(0xff39c3aa),

                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: IgnorePointer(
            child: InkWell(
                onTap: () {
                  /*  showcustomdialog123(
                                  context1: context,
                                  finalCheckingItems:
                                  _FollowupListOverDueResponse.details[index],
                                  index1: index);*/

                  navigateTo(context, OfficeToDoAddEditScreen.routeName,
                      arguments: AddUpdateOfficeTODOScreenArguments(model))
                      .then((value) {

                  });
                },
                child: /*ExpansionTileCard(
                elevationCurve: Curves.easeInOut,
                trailing: SizedBox(height: 1,width: 1,),
                shadowColor: Color(0xFF504F4F),
                baseColor: Color(0xFFFCFCFC),
                expandedColor:
                Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
                leading: Container(
                    height: 35, width: 35, child: Icon(Icons.access_alarm)),

                title: Text(
                  model.taskDescription,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),*/
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(


                    border: Border.all(
                        color: colorWhite, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    // Make rounded corner of border
                  ),
                  child: Row(

                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          child: Icon(Icons.access_alarm, color: colorWhite,)),
                      SizedBox(width: 2,),
                      Expanded(
                        child: Text(model.taskDescription,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorWhite),),
                      )
                    ],),
                )

            ),
          ),
        )
            : IgnorePointer(
          child: InkWell(
              onTap: () {
                /* showcustomdialog123(
                  context1: context,
                  finalCheckingItems:
                  _FollowupListOverDueResponse.details[index],
                  index1: index);*/
              },
              child: /* ExpansionTileCard(
              elevationCurve: Curves.easeInOut,
              trailing: SizedBox(
                height: 1,
                width: 1,
              ),
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor:
              Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
              leading: Container(
                  height: 35, width: 35, child: Icon(Icons.access_alarm)),

              title: Text(
                model.taskDescription,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),

            ),*/ Row(

                children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Icon(Icons.access_alarm, color: colorWhite,)),
                  SizedBox(width: 2,),
                  Expanded(
                    child: Text(model.taskDescription,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colorWhite),),
                  )
                ],)
          ),
        ));
  }


  ExpantionMissedCustomer(BuildContext context, int index) {
    FilterDetails model = _FMissedListResponse.details[index];
    return Container(
      //  color: Color(0xff98e0ff),
      // padding: EdgeInsets.only(left: 10, right: 10),
        child: // _FollowupTodayListResponse.details[index].taskStatus == "Pending" || _FollowupTodayListResponse.details[index].taskStatus == "Todays"
        Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),


            children: [

              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;

                  navigateTo(context,
                      OfficeFollowUpAddEditScreen.routeName,
                      arguments:
                      OfficeFollowupScreenArguments(editModel:model,FollowupStatus:"Missed"))
                      .then((value) {
                    setState(() {
                      // followerEmployeeList();

                      _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
                          "Todays",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));
                      _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
                          "Missed",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));
                      _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
                          "Future",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));

                      print("dfjhdjh" + value);

                    });
                  });
                },

                //Color(0xff39c3aa) Green = Color(0xff39c3aa)
                backgroundColor: Color(0xff39c3aa),
                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),


          child: IgnorePointer(
            child: InkWell(
                onTap: () {

                },
                child:
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(


                    border: Border.all(
                        color: colorWhite, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    // Make rounded corner of border
                  ),
                  child: Row(

                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          child: Icon(Icons.perm_contact_calendar_sharp, color: colorWhite,)),
                      SizedBox(width: 2,),
                      Expanded(
                        child: Text(model.customerName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorWhite),),
                      )
                    ],),
                )
            ),
          ),
        ));
  }

  ExpantionFutureCustomer(BuildContext context, int index) {
    FilterDetails model = _FFutureListResponse.details[index];
    return Container(
      //  color: Color(0xff98e0ff),
      // padding: EdgeInsets.only(left: 10, right: 10),
        child: // _FollowupTodayListResponse.details[index].taskStatus == "Pending" || _FollowupTodayListResponse.details[index].taskStatus == "Todays"
        Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),


            children: [

              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;


                  navigateTo(context,
                      OfficeFollowUpAddEditScreen.routeName,
                      arguments:
                      OfficeFollowupScreenArguments(editModel:model,FollowupStatus:"Future"))
                      .then((value) {
                    setState(() {
                      // followerEmployeeList();

                      _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
                          "Todays",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));
                      _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
                          "Missed",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));
                      _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
                          "Future",
                          FollowupFilterListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: edt_FollowupEmployeeUserID.text,
                              PageNo: 1,
                              PageSize: 10000)));

                      print("dfjhdjh" + value);

                    });
                  });

                },

                //Color(0xff39c3aa) Green = Color(0xff39c3aa)
                backgroundColor: Color(0xff39c3aa),
                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),


          child: IgnorePointer(
            child: InkWell(
                onTap: () {

                },
                child:
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(


                    border: Border.all(
                        color: colorWhite, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    // Make rounded corner of border
                  ),
                  child: Row(

                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          child: Icon(Icons.perm_contact_calendar_sharp, color: colorWhite,)),
                      SizedBox(width: 2,),
                      Expanded(
                        child: Text(model.customerName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorWhite),),
                      )
                    ],),
                )
            ),
          ),
        ));
  }

  ExpantionCompletedCustomer(BuildContext context, int index) {
    OfficeToDoListResponseDetails model = _FollowupListCompletedResponse.details[index];

    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(


          border: Border.all(
              color: Color(0xff39c3aa), // Set border color
              width: 1.0), // Set border width
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)), // Set rounded corner radius
          // Make rounded corner of border
        ),
        // padding: EdgeInsets.only(left: 10, right: 10),
        child: _FollowupListCompletedResponse.details[index].taskStatus ==
            "Pending"
            ? Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.

              SlidableAction(
                // padding: EdgeInsets.only(left: 10),
                onPressed: (c) {
                  /*showcustomdialog123(
                                  context1: context,
                                  finalCheckingItems:
                                      _FollowupListResponse.details[index],
                                  index1: index);*/
                  String AM_PM =
                  selectedTime.periodOffset.toString() == "12"
                      ? "PM"
                      : "AM";
                  String beforZeroHour = selectedTime.hourOfPeriod <= 9
                      ? "0" + selectedTime.hourOfPeriod.toString()
                      : selectedTime.hourOfPeriod.toString();
                  String beforZerominute = selectedTime.minute <= 9
                      ? "0" + selectedTime.minute.toString()
                      : selectedTime.minute.toString();

                  String TimeHour =
                      beforZeroHour + ":" + beforZerominute + " " + AM_PM;
                  _officeToDoScreenBloc.add(ToDoSaveHeaderEvent(context,
                      _FollowupListCompletedResponse.details[index].pkID,
                      ToDoHeaderSaveRequest(
                          Priority: "Medium",
                          TaskDescription: _FollowupListCompletedResponse
                              .details[index].taskDescription,
                          Location: _FollowupListCompletedResponse
                              .details[index].location,
                          TaskCategoryID: _FollowupListCompletedResponse
                              .details[index].taskCategoryId
                              .toString(),
                          StartDate: _FollowupListCompletedResponse
                              .details[index].startDate.getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          DueDate: _FollowupListCompletedResponse.details[index]
                              .dueDate
                              .getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd") +
                              " " +
                              TimeHour,
                          CompletionDate: _FollowupListCompletedResponse
                              .details[index].startDate
                              .getFormattedDate(
                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                              toFormat: "yyyy-MM-dd"),
                          LoginUserID: LoginUserID,
                          EmployeeID: _FollowupListCompletedResponse
                              .details[index].employeeID.toString(),
                          Reminder: "",
                          ReminderMonth: "",
                          Latitude: "",
                          Longitude: "",
                          ClosingRemarks: _FollowupListCompletedResponse
                              .details[index].closingRemarks,
                          CompanyId: CompanyID.toString())));
                },
                backgroundColor: colorGreen,
                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: IgnorePointer(
              child: /*ExpansionTileCard(
              elevationCurve: Curves.easeInOut,
              trailing: SizedBox(
                height: 1,
                width: 1,
              ),


              leading: Container(
                  height: 35, width: 35, child: Icon(Icons.access_alarm)),

              title: Text(
                model.taskDescription,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),

            ),*/Text(model.taskDescription,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xff39c3aa)),)
          ),
        )
            : IgnorePointer(
            child: /*ExpansionTileCard(
            elevationCurve: Curves.easeInOut,
            trailing: SizedBox(
              height: 1,
              width: 1,
            ),

            leading: Container(
                height: 35, width: 35, child: Icon(Icons.access_alarm)),

            title: Text(
              model.taskDescription,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black),
            ),

          ),*/

            Row(

              children: [
                Container(
                    height: 35,
                    width: 35,
                    child: Icon(Icons.access_alarm, color: Color(0xff39c3aa),)),
                SizedBox(width: 2,),
                Expanded(
                  child: Text(model.taskDescription,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0xff39c3aa)),),
                )
              ],)

        ));
  }

  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                fontWeight: FontWeight
                    .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
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


   _onFollowupTodayListCallSuccess(ToDoTodayListCallResponseState state) {









     if (_pageNo != state.newPage || state.newPage == 1) {
       //checking if new data is arrived
       if (state.newPage == 1) {
         //resetting search
         _FollowupTodayListResponse = state.response;
       } else {
         _FollowupTodayListResponse.details.addAll(state.response.details);
       }
       if (_FollowupTodayListResponse.details.length != 0) {
         TotalTodayCount = state.response.totalCount;
       } else {
         TotalTodayCount = 0;
       }

       _pageNo = state.newPage;
     }



  }

  void _onFollowupOverDueListCallSuccess(
      ToDoOverDueListCallResponseState state) {
    print("sdfjf45" + state.response.details.length.toString());

    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FollowupListOverDueResponse = state.response;
      } else {
        _FollowupListOverDueResponse.details.addAll(state.response.details);
      }
      if (_FollowupListOverDueResponse.details.length != 0) {
        TotalOverDueCount = state.response.totalCount;
      } else {
        TotalOverDueCount = 0;
      }

      _pageNo = state.newPage;
    }
  }

  void _onTo_Do_PendingOverDueListCallSuccess(
      ToDoPendingOverDueListResponseState state) {
    print("sdfjf45" + state.response.details.length.toString());

    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FollowupListPending_OverDueResponse = state.response;
      } else {
        _FollowupListPending_OverDueResponse.details.addAll(state.response.details);
      }
      if (_FollowupListPending_OverDueResponse.details.length != 0) {
        TotalPendingOverDueCount = state.response.totalCount;
      } else {
        TotalPendingOverDueCount = 0;
      }

      _pageNo = state.newPage;
    }
  }

  void _onFollowupCompletedListCallSuccess(
      ToDoCompletedListCallResponseState state) {
    print("sdfjf45" + state.response.details.length.toString());

    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FollowupListCompletedResponse = state.response;
      } else {
        _FollowupListCompletedResponse.details.addAll(state.response.details);
      }
      if (_FollowupListCompletedResponse.details.length != 0) {
        TotalCompltedCount = state.response.totalCount;
      } else {
        TotalCompltedCount = 0;
      }

      _pageNo = state.newPage;
    }
  }


  showcustomdialog123({
    BuildContext context1,
    ToDoDetails finalCheckingItems,
    int index1,
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
                    "Remarks",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery
                    .of(context123)
                    .size
                    .width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 7, right: 7, top: 5),
                            child: TextFormField(
                              controller: Remarks,
                              minLines: 2,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Enter Description',
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
                    SizedBox(
                      height: 10,
                    ),
                    getCommonButton(baseTheme, () {
                      if (Remarks.text != "") {
                        Navigator.pop(context123);

                        String AM_PM =
                        selectedTime.periodOffset.toString() == "12"
                            ? "PM"
                            : "AM";
                        String beforZeroHour = selectedTime.hourOfPeriod <= 9
                            ? "0" + selectedTime.hourOfPeriod.toString()
                            : selectedTime.hourOfPeriod.toString();
                        String beforZerominute = selectedTime.minute <= 9
                            ? "0" + selectedTime.minute.toString()
                            : selectedTime.minute.toString();

                        String TimeHour =
                            beforZeroHour + ":" + beforZerominute + " " + AM_PM;
                        _officeToDoScreenBloc.add(ToDoSaveHeaderEvent(context,
                            finalCheckingItems.pkID,
                            ToDoHeaderSaveRequest(
                                Priority: "Medium",
                                TaskDescription: Remarks.text,
                                Location: finalCheckingItems.location,
                                TaskCategoryID: finalCheckingItems
                                    .taskCategoryId
                                    .toString(),
                                StartDate: finalCheckingItems.startDate
                                    .getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat: "yyyy-MM-dd") +
                                    " " +
                                    TimeHour,
                                DueDate: finalCheckingItems.dueDate
                                    .getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat: "yyyy-MM-dd") +
                                    " " +
                                    TimeHour,
                                CompletionDate: finalCheckingItems.startDate
                                    .getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat: "yyyy-MM-dd"),
                                LoginUserID: LoginUserID,
                                EmployeeID:
                                finalCheckingItems.employeeID.toString(),
                                Reminder: "",
                                ReminderMonth: "",
                                Latitude: "",
                                Longitude: "",
                                ClosingRemarks:
                                finalCheckingItems.closingRemarks,
                                CompanyId: CompanyID.toString())));
                      } else {
                        commonalertbox("Remarks should not Empty");
                      }
                    }, "Submit Details",
                        backGroundColor: colorPrimary,
                        textColor: colorWhite,
                        width: 200)
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget commonalertbox(String msg,
      {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ab) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            actions: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorPrimary, width: 2.00),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Alert!",
                  style: TextStyle(
                    fontSize: 20,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                //margin: EdgeInsets.only(left: 10),
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 1.00,
                thickness: 2.00,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: onTapofPositive ??
                        () {
                      Navigator.of(context, rootNavigator: useRootNavigator)
                          .pop();
                    },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  TO_DO() {
    return InkWell(
      onTap: () {
        setState(() {
          IsExpandedOverDue = false;
          IsExpandedTodays = !IsExpandedTodays;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xffef6f6c),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedTodays == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Today " + " (" + TotalTodayCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(

                  onTap: () {
                    navigateTo(context, OfficeToDoAddEditScreen.routeName,
                        clearAllStack: true);
                  },
                  child: Icon(Icons.add, color: Colors.white,)),
            ],
          ),
        ),
      ),
    );
  }


  FOLLOWUP() {
    return InkWell(
      onTap: () {
        setState(() {
          IsExpandedMissed = false;
          IsExpandedFuture = false;

          IsExpandedFTodays = !IsExpandedFTodays;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xffef6f6c),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedFTodays == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Today " + " (" + TotalFTodayCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(

                  onTap: () {
                     //navigateTo(context, OfficeFollowUpAddEditScreen.routeName,clearAllStack: true);



                     navigateTo(context,
                         OfficeFollowUpAddEditScreen.routeName,
                         arguments:
                         OfficeFollowupScreenArguments(FollowupStatus:"Todays"))
                         .then((value) {
                       setState(() {
                         // followerEmployeeList();
                         _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
                             "Todays",
                             FollowupFilterListRequest(
                                 CompanyId: CompanyID.toString(),
                                 LoginUserID: edt_FollowupEmployeeUserID.text,
                                 PageNo: 1,
                                 PageSize: 10000)));
                         _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
                             "Missed",
                             FollowupFilterListRequest(
                                 CompanyId: CompanyID.toString(),
                                 LoginUserID: edt_FollowupEmployeeUserID.text,
                                 PageNo: 1,
                                 PageSize: 10000)));
                         _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
                             "Future",
                             FollowupFilterListRequest(
                                 CompanyId: CompanyID.toString(),
                                 LoginUserID: edt_FollowupEmployeeUserID.text,
                                 PageNo: 1,
                                 PageSize: 10000)));

                         print("dfjhdjh" + value);

                       });
                     });
                  },
                  child: Icon(Icons.add, color: Colors.white,)),
            ],
          ),
        ),
      ),
    );
  }

  OVER_DUEU() {
    return InkWell(
      onTap: () {
        setState(() {
          IsExpandedTodays = false;
          IsExpandedOverDue = !IsExpandedOverDue;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        color: Color(0xffef6f6c),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedOverDue == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Pending " + " (" + TotalOverDueCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(

                  onTap: () {
                    navigateTo(context, OfficeToDoAddEditScreen.routeName,
                        clearAllStack: true);
                  },
                  child: Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  PENDING_OVER_DUEU() {
    return InkWell(
      onTap: () {
        setState(() {
          IsExpandedTodays = false;
          IsExpandedOverDue = false;
          IsExpandedPendingOverDue = !IsExpandedPendingOverDue;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        color: Color(0xffef6f6c),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedPendingOverDue == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Pending-OverDue " + " (" + TotalPendingOverDueCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(

                  onTap: () {
                    navigateTo(context, OfficeToDoAddEditScreen.routeName,
                        clearAllStack: true);
                  },
                  child: Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }



  TODO_FUTURE() {
    return InkWell(
      onTap: () {
        setState(() {
         /* IsExpandedTodays = false;
          IsExpandedOverDue = !IsExpandedOverDue;*/

          IsExpandedTodays = false;
          IsExpandedOverDue = false;
          IsExpandedPendingOverDue = false;
          IsExpandedTodoFuture = !IsExpandedTodoFuture;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        color: Color(0xffef6f6c),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedTodoFuture == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Future " + " (" + TotalTodoFutureCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(

                  onTap: () {
                    navigateTo(context, OfficeToDoAddEditScreen.routeName,
                        clearAllStack: true);
                  },
                  child: Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }


  Missed() {
    return InkWell(
      onTap: () {
        setState(() {
          IsExpandedFTodays = false;
           IsExpandedFuture = false;
          IsExpandedMissed = !IsExpandedMissed;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        color: Color(0xffef6f6c),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedMissed == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Missed " + " (" + TotalMissedCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(

                  onTap: () {
                    // navigateTo(context, OfficeToDoAddEditScreen.routeName,clearAllStack: true);
                    navigateTo(context,
                        OfficeFollowUpAddEditScreen.routeName,
                        arguments:
                        OfficeFollowupScreenArguments(FollowupStatus:"Missed"))
                        .then((value) {
                      setState(() {
                        // followerEmployeeList();
                        _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
                            "Todays",
                            FollowupFilterListRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: edt_FollowupEmployeeUserID.text,
                                PageNo: 1,
                                PageSize: 10000)));
                        _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
                            "Missed",
                            FollowupFilterListRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: edt_FollowupEmployeeUserID.text,
                                PageNo: 1,
                                PageSize: 10000)));
                        _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
                            "Future",
                            FollowupFilterListRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: edt_FollowupEmployeeUserID.text,
                                PageNo: 1,
                                PageSize: 10000)));

                        print("dfjhdjh" + value);

                      });
                    });

                  },
                  child: Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  FUTURE() {
    return InkWell(
      onTap: () {
        setState(() {
          IsExpandedFTodays =false;
           IsExpandedMissed = false;
          IsExpandedFuture = !IsExpandedFuture;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        color: Color(0xffef6f6c),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedFuture == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Future " + " (" + TotalFutureCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(

                  onTap: () {
                    // navigateTo(context, OfficeToDoAddEditScreen.routeName,clearAllStack: true);

                    navigateTo(context,
                        OfficeFollowUpAddEditScreen.routeName,
                        arguments:
                        OfficeFollowupScreenArguments(FollowupStatus:"Future"))
                        .then((value) {
                      setState(() {
                        // followerEmployeeList();
                        _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
                            "Todays",
                            FollowupFilterListRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: edt_FollowupEmployeeUserID.text,
                                PageNo: 1,
                                PageSize: 10000)));
                        _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
                            "Missed",
                            FollowupFilterListRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: edt_FollowupEmployeeUserID.text,
                                PageNo: 1,
                                PageSize: 10000)));
                        _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
                            "Future",
                            FollowupFilterListRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: edt_FollowupEmployeeUserID.text,
                                PageNo: 1,
                                PageSize: 10000)));

                        print("dfjhdjh" + value);

                      });
                    });
                  },
                  child: Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }



  TodayCompleted() {
    return InkWell(
      onTap: () {
        setState(() {
          IsExpandedCompleted = !IsExpandedCompleted;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff39c3aa),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IsExpandedCompleted == true
                      ? Icon(
                      Icons.keyboard_arrow_up_outlined, color: Colors.white)
                      : Icon(
                      Icons.keyboard_arrow_down_rounded, color: Colors.white),

                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Completed" + "(" + TotalCompltedCount.toString() + ")",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _OnTODOSaveResponse(ToDoSaveHeaderState state) {
    print("TodoSave" + state.toDoSaveHeaderResponse.details[0].column2);
    _officeToDoScreenBloc.add(ToDoTodayListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Todays",
        PageNo: 1,
        PageSize: 10000)));
    _officeToDoScreenBloc.add(ToDoOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Todays",
        PageNo: 1,
        PageSize: 10000)));
    _officeToDoScreenBloc.add(ToDoOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Pending",
        PageNo: 1,
        PageSize: 10000)));

    _officeToDoScreenBloc.add(ToDoPendingOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Pending-OverDue",
        PageNo: 1,
        PageSize: 10000)));
    _officeToDoScreenBloc.add(ToDoTComplitedListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Completed",
        PageNo: 1,
        PageSize: 10000)));
  }

  void _OnTaptoDeleteTodo(ToDoDeleteResponseState state) {
    print("TodoDelete" + state.toDoDeleteResponse.details[0].column1);
    _officeToDoScreenBloc.add(ToDoTodayListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Todays",
        PageNo: 1,
        PageSize: 10000)));
    _officeToDoScreenBloc.add(ToDoOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Todays",
        PageNo: 1,
        PageSize: 10000)));
    _officeToDoScreenBloc.add(ToDoOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Pending",
        PageNo: 1,
        PageSize: 10000)));
    _officeToDoScreenBloc.add(ToDoPendingOverDueListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Pending-OverDue",
        PageNo: 1,
        PageSize: 10000)));
    _officeToDoScreenBloc.add(ToDoTComplitedListCallEvent(OfficeToListRequest(
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID,
        TaskStatus: "Completed",
        PageNo: 1,
        PageSize: 10000)));
  }

  void _onTodaysFollowupResponse(FollowupFilterListCallResponseState state) {
    if (_FpageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FTodaysListResponse = state.followupFilterListResponse;
      } else {
        _FTodaysListResponse.details.addAll(
            state.followupFilterListResponse.details);
      }
      if (_FTodaysListResponse.details.length != 0) {
        TotalFTodayCount = state.followupFilterListResponse.totalCount;
      } else {
        TotalFTodayCount = 0;
      }

      _FpageNo = state.newPage;
    }
  }

  _buildFTodayList() {
    if (_FTodaysListResponse == null) {
      return Container();
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            // _onFollowupTodayListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildFTodayListItem(index);
            },
            shrinkWrap: true,
            itemCount: _FTodaysListResponse.details.length,
          ),
        ),
      );
    }
    //_buildFTodayListItem
  }

  void _onMissedFollowupResponse(
      FollowupMissedFilterListCallResponseState state) {
    if (_FpageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FMissedListResponse = state.followupFilterListResponse;
      } else {
        _FMissedListResponse.details.addAll(
            state.followupFilterListResponse.details);
      }
      if (_FMissedListResponse.details.length != 0) {
        TotalMissedCount = state.followupFilterListResponse.totalCount;
      } else {
        TotalMissedCount = 0;
      }

      _FpageNo = state.newPage;
    }
  }

  void _onFutureFollowupResponse(
      FollowupFutureFilterListCallResponseState state) {
    if (_FpageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FFutureListResponse = state.followupFilterListResponse;
      } else {
        _FFutureListResponse.details.addAll(
            state.followupFilterListResponse.details);
      }
      if (_FFutureListResponse.details.length != 0) {
        TotalFutureCount = state.followupFilterListResponse.totalCount;
      } else {
        TotalFutureCount = 0;
      }

      _FpageNo = state.newPage;
    }
  }


  void getAddressFromLatLong() async {
    if (MapAPIKey != "") {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: double.parse(SharedPrefHelper.instance.getLatitude()),
          longitude: double.parse(SharedPrefHelper.instance.getLongitude()),
          googleMapApiKey: MapAPIKey);

      Address = data.address;
    }

    print("sfjsdf" + Address);
  }


  void _OnAttendanceListResponse(AttendanceListCallResponseState state) {
    String PDate = "";
    String CDate = "";

    if (state.response.details.isNotEmpty) {
      for (int i = 0; i < state.response.details.length; i++) {
        /*PresenceDate*/
        if (state.response.details[i].presenceDate != "") {
          PDate = state.response.details[i].presenceDate.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
          print("APIDAte" + PDate);

          CDate = selectedDate.day.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.year.toString();
          print("CurrentDAte" + CDate);

          DateTime APIDate = new DateFormat("dd-MM-yyyy").parse(PDate);
          DateTime CurrentDate = new DateFormat("dd-MM-yyyy").parse(CDate);

          if (APIDate == CurrentDate) {
            getAddressFromLatLong();

            print("ConditionTrue");

            if (state.response.details[i].timeIn != "") {
              PuchInTime.text = state.response.details[i].timeIn.toString();
              isPunchIn = true;
            } else {
              isPunchIn = false;
              PuchInTime.text = "";
            }
            if (state.response.details[i].timeOut != "") {
              PuchOutTime.text = state.response.details[i].timeOut.toString();

              isPunchOut = true;
            } else {
              isPunchOut = false;
              PuchOutTime.text = "";
            }

            if (state.response.details[i].LunchIn != "") {
              LunchInTime.text = state.response.details[i].LunchIn.toString();

              isLunchIn = true;
            } else {
              isLunchIn = false;
              LunchInTime.text = "";
            }
            if (state.response.details[i].LunchOut != "") {
              LunchOutTime.text = state.response.details[i].LunchOut.toString();

              isLunchOut = true;
            } else {
              isLunchOut = false;
              LunchOutTime.text = "";
            }

            break;
          } else {
            isPunchIn = false;
            isPunchOut = false;
            isLunchIn = false;
            isLunchOut = false;
            PuchInTime.text = ""; //state.response.details[i].timeIn.toString();
            PuchOutTime.text =
            ""; //state.response.details[i].timeOut.toString();
            LunchInTime.text = "";
            LunchOutTime.text = "";
            print("ConditionFalse");
            // isPunchIn = false;
          }
        }

        print("TodayAttendance" +
            "Emp_Name : " +
            state.response.details[i].employeeName +
            " InTime : " +
            state.response.details[i].timeIn.toString());
      }
    } else {
      isPunchIn = false;
      isPunchOut = false;
    }
  }

  void _onGetConstant(ConstantResponseState state) {
    print("ConstantValue" + state.response.details[0].value.toString());

    ConstantMAster = state.response.details[0].value.toString();
  }


  void _onPunchAttandanceSaveResponse(PunchAttendenceSaveResponseState state) {
    _officeToDoScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  void _onAttandanceSaveResponse(AttendanceSaveCallResponseState state) {
    _officeToDoScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }


  void _OnPunchOutWithoutImageSucess(
      PunchWithoutAttendenceSaveResponseState state) {
    _officeToDoScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
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

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print('testCompressAndGetFile');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );
    print(file.lengthSync());
    print(result?.lengthSync());
    return result;
  }
  void getcurrentTimeInfoFromMaindfd() async {
    DateTime startDate = await NTP.now();
    print('NTP DateTime: ${startDate} ${DateTime.now()}');

    var now = startDate;
    var formatter = new DateFormat('yyyy-MM-ddTHH');
    String currentday = formatter.format(now);
    String PresentDate1 = formatter.format(DateTime.now());
    print(
        'NTP DateTime123456: ${DateTime.parse(currentday)} ${DateTime.parse(PresentDate1)}');

    if (DateTime.parse(currentday) != DateTime.parse(PresentDate1)) {
      //  navigateTo(context, AttendanceListScreen.routeName, clearAllStack: true);
      isCurrentTime = false;

      return showCommonDialogWithSingleOption(context,
          "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            navigateTo(context, HomeScreen.routeName, clearAllStack: true);
          });
    } else {
      isCurrentTime = true;
    }
  }
  lunchoutLogic() async {
    if (isLunchIn == true) {
      TimeOfDay selectedTime = TimeOfDay.now();

      if (isPunchOut == false) {



        if (isLunchOut == true) {

          showCommonDialogWithSingleOption(
              context,
              _offlineLoggedInData.details[0].employeeName +
                  " \n Lunch Out : " +
                  LunchOutTime.text,
              positiveButtonTitle: "OK");
        } else {
          if (ConstantMAster.toString() == "" ||
              ConstantMAster.toString().toLowerCase() == "no") {
            _officeToDoScreenBloc.add(
                PunchWithoutImageAttendanceSaveRequestEvent(
                    PunchWithoutImageAttendanceSaveRequest(
                        Mode: "lunchout",
                        pkID: "0",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        PresenceDate: selectedDate.year.toString() +
                            "-" +
                            selectedDate.month.toString() +
                            "-" +
                            selectedDate.day.toString(),
                        TimeIn: "",
                        TimeOut: "",
                        LunchIn: "",
                        LunchOut: selectedTime.hour.toString() +
                            ":" +
                            selectedTime.minute.toString(),
                        LoginUserID: LoginUserID,
                        Notes: "",
                        Latitude: SharedPrefHelper.instance.getLatitude(),
                        Longitude: SharedPrefHelper.instance.getLongitude(),
                        LocationAddress: Address,
                        CompanyId: CompanyID.toString())));
          } else {
            final imagepicker = ImagePicker();

            XFile file = await imagepicker.pickImage(
              source: ImageSource.camera,
              imageQuality: 85,
            );

            if (file != null) {
              File file1 = File(file.path);

              final dir = await path_provider.getTemporaryDirectory();

              final extension = p.extension(file1.path);

              int timestamp1 = DateTime.now().millisecondsSinceEpoch;

              String filenameLunchOut =
                  _offlineLoggedInData.details[0].employeeID.toString() +
                      "_" +
                      DateTime.now().day.toString() +
                      "_" +
                      DateTime.now().month.toString() +
                      "_" +
                      DateTime.now().year.toString() +
                      "_" +
                      timestamp1.toString() +
                      extension;

              final targetPath = dir.absolute.path + "/" + filenameLunchOut;
              File file1231 = await testCompressAndGetFile(file1, targetPath);
              final bytes = file1.readAsBytesSync().lengthInBytes;
              final kb = bytes / 1024;
              final mb = kb / 1024;

              print("Image File Is Largre" +
                  " KB : " +
                  kb.toString() +
                  " MB : " +
                  mb.toString());
              final snackBar = SnackBar(
                content:
                Text(" KB : " + kb.toString() + " MB : " + mb.toString()),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              _officeToDoScreenBloc.add(PunchAttendanceSaveRequestEvent(
                  file1231,
                  PunchAttendanceSaveRequest(
                    pkID: "0",
                    CompanyId: CompanyID.toString(),
                    Mode: "lunchout",
                    EmployeeID:
                    _offlineLoggedInData.details[0].employeeID.toString(),
                    FileName: filenameLunchOut,
                    PresenceDate: selectedDate.year.toString() +
                        "-" +
                        selectedDate.month.toString() +
                        "-" +
                        selectedDate.day.toString(),
                    Time: selectedTime.hour.toString() +
                        ":" +
                        selectedTime.minute.toString(),
                    Notes: "",
                    Latitude: SharedPrefHelper.instance.getLatitude(),
                    Longitude: SharedPrefHelper.instance.getLongitude(),
                    LocationAddress: Address,
                    LoginUserId: LoginUserID,
                  )));
            }
          }
        }

      } else {
        if (isLunchOut == false) {
          showCommonDialogWithSingleOption(
              context, "After Punch Out, You can't be able to do Lunch Out!!",
              positiveButtonTitle: "OK");
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Lunch in Is Required !",
          positiveButtonTitle: "OK");
    }
  }

  punchoutLogic() async {
    if (isPunchIn == true) {
      TimeOfDay selectedTime = TimeOfDay.now();




      if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
          "SW0T-GLA5-IND7-AS71") {
        ///MustCheck
        ///showcustomdialogSendEmail(context1: context, att: punchAttendanceSaveRequest);
      }

      if (isPunchOut == true) {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "SW0T-GLA5-IND7-AS71") {
          ///MustCheck
          ///showcustomdialogSendEmail(context1: context, att: punchAttendanceSaveRequest);
        } else {
          showCommonDialogWithSingleOption(
              context,
              _offlineLoggedInData.details[0].employeeName +
                  " \n Punch Out : " +
                  PuchOutTime.text,
              positiveButtonTitle: "OK");
        }
      } else {
        if (await Permission.storage.isDenied) {
          //await Permission.storage.request();

          checkPhotoPermissionStatus();
        } else {
          if (ConstantMAster.toString() == "" ||
              ConstantMAster.toString().toLowerCase() == "no") {
            _officeToDoScreenBloc.add(
                PunchWithoutImageAttendanceSaveRequestEvent(
                    PunchWithoutImageAttendanceSaveRequest(
                        Mode: "punchout",
                        pkID: "0",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        PresenceDate: selectedDate.year.toString() +
                            "-" +
                            selectedDate.month.toString() +
                            "-" +
                            selectedDate.day.toString(),
                        TimeIn: "",
                        TimeOut: selectedTime.hour.toString() +
                            ":" +
                            selectedTime.minute.toString(),
                        LunchIn: "",
                        LunchOut: "",
                        LoginUserID: LoginUserID,
                        Notes: "",
                        Latitude: SharedPrefHelper.instance.getLatitude(),
                        Longitude: SharedPrefHelper.instance.getLongitude(),
                        LocationAddress: Address,
                        CompanyId: CompanyID.toString())));
          } else {
            final imagepicker = ImagePicker();

            XFile file = await imagepicker.pickImage(
                source: ImageSource.camera, imageQuality: 85);




            if (file != null) {
              File file1 = File(file.path);

              final dir = await path_provider.getTemporaryDirectory();

              final extension = p.extension(file1.path);

              int timestamp1 = DateTime.now().millisecondsSinceEpoch;

              String filenamepunchout =
                  _offlineLoggedInData.details[0].employeeID.toString() +
                      "_" +
                      DateTime.now().day.toString() +
                      "_" +
                      DateTime.now().month.toString() +
                      "_" +
                      DateTime.now().year.toString() +
                      "_" +
                      timestamp1.toString() +
                      extension;

              final targetPath = dir.absolute.path + "/" + filenamepunchout;
              File file1231 = await testCompressAndGetFile(file1, targetPath);
              final bytes = file1.readAsBytesSync().lengthInBytes;
              final kb = bytes / 1024;
              final mb = kb / 1024;

              print("Image File Is Largre" +
                  " KB : " +
                  kb.toString() +
                  " MB : " +
                  mb.toString() +
                  " Location : " +
                  " Lat : " +
                  SharedPrefHelper.instance.getLatitude() +
                  " Long : " +
                  SharedPrefHelper.instance.getLongitude() +
                  " Address : " +
                  Address);
              final snackBar = SnackBar(
                content: Text(" KB : " +
                    kb.toStringAsFixed(2) +
                    " MB : " +
                    mb.toStringAsFixed(2) +
                    " Location : " +
                    " Lat : " +
                    SharedPrefHelper.instance.getLatitude() +
                    " Long : " +
                    SharedPrefHelper.instance.getLongitude() +
                    " Address : " +
                    Address),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              _officeToDoScreenBloc.add(PunchAttendanceSaveRequestEvent(
                  file1231,
                  PunchAttendanceSaveRequest(
                    pkID: "0",
                    CompanyId: CompanyID.toString(),
                    Mode: "punchout",
                    EmployeeID:
                    _offlineLoggedInData.details[0].employeeID.toString(),
                    FileName: filenamepunchout,
                    PresenceDate: selectedDate.year.toString() +
                        "-" +
                        selectedDate.month.toString() +
                        "-" +
                        selectedDate.day.toString(),
                    Time: selectedTime.hour.toString() +
                        ":" +
                        selectedTime.minute.toString(),
                    Notes: "",
                    Latitude: SharedPrefHelper.instance.getLatitude(),
                    Longitude: SharedPrefHelper.instance.getLongitude(),
                    LocationAddress: Address,
                    LoginUserId: LoginUserID,
                  )));
            }
          }
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Punch in Is Required !",
          positiveButtonTitle: "OK");
    }
  }


  SendEmailOnlyImg({BuildContext context1, String Email}) async {
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
                    "Send Email",
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
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Email To.",
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
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller: EmailTO,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter email To",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
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
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                                () async {
                              if (EmailTO.text != "") {
                                bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(EmailTO.text);

                                if (emailValid == true) {
                                  String webreq = SiteURL +
                                      "/DashboardDaily.aspx?MobilePdf=yes&userid=" +
                                      LoginUserID +
                                      "&password=" +
                                      Password +
                                      "&emailaddress=" +
                                      EmailTO.text;

                                  print("webreq" + webreq);


                                  _showMyDialog(context123, EmailTO.text);
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Email is not valid !",
                                      positiveButtonTitle: "OK");
                                }
                                // GenerateQT(context123, EmailTO.text);
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Email TO is Required !",
                                    positiveButtonTitle: "OK");
                              }
                            },
                            "YES",
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                                () {
                              Navigator.pop(context);
                            },
                            "NO",
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(
      BuildContext dailogContext, String textEmaill) async {
    return showDialog<int>(
      context: dailogContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext dailogContextsub) {
        return AlertDialog(
          title: Text('Please wait ...!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQT(dailogContext, textEmaill),
                ),

                //GetCircular123(),
              ],
            ),
          ),

        );
      },
    );
  }


  GenerateQT(BuildContext dailogContext, String emailTOstr) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/DashboardDaily.aspx?MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&emailaddress=" +
                          emailTOstr)),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },

                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;
                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        return NavigationActionPolicy.CANCEL;
                      }
                    }
                    //islodding = false;

                    return NavigationActionPolicy.CANCEL;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      islodding = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;
                        print("dfkpageTitle" + value);

                        if (pageTitle == "E-Office-Desk") {
                          Navigator.pop(dailogContext);
                          showCommonDialogWithSingleOption(
                              dailogContext, "Email Sent Successfully ",
                              onTapOfPositiveButton: () {
                                Navigator.pop(dailogContext);
                                Navigator.pop(context);
                              });
                        } else {
                          Navigator.pop(dailogContext);
                          showCommonDialogWithSingleOption(
                              dailogContext, "Please Try Again !");
                        }
                      });
                    });


                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;

                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },

                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      islodding = false;
                    });
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )

          ],
        ),
      ),
    );
  }


  Widget _buildEmplyeeListView() {
    return Column(
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
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 12,bottom: 3),
                child: Row(
                  children: [
                    Text("Select Employee",style:TextStyle(fontSize: 10,color: colorWhite,fontWeight: FontWeight.bold),),
                    SizedBox(width: 5,),
                    Icon(Icons.filter_list_alt,color: colorWhite,size: 15,)
                  ],
                ),
              ),
              Card(
                elevation: 5,
                color: colorWhite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 15),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child:

                        TextField(
                          controller: edt_FollowupEmployeeList,
                          enabled: false,
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
                              hintText: "Select Employee"),
                        ),
                        // dropdown()
                      ),
                        Icon(
                        Icons.arrow_drop_down,
                        color: colorBlack,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  followupStatusListener() {
    _officeToDoScreenBloc.add(FollowupFilterListCallEvent(
        "Todays",
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10000)));

    _officeToDoScreenBloc.add(FollowupMissedFilterListCallEvent(
        "Missed",
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10000)));


    _officeToDoScreenBloc.add(FollowupFutureFilterListCallEvent(
        "Future",
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10000)));

  }

  void _onFollowerEmployeeListByStatusCallSuccess(FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  void _onTODOFutureListResponse(ToDoFutureListCallResponseState state) {

    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FollowupFutureListResponse = state.response;
      } else {
        _FollowupFutureListResponse.details.addAll(state.response.details);
      }

      if (_FollowupFutureListResponse.details.length != 0) {
        TotalTodoFutureCount = state.response.totalCount;
      } else {
        TotalTodoFutureCount = 0;
      }

      _pageNo = state.newPage;
    }
  }

}
