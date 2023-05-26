import 'dart:convert';
import 'dart:io' show Directory, File, Platform, exit;
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shine/flutter_shine.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_request/Logout_Count/logout_count_request.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/dashboard/dashboard_user_rights_screen_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/api_token/api_token_update_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/company_details/company_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/constant_master/constant_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/all_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/follower_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/menu_rights_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/push_notification_service.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Complaint/complaint_pagination_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/ToDo/to_do_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/external_lead/external_lead_list/external_lead_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/followup_pagination_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/leave_request/leave_request_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salebill/sale_bill_list/sales_bill_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/salesorder_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/QuickAttendance/quick_attendance.dart';
import 'package:for_practice_the_app/ui/screens/authentication/first_screen.dart';
import 'package:for_practice_the_app/ui/screens/authentication/serial_key_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/image_full_screen.dart';
import 'package:for_practice_the_app/utils/local_notification/local_notification_manager.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // or whatever name you want
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class HomeScreen extends BaseStatefulWidget {
  static const routeName = '/homeScreen';
//From Sinor+++

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen>
    with BasicScreen, WidgetsBindingObserver {
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  ALL_EmployeeList_Response _offlineALLEmployeeListData;
  DashBoardScreenBloc _dashBoardScreenBloc;

  bool isCustomerExist = false;
  bool isInquiryExist = false;
  bool isFollowupExist = false;
  bool isLeaveRequestExist = false;
  bool isLeaveApprovalExist = false;
  bool isAttendanceExist = false;
  bool isExpenseExist = false;
  bool isPunchIn = false;
  bool isPunchOut = false;
  bool isLunchIn = false;
  bool isLunchOut = false;
  bool IsExistInIOS = false;
  bool isLoading = true;
  bool islodding = true;
  bool onWebLoadingStop = false;
  bool isCurrentTime = true;

  List<MenuDetails> array_MenuRightsList;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_HR = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Lead = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Office = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Support = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Purchase = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Production = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Account = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Dealer = [];

  List<ALL_Name_ID> arr_UserRightsWithMenuName = [];

  List<String> SplitSTr = [];

  final TextEditingController PuchInTime = TextEditingController();
  final TextEditingController PuchOutTime = TextEditingController();
  final TextEditingController LunchInTime = TextEditingController();
  final TextEditingController LunchOutTime = TextEditingController();
  final TextEditingController ImgFromTextFiled = TextEditingController();

  final TextEditingController PuchInboolcontroller = TextEditingController();
  final TextEditingController PuchOutboolcontroller = TextEditingController();
  final TextEditingController LunchInboolcontroller = TextEditingController();
  final TextEditingController LunchOutboolcontroller = TextEditingController();

  final urlController = TextEditingController();
  TextEditingController EmailTO = TextEditingController();
  TextEditingController EmailBCC = TextEditingController();

  String SiteURL = "";
  String Password = "";
  String LoginUserID = "";
  String MapAPIKey = "";
  String IOSAPPStatus = "";
  String AndroidAppStatus = "";
  String url = "";
  String TitleNAme = "";
  String mid = "Default";
  String EmployeeImage = "https://img.icons8.com/color/2x/no-image.png";
  String EmployeeImageNew = "https://img.icons8.com/color/2x/no-image.png";
  String Address;
  String ISDelaer = "";

  int CompanyID = 0;
  int prgresss = 0;

  double progress = 0;

  /*InAppWebViewController webViewController;
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
  ContextMenu contextMenu;*/
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  var delay = const Duration(seconds: 3);
  FirebaseMessaging _messaging;

  //final FirebaseMessaging _firebaseMessaging;//= FirebaseMessaging();
  //PushNotificationService pushNotificationService = PushNotificationService();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;

  File Lunch_In_OUT_File;

  String ConstantMAster = "";

  String LatitudeHome = "23.0115394";
  String LongitudeHome = "72.5235199";

  bool islead = false;
  bool isSale = false;
  bool isAccount = false;
  bool isProduction = false;
  bool isHR = false;
  bool isPurchase = false;
  bool isOffice = false;
  bool isSupport = false;

  final double runSpacing = 4;
  final double spacing = 4;
  final columns = 4;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();

    _dashBoardScreenBloc = DashBoardScreenBloc(baseBloc);

    PuchInboolcontroller.text = "";
    PuchOutboolcontroller.text = "";
    LunchInboolcontroller.text = "";
    LunchOutboolcontroller.text = "";

    imageCache.clear();
    initPlatformState();
    checkPhotoPermissionStatus();

    ISDelaer = SharedPrefHelper.instance.prefs.getString("Is_Dealer");

    print("dfdfdleif" + ISDelaer);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getcurrentTimeInfoFromMaindfd();
    screenStatusBarColor = colorWhite;

    EmailTO.text = "";
    //normal Notification
    // registerNotification();
    //When App is in Terminated
    //checkIntialMessage();
    //pushNotificationService.setupInteractedMessage();
    //pushNotificationService.enableIOSNotifications();
    //pushNotificationService.registerNotificationListeners();
    //pushNotificationService.getmesssageappkillstate();
    //pushNotificationService.getToken();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    _dashBoardScreenBloc.add(CompanyDetailsCallEvent(CompanyDetailsApiRequest(
        serialKey: _offlineLoggedInData.details[0].serialKey.toString())));

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    MapAPIKey = _offlineCompanyData.details[0].MapApiKey;

    print("MapAPIKey" + MapAPIKey);
    IOSAPPStatus = _offlineCompanyData.details[0].IOSApp;

    print("IOSAPPStatussdsd" + IOSAPPStatus);

    AndroidAppStatus = _offlineCompanyData.details[0].AndroidApp;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password = _offlineLoggedInData.details[0].userPassword;
    print("SiteURL345" +
        " Site URL : " +
        SiteURL +
        " LoginUserID : " +
        LoginUserID +
        " PassWord : " +
        Password);
    ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";

    checkPermissionStatus();
    FirebaseMessaging.instance.getToken().then((token) async {
      final tokenStr = token.toString();
      // do whatever you want with the token here
      print("sfjsdfj" + tokenStr);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("TokenSP", tokenStr);

      _dashBoardScreenBloc
        ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
            CompanyId: CompanyID.toString(),
            UserID: LoginUserID,
            TokenNo: tokenStr)));
    });

    _dashBoardScreenBloc
      ..add(FollowerEmployeeListCallEvent(FollowerEmployeeListRequest(
          CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    _dashBoardScreenBloc
      ..add(ALLEmployeeNameCallEvent(
          ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));

    getLeadListFromDashBoard(arr_ALL_Name_ID_For_Lead);
    getSaleListFromDashBoard(arr_ALL_Name_ID_For_Sales);
    getAccountListFromDashBoard(arr_ALL_Name_ID_For_Account);
    getHRListFromDashBoard(arr_ALL_Name_ID_For_HR);
    getOfficeListFromDashBoard(arr_ALL_Name_ID_For_Office);
    getSupportListFromDashBoard(arr_ALL_Name_ID_For_Support);
    getPurchaseListFromDashBoard(arr_ALL_Name_ID_For_Purchase);
    getProductionListFromDashBoard(arr_ALL_Name_ID_For_Production);
    getDealerListFromDashBoard(arr_ALL_Name_ID_For_Dealer);

    _dashBoardScreenBloc.add(ConstantRequestEvent(
        CompanyID.toString(),
        ConstantRequest(
            ConstantHead: "AttendenceWithImage",
            CompanyId: CompanyID.toString())));
    //ConstantRequestEvent
    /* _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));*/

    if (_offlineLoggedInData.details[0].EmployeeImage != "" ||
        _offlineLoggedInData.details[0].EmployeeImage != null) {
      setState(() {
        ImgFromTextFiled.text =
            _offlineLoggedInData.details[0].EmployeeImage == null ||
                    _offlineLoggedInData.details[0].EmployeeImage == ""
                ? ""
                : _offlineCompanyData.details[0].siteURL +
                    _offlineLoggedInData.details[0].EmployeeImage.toString();
      });
    } else {
      ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";
    }

    getDetailsOfImage(
        "https://img.icons8.com/color/2x/no-image.png", "demo.png");

    PuchInboolcontroller.addListener(timeChangesEvent);
    PuchOutboolcontroller.addListener(timeChangesEvent);
    LunchInboolcontroller.addListener(timeChangesEvent);
    LunchOutboolcontroller.addListener(timeChangesEvent);

    NotificationController.startListeningNotificationEvents();
    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.setupInteractedMessage();
    pushNotificationService.getToken();
    //NotificationController.startListeningNotificationEvents();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    SplitSTr = [];
    PuchInTime.dispose();
    PuchOutTime.dispose();
    ImgFromTextFiled.dispose();
  }

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dashBoardScreenBloc
        ..add(MenuRightsCallEvent(MenuRightsRequest(
            CompanyID: CompanyID.toString(), LoginUserID: LoginUserID))),
      child: BlocConsumer<DashBoardScreenBloc, DashBoardScreenStates>(
        builder: (BuildContext context, DashBoardScreenStates state) {
          //handle states

          if (state is ComapnyDetailsEventResponseState) {
            _OnCompanyResponse(state);
          }

          if (state is APITokenUpdateState) {
            _OnTokenUpdateResponse(state);
          }
          if (state is MenuRightsEventResponseState) {
            _onDashBoardCallSuccess(state, context);
          }

          if (state is FollowerEmployeeListByStatusCallResponseState) {
            _onFollowerEmployeeListByStatusCallSuccess(state);
          }

          if (state is ALL_EmployeeNameListResponseState) {
            _onALLEmployeeListByStatusCallSuccess(state);
          }

          if (state is AttendanceListCallResponseState) {
            _OnAttendanceListResponse(state);
          }
          if (state is EmployeeListResponseState) {
            _OnFethEmployeeImage(state);
          }

          if (state is ConstantResponseState) {
            _onGetConstant(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called

          if (currentState is APITokenUpdateState ||
              currentState is MenuRightsEventResponseState ||
              currentState is FollowerEmployeeListByStatusCallResponseState ||
              currentState is ALL_EmployeeNameListResponseState ||
              currentState is AttendanceListCallResponseState ||
              currentState is EmployeeListResponseState ||
              currentState is ConstantResponseState ||
              currentState is ComapnyDetailsEventResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DashBoardScreenStates state) {
          if (state is PunchAttendenceSaveResponseState) {
            _onPunchAttandanceSaveResponse(state);
          }

          if (state is AttendanceSaveCallResponseState) {
            _onAttandanceSaveResponse(state);
          }

          if (state is PunchOutWebMethodState) {
            _OnwebSucessResponse(state);
          }

          if (state is PunchWithoutAttendenceSaveResponseState) {
            _OnPunchOutWithoutImageSucess(state);
          }

          if (state is LogOutCountResponseState) {
            _OnLogoutCount(state);
          }
          //handle states
        },
        listenWhen: (oldState, currentState) {
          if (currentState is AttendanceSaveCallResponseState ||
              currentState is PunchOutWebMethodState ||
              currentState is PunchAttendenceSaveResponseState ||
              currentState is PunchWithoutAttendenceSaveResponseState ||
              currentState is LogOutCountResponseState) {
            return true;
          }
          //return true for state for which listener method should be called
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context123) {
    //getcurrentTimeInfoFromMain(context123);

    final w = (MediaQuery.of(context).size.width - runSpacing * (4 - 1)) / 4;

    print("FromScreen" + ConstantMAster.toString());
    if (Platform.isAndroid) {
      // Android-specific code

      // IsExistInIOS = true;
      if (AndroidAppStatus == "Active") {
        IsExistInIOS = true;
      } else {
        IsExistInIOS = false;
      }
      print("ISIOS" + "Android-specific code");
    } else if (Platform.isIOS) {
      // iOS-specific code

      if (IOSAPPStatus == "Active") {
        IsExistInIOS = true;
      } else {
        IsExistInIOS = false;
      }
      print("ISIOS" + "iOS-specific code");
    }

    return IsExistInIOS == true
        ? Scaffold(
            backgroundColor: colorGray,
            appBar: AppBar(
              leading: Builder(
                builder: (context) => Container(
                  margin: EdgeInsets.only(top: 14, left: 10),
                  child: IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              title: Container(
                margin: EdgeInsets.only(top: 20),
                child: FlutterShine(
                  light: Light(intensity: 1, position: Point(5, 5)),
                  builder: (BuildContext context, ShineShadow shineShadow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "DashBoard",
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              backgroundColor: colorVeryLightGray,
              foregroundColor: colorPrimary,
              elevation: 0,
              primary: false,
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    UserProfileDialog(context1: context123);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Icon(
                      Icons.person_pin_rounded,
                      size: 30,
                      color: colorPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    return showDialog(
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
                                  "Daily Operations",
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
                                height: 450,
                                width: double.infinity,
                                child: QuickAttendanceScreen()),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  child: /*getCommonButton(baseTheme, () {
                                  Navigator.pop(context);
                                }, "Close"),*/
                                      Column(
                                    children: [
                                      Divider(
                                        thickness: 2,
                                      ),
                                      getCommonButton(baseTheme, () {
                                        Navigator.pop(context);
                                      }, "Close", radius: 25.0),
                                      /*Text(
                                      "Close",
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),*/
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Icon(
                      Icons.watch_later,
                      size: 30,
                      color: colorPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    SharedPrefHelper.instance.prefs.setString("Is_Dealer", "");
                    _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                            "BLG3-AF78-TO5F-NW16"
                        ? _onTaptoLogOutBluetone()
                        : _onTapOfLogOut();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Icon(
                      Icons.login,
                      size: 30,
                      color: colorPrimary,
                    ),
                  ),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _dashBoardScreenBloc.add(CompanyDetailsCallEvent(
                    CompanyDetailsApiRequest(
                        serialKey: _offlineLoggedInData.details[0].serialKey
                            .toString())));

                checkPermissionStatus();

                checkPhotoPermissionStatus();
                getcurrentTimeInfoFromMaindfd();

                _dashBoardScreenBloc.add(AttendanceCallEvent(
                    AttendanceApiRequest(
                        pkID: "",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        Month: selectedDate.month.toString(),
                        Year: selectedDate.year.toString(),
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID)));
                _dashBoardScreenBloc.add(ConstantRequestEvent(
                    CompanyID.toString(),
                    ConstantRequest(
                        ConstantHead: "AttendenceWithImage",
                        CompanyId: CompanyID.toString())));
                _dashBoardScreenBloc.add(MenuRightsCallEvent(MenuRightsRequest(
                    CompanyID: CompanyID.toString(),
                    LoginUserID: LoginUserID)));
              },
              child: Container(
                color: colorWhite,
                padding: EdgeInsets.only(
                  left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                ),
                child: /*ISDelaer == "Dealer"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: 5.0, left: 10, right: 10, bottom: 5),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                childAspectRatio: (200 / 200),

                                ///200,300
                              ),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: makeDashboardItem(
                                      arr_ALL_Name_ID_For_Lead[index].Name,
                                      Icons.person,
                                      context123,
                                      arr_ALL_Name_ID_For_Lead[index].Name1),
                                );
                              },
                            ))
                      ],
                    )
                  :*/
                    ListView(
                  children: [
                    ///___________________Leads____________________________
                    arr_ALL_Name_ID_For_Lead.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                islead = !islead;

                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_LEAD,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Leads",
                                                style: TextStyle(
                                                    color: colorWhite,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              /*  Container(
                                              width: 200,
                                              height: 1,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              color: colorWhite,
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Contacts",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Followup",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Inquiry",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Quotation",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ],
                                            )*/
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          islead == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Lead.length != 0
                        ? Visibility(
                            visible: islead,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Lead.length, (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Lead[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Lead[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    ///___________________Sales______________________________

                    arr_ALL_Name_ID_For_Sales.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isSale = !isSale;

                                islead = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_SALES,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Sales",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            /*  Container(
                                            width: 200,
                                            height: 1,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            color: colorWhite,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("SalesOrder",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("SalesBill",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                          ],
                                        ),
                                        Icon(
                                          isSale == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Sales.length != 0
                        ? Visibility(
                            visible: isSale,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Sales.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Sales[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Sales[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///____________________Production_______________________

                    arr_ALL_Name_ID_For_Production.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isProduction = !isProduction;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_PRODUCTION,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Production",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              width: 200,
                                              height: 1,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              color: colorWhite,
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Inward",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("OutWord",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Icon(
                                          isProduction == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Production.length != 0
                        ? Visibility(
                            visible: isProduction,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Production.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Production[
                                                    index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Production[
                                                    index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///____________________Account_________________________

                    arr_ALL_Name_ID_For_Account.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isAccount = !isAccount;
                                islead = false;
                                isSale = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_ACCOUNT,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Account",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            /*  Container(
                                            width: 200,
                                            height: 1,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            color: colorWhite,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("voucher",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("journal",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                          ],
                                        ),
                                        Icon(
                                          isAccount == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Account.length != 0
                        ? Visibility(
                            visible: isAccount,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Account.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Account[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Account[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    ///___________________HR_______________________________

                    arr_ALL_Name_ID_For_HR.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isHR = !isHR;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_HR,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "HR",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            /*Container(
                                            width: 200,
                                            height: 1,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            color: colorWhite,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("Leave",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("MissedPunch",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                          ],
                                        ),
                                        Icon(
                                          isHR == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_HR.length != 0
                        ? Visibility(
                            visible: isHR,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_HR.length, (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_HR[index].Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_HR[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///__________________Purchase__________________________

                    arr_ALL_Name_ID_For_Purchase.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isPurchase = !isPurchase;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_PURCHASE,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Purchase",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            /* Container(
                                            width: 200,
                                            height: 1,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            color: colorWhite,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("PurchaseOrder",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("PurchaseBill",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                          ],
                                        ),
                                        Icon(
                                          isPurchase == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Purchase.length != 0
                        ? Visibility(
                            visible: isPurchase,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Purchase.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Purchase[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Purchase[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    ///___________________Office____________________________

                    arr_ALL_Name_ID_For_Office.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isOffice = !isOffice;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_OFFICE,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Office",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            /* Container(
                                            width: 200,
                                            height: 1,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            color: colorWhite,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("PendingTask",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                children: [
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                  Text("Activity",
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                          ],
                                        ),
                                        Icon(
                                          isOffice == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Office.length != 0
                        ? Visibility(
                            visible: isOffice,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Office.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Office[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Office[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    ///___________________Support____________________________

                    arr_ALL_Name_ID_For_Support.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isSupport = !isSupport;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_SUPPORT,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Support",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            /* Container(
                                              width: 200,
                                              height: 1,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              color: colorWhite,
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Open",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Text("0",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Closed",
                                                        style: TextStyle(
                                                            color: colorWhite,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ],
                                            )*/
                                          ],
                                        ),
                                        Icon(
                                          isSupport == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Support.length != 0
                        ? Visibility(
                            visible: isSupport,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Support.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Support[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Support[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    /*   arr_ALL_Name_ID_For_Support.length != 0
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: 10, top: 15, right: 10),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(25)),
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.ac_unit,
                                        color: colorWhite,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "  Support",
                                          style: TextStyle(
                                              color: colorWhite,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      arr_ALL_Name_ID_For_Support.length != 0
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      arr_ALL_Name_ID_For_Support.length != 0
                          ? Container(
                              margin: EdgeInsets.only(
                                  top: 5.0, left: 10, right: 10, bottom: 5),
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                  childAspectRatio: (150 / 150),
                                ),
                                itemCount:
                                    arr_ALL_Name_ID_For_Support.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: makeDashboardItem(
                                        arr_ALL_Name_ID_For_Support[index]
                                            .Name,
                                        Icons.person,
                                        context123,
                                        arr_ALL_Name_ID_For_Support[index]
                                            .Name1),
                                  );
                                },
                              ))
                          : Container(),*/

                    //  arr_ALL_Name_ID_For_Dealer
                    ///___________________Dealer___________________________

                    arr_ALL_Name_ID_For_Dealer.length != 0
                        ? SizedBox(
                            height: 20,
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Dealer.length != 0
                        ? Container(
                            margin: EdgeInsets.only(
                                top: 5.0, left: 10, right: 10, bottom: 5),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: (100 / 100),
                              ),
                              itemCount: arr_ALL_Name_ID_For_Dealer.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: makeDashboardItem(
                                      arr_ALL_Name_ID_For_Dealer[index].Name,
                                      Icons.person,
                                      context123,
                                      arr_ALL_Name_ID_For_Dealer[index].Name1),
                                );
                              },
                            ))
                        : Container(),
                  ],
                ),
              ),
            ),
            drawer: build_Drawer(
              context: context123,
              UserName: _offlineLoggedInData.details[0].userID,
              RolCode: _offlineLoggedInData.details[0].roleName,
            ),
          )
        : Scaffold(
            body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                IOSBAND,
                height: 200,
                width: 200,
              )),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "You Are No Longer Available To Use This App !" +
                      "\nIf You want to access this App then Please Contact To Our Department.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorBlack,
                      fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Text(
                  "Email: info@sharvayainfotech.com" +
                      "\nContact No.: +91 9099988302",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                      fontSize: 12),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  /* if (Platform.isAndroid) {
                   /// SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }*/
                  await SharedPrefHelper.instance
                      .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
                  _dashBoardScreenBloc
                    ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
                        CompanyId: CompanyID.toString(),
                        UserID: LoginUserID,
                        TokenNo: "")));
                  SharedPrefHelper.instance
                      .putBool(SharedPrefHelper.IS_REGISTERED, false);
                  //SharedPrefHelper.instance.setBaseURL("");
                  navigateTo(context, SerialKeyScreen.routeName,
                      clearAllStack: true);
                },
                child: Card(
                    color: colorPrimary,
                    child: Container(
                      // width: double.infinity,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: Text(
                          "Close",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colorWhite),
                        ),
                      ),
                    )),
              )
            ],
          ));
  }

  Future<void> _onTapOfLogOut() async {
    await SharedPrefHelper.instance
        .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
    _dashBoardScreenBloc
      ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
          CompanyId: CompanyID.toString(), UserID: LoginUserID, TokenNo: "")));
    navigateTo(context, FirstScreen.routeName, clearAllStack: true);
  }

  void _onDashBoardCallSuccess(
      MenuRightsEventResponseState response, BuildContext context123) {
    checkPermissionStatus();

    // array_MenuRightsList.clear();
    arr_UserRightsWithMenuName.clear();
    SharedPrefHelper.instance.setMenuRightsData(response.menuRightsResponse);

    EmailTO.text = "";
    arr_ALL_Name_ID_For_HR.clear();
    arr_ALL_Name_ID_For_Lead.clear();
    arr_ALL_Name_ID_For_Office.clear();
    arr_ALL_Name_ID_For_Support.clear();
    arr_ALL_Name_ID_For_Purchase.clear();
    arr_ALL_Name_ID_For_Production.clear();
    arr_ALL_Name_ID_For_Sales.clear();
    arr_ALL_Name_ID_For_Account.clear();
    arr_ALL_Name_ID_For_Dealer.clear();
    /*response.menuRightsResponse.details
        .sort((a, b) => a.toString().compareTo(b.toString()));*/
    for (var i = 0; i < response.menuRightsResponse.details.length; i++) {
      print("MenuRightsResponseFromScreen : " +
          response.menuRightsResponse.details[i].menuName);

      ///-----------------------------------------Leads----------------------------------------

      if (i == 0) {
        //ProductMasterListScreen
      }

      if (response.menuRightsResponse.details[i].menuName == "pgInquiry") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Inquiry";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/gen-lead.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);

        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "SI08-SB94-MY45-RY15" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Quick Inquiry";
          all_name_id1.Name1 =
              "http://demo.sharvayainfotech.in/images/quick_inquiry.jpg";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);
        }
      }

      if (response.menuRightsResponse.details[i].menuName ==
          "pgInquiryInfoBlue") {
        if (_offlineLoggedInData.details[0].serialKey ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "BlueToneInquiry";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/gen-lead.png";
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "BlueToneQuickInquiry";
          all_name_id1.Name1 =
              "http://demo.sharvayainfotech.in/images/quick_inquiry.jpg";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Inquiry";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/gen-lead.png";

          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                  "SI08-SB94-MY45-RY15" ||
              _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                  "TEST-0000-SI0F-0208") {
            ALL_Name_ID all_name_id1 = ALL_Name_ID();
            all_name_id1.Name = "Quick Inquiry";
            all_name_id1.Name1 =
                "http://demo.sharvayainfotech.in/images/quick_inquiry.jpg";
            arr_ALL_Name_ID_For_Lead.add(all_name_id1);
          }

          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgFollowup") {
        /*ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Follow-up";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/contact.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);*/

        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "SW0T-GLA5-IND7-AS71" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "SI08-SB94-MY45-RY15") {
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Quick Follow-up";
          all_name_id1.Name1 =
              "http://demo.sharvayainfotech.in/images/contact.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);

          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "SI08-SB94-MY45-RY15") {
            ALL_Name_ID all_name_id1 = ALL_Name_ID();
            all_name_id1.Name = "Follow-up";
            all_name_id1.Name1 =
                "http://demo.sharvayainfotech.in/images/contact.png";
            arr_ALL_Name_ID_For_Lead.add(all_name_id1);
          }
        } else {
          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "TEST-0000-SI0F-0208") {
            ALL_Name_ID all_name_id1 = ALL_Name_ID();
            all_name_id1.Name = "Quick Follow-up";
            all_name_id1.Name1 =
                "http://demo.sharvayainfotech.in/images/contact.png";
            arr_ALL_Name_ID_For_Lead.add(all_name_id1);

            ALL_Name_ID all_name_id12 = ALL_Name_ID();
            all_name_id12.Name = "Follow-up";
            all_name_id12.Name1 =
                "http://demo.sharvayainfotech.in/images/contact.png";
            arr_ALL_Name_ID_For_Lead.add(all_name_id12);
          } else {
            ALL_Name_ID all_name_id1 = ALL_Name_ID();
            all_name_id1.Name = "Follow-up";
            all_name_id1.Name1 =
                "http://demo.sharvayainfotech.in/images/contact.png";
            arr_ALL_Name_ID_For_Lead.add(all_name_id1);
          }
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgQuotation") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Quotation";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/payment.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExternalLeads") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Portal Leads";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/users.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
        /* if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "dol2-6uh7-ph03-in5h") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Portal Leads";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/users.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }*/
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgTeleCaller") {
        /*  if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "dol2-6uh7-ph03-in5h") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "TeleCaller";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/telecaller.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }*/

        if (_offlineLoggedInData.details[0].serialKey
                .toString()
                .toLowerCase() ==
            "sw0t-gla5-ind7-as71") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Tele Caller";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/telecaller.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "TeleCaller";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/telecaller.png";
          all_name_id.PresentDate = "GeneralTeleCaller";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }
      }

      ///_________________________________Sales____________________________________________________
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesOrder") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "dol2-6uh7-ph03-in5h") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "SalesOrder";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/invoice.png";
          arr_ALL_Name_ID_For_Sales.add(all_name_id);
        }

        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Sales Target";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/Target.png";
        arr_ALL_Name_ID_For_Sales.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesBill") {
        {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "SalesBill";
          all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/sale.png";
          arr_ALL_Name_ID_For_Sales.add(all_name_id);
        }
      }

      ///__________________________________Production____________________________________________________

      if (response.menuRightsResponse.details[i].menuName ==
          "pgPackingChecklist") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Packing Checklist";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/inspection.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgChecking") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Final Checking";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/Packing.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInstallation") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Installation";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/Packing.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgProductionActivity") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Production Activity";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/Worklog.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Inward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/Inward.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgOutward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Outward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/Outward.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialMovementInward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Store Inward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/inbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialMovementOutward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Store Outward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/outbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialConsumption") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Consumption";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/consumption.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInspection") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Inspection Check List";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/inspection.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJobCardInward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Job Card Inward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/inbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJobCardOutward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Job Card Outward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/outbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgIndent") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Indent";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/indent.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSiteSurvey") {
        if (_offlineLoggedInData.details[0].serialKey
                .toUpperCase()
                .toString() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Site Survey";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/survey.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);

          ALL_Name_ID all_name_id2 = ALL_Name_ID();
          all_name_id2.Name = "Site Survey Report";
          all_name_id2.Name1 =
              "http://demo.sharvayainfotech.in/images/survey.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id2);
        }
      }

      ///-------------------------------------Account---------------------------------------------------------

      else if (response.menuRightsResponse.details[i].menuName ==
          "pgBankVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "BankVoucher";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/bank.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      }
      /*else if (response.menuRightsResponse.details[i].menuName ==
          "pgCashVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "CashVoucher";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/money.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgCreditNote") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Credit Note";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/credit.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgDebitNote") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Debit Note";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/debit.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPettyCash") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Petty Cash";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/petty.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExpenseVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Exp.Voucher";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/expenses.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJournalVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Journal Voucher";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/journal.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      }
*/

      ///-------------------------------------HR---------------------------------------------------------
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgLeaveRequest") {
        //isExpenseExist = true;

        //  break;
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Leave Request";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/leave.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgLeaveApprovalView") {
        //isExpenseExist = true;

        //  break;
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Leave Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";

        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgAttendance") {
        //isExpenseExist = true;

        //  break;
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Attendance";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/attendance.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExpense") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Expense";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/Expense.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgEmployee") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Employee";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/participant.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgLoanApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Loan Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMissedPunch") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Missed Punch";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/attendance.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMissedPunchApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Missed Punch Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgAdvance") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Salary Adv/Upad";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/salary.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName == "pgLoan") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Loan Installments";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/salary.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      }

      ///----------------------------------Purchase________________________________________________________

      else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurcOrder") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Order";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/purchaseorder.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurchaseOrderApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Order Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurchaseBill") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Bill";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/buy.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      }

      ///------------------------------------Office_________________________________________________________
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgDailyActivity") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Daily Activities";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/dailyactivity.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName == "pgToDO") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "To-Do";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/Task.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id);

        /*ALL_Name_ID all_name_id2 = ALL_Name_ID();
        all_name_id2.Name = "Activity Summary";
        all_name_id2.Name1 = "http://demo.sharvayainfotech.in/images/Task.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id2);*/

        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
            "si08-sb94-my45-ry15") {
          if (LoginUserID == "satish") {
            ALL_Name_ID all_name_id2 = ALL_Name_ID();
            all_name_id2.Name = "Activity Summary";
            all_name_id2.Name1 =
                "http://demo.sharvayainfotech.in/images/Task.png";
            arr_ALL_Name_ID_For_Office.add(all_name_id2);
          }
        }
      }

      ///------------------------------------Support_________________________________________________________
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgComplaint") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "acsi-c803-cup0-shel") {
          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "VK34-SOFG-NDH2-35JK") {
            ALL_Name_ID all_name_id = ALL_Name_ID();
            all_name_id.Name = "Technical Visit";
            all_name_id.Name1 =
                "http://demo.sharvayainfotech.in/images/angry-emoji.jpg";
            arr_ALL_Name_ID_For_Support.add(all_name_id);
          } else {
            if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-SI0F-0208") {
              ALL_Name_ID all_name_id = ALL_Name_ID();
              all_name_id.Name = "Technical Visit";
              all_name_id.Name1 =
                  "http://demo.sharvayainfotech.in/images/angry-emoji.jpg";
              arr_ALL_Name_ID_For_Support.add(all_name_id);

              ALL_Name_ID all_name_id5 = ALL_Name_ID();
              all_name_id5.Name = "Complaint";
              all_name_id5.Name1 =
                  "http://demo.sharvayainfotech.in/images/angry-emoji.jpg";
              arr_ALL_Name_ID_For_Support.add(all_name_id5);
            } else {
              ALL_Name_ID all_name_id = ALL_Name_ID();
              all_name_id.Name = "Complaint";
              all_name_id.Name1 =
                  "http://demo.sharvayainfotech.in/images/angry-emoji.jpg";
              arr_ALL_Name_ID_For_Support.add(all_name_id);
            }
          }
        }
      } else if (response.menuRightsResponse.details[i].menuName == "pgVisit") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "acsi-c803-cup0-shel") {
          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "TEST-0000-SI0F-0208") {
            ALL_Name_ID all_name_id = ALL_Name_ID();
            all_name_id.Name = "HemaAttendVisit";
            all_name_id.Name1 =
                "http://demo.sharvayainfotech.in/images/visit.png";
            arr_ALL_Name_ID_For_Support.add(all_name_id);

            ALL_Name_ID all_name_id3 = ALL_Name_ID();
            all_name_id3.Name = "Attend Visit";
            all_name_id3.Name1 =
                "http://demo.sharvayainfotech.in/images/visit.png";
            arr_ALL_Name_ID_For_Support.add(all_name_id3);
          } else {
            ALL_Name_ID all_name_id = ALL_Name_ID();
            all_name_id.Name = "Attend Visit";
            all_name_id.Name1 =
                "http://demo.sharvayainfotech.in/images/visit.png";
            arr_ALL_Name_ID_For_Support.add(all_name_id);
          }
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgContractInfo") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Maintenance Contract";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/amc.png";
        arr_ALL_Name_ID_For_Support.add(all_name_id);
      }

      if (ISDelaer == "Dealer") {
        arr_ALL_Name_ID_For_HR.clear();
        arr_ALL_Name_ID_For_Lead.clear();
        arr_ALL_Name_ID_For_Office.clear();
        arr_ALL_Name_ID_For_Support.clear();
        arr_ALL_Name_ID_For_Purchase.clear();
        arr_ALL_Name_ID_For_Production.clear();
        arr_ALL_Name_ID_For_Sales.clear();
        arr_ALL_Name_ID_For_Account.clear();

        if (i == 0) {
          ALL_Name_ID all_name_id0 = ALL_Name_ID();
          all_name_id0.Name = "Customer";
          all_name_id0.Name1 =
              "http://demo.sharvayainfotech.in/images/profile.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id0);

          ALL_Name_ID all_name_id2 = ALL_Name_ID();
          all_name_id2.Name = "Product";
          all_name_id2.Name1 =
              "http://demo.sharvayainfotech.in/images/searchproduct.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id2);

          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "SalesBill";
          all_name_id.Name1 = "http://122.169.111.101:308/images/sale.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id);

          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Purchase Bill";
          all_name_id1.Name1 = "http://122.169.111.101:308/images/buy.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id1);

          ALL_Name_ID all_name_id3 = ALL_Name_ID();
          all_name_id3.Name = "BankVoucher";
          all_name_id3.Name1 = "http://122.169.111.101:308/images/bank.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id3);

          ALL_Name_ID all_name_id4 = ALL_Name_ID();
          all_name_id4.Name = "CashVoucher";
          all_name_id4.Name1 = "http://122.169.111.101:308/images/money.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id4);
        }
      }
    }

    if (ISDelaer != "Dealer") {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = "Customer";
      all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/profile.png";
      arr_ALL_Name_ID_For_Lead.add(all_name_id);

      ALL_Name_ID all_name_id1 = ALL_Name_ID();
      all_name_id1.Name = "Product";
      all_name_id1.Name1 =
          "http://demo.sharvayainfotech.in/images/searchproduct.png";
      arr_ALL_Name_ID_For_Lead.add(all_name_id1);
    }

    if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
        "aasi-67ro-h01i-zh6u") {
      arr_ALL_Name_ID_For_HR.clear();
      arr_ALL_Name_ID_For_Lead.clear();
      // arr_ALL_Name_ID_For_Office.clear();
      arr_ALL_Name_ID_For_Support.clear();
      arr_ALL_Name_ID_For_Purchase.clear();
      arr_ALL_Name_ID_For_Production.clear();
      arr_ALL_Name_ID_For_Sales.clear();
      arr_ALL_Name_ID_For_Account.clear();
    }
    arr_ALL_Name_ID_For_Office
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));
    arr_ALL_Name_ID_For_HR
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));
    /* arr_ALL_Name_ID_For_Lead
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));*/
    arr_ALL_Name_ID_For_Office
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));

    arr_ALL_Name_ID_For_Support
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));

    for (var i = 0; i < arr_ALL_Name_ID_For_HR.length; i++) {
      print("MenuRightsHR : " + arr_ALL_Name_ID_For_HR[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Lead.length; i++) {
      print("MenuRightsSales : " + arr_ALL_Name_ID_For_Lead[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Office.length; i++) {
      print("MenuRightsOffice : " + arr_ALL_Name_ID_For_Office[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Support.length; i++) {
      print("MenuRightsSupport : " + arr_ALL_Name_ID_For_Support[i].Name);
    }
  }

  _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListByStatusCallResponseState state) {
    print("testweb" + state.response.details[0].employeeName);
    SharedPrefHelper.instance.setFollowerEmployeeListData(state.response);
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    print("_offlineFollowerEmployeeListData" +
        _offlineFollowerEmployeeListData.details[0].employeeName +
        "");
  }

  void _onALLEmployeeListByStatusCallSuccess(
      ALL_EmployeeNameListResponseState state) {
    SharedPrefHelper.instance
        .setALLEmployeeListData(state.all_employeeList_Response);
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();
    print("_offlineALLEmployeeListData" +
        _offlineALLEmployeeListData.details[0].employeeName +
        "");
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
        // timeChangesEvent();
      }
    } else {
      isPunchIn = false;
      isPunchOut = false;
    }
  }

  _getCurrentLocation() {
    geolocator123
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best)
        .then((Position position) async {
      Longitude = position.longitude.toString();
      Latitude = position.latitude.toString();

      LatitudeHome = Latitude;
      LongitudeHome = Longitude;
      SharedPrefHelper.instance.setLatitude(Latitude);
      SharedPrefHelper.instance.setLongitude(Longitude);
      /*if (MapAPIKey != "") {
        Address = await getAddressFromLatLng(Latitude, Longitude, MapAPIKey);
      } else {
        Address = "";
      }*/
    }).catchError((e) {
      print(e);
    });

    location.onLocationChanged.listen((LocationData currentLocation) async {
      // Use current location
      print("OnLocationChange" +
          " Location : " +
          MapAPIKey +
          currentLocation.latitude.toString());
      Latitude = currentLocation.latitude.toString();
      Longitude = currentLocation.longitude.toString();
      LatitudeHome = Latitude;
      LongitudeHome = Longitude;
      SharedPrefHelper.instance.setLatitude(Latitude);
      SharedPrefHelper.instance.setLongitude(Longitude);
    });
  }

  void checkPermissionStatus() async {
    if (!await location.serviceEnabled()) {
      // location.requestService();

      if (Platform.isAndroid) {
        location.requestService();
        /*showCommonDialogWithSingleOption(Globals.context,
            "Can't get current location, Please make sure you enable GPS and try again !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          AppSettings.openLocationSettings();
          Navigator.pop(context);
        });*/
      }
    }
    bool granted = await Permission.location.isGranted;
    bool Denied = await Permission.location.isDenied;
    bool PermanentlyDenied = await Permission.location.isPermanentlyDenied;

    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());

    if (Denied == true) {
      // openAppSettings();
      is_LocationService_Permission = false;
/*      showCommonDialogWithSingleOption(context,
          "Location permission is required , You have to click on OK button to Allow the location access !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
        await openAppSettings();
        Navigator.of(context).pop();
      });*/
      await Permission.storage.request();

      // await Permission.location.request();
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      is_LocationService_Permission = false;
      openAppSettings();
    }

    if (granted == true) {
      // The OS restricts access, for example because of parental controls.
      is_LocationService_Permission = true;
      _getCurrentLocation();

      /*if (serviceLocation == true) {
        // Use location.
        _serviceEnabled=false;

         location.requestService();


      }
      else{
        _serviceEnabled=true;
        _getCurrentLocation();



      }*/
    }
  }

  Future<String> getAddressFromLatLngMapMyIndia(
      String lat, String lng, String skey) async {
    String _host =
        'https://apis.mapmyindia.com/advancedmaps/v1/$skey/rev_geocode';
    final url = '$_host?lat=$lat&lng=$lng';

    print("MapRequest" + url);
    if (lat != "" && lng != "null") {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        //Address = _formattedAddress;
        print("response ==== $_formattedAddress");
        return _formattedAddress;
      } else
        return null;
    } else
      return null;
  }

  void _onAttandanceSaveResponse(AttendanceSaveCallResponseState state) {
    // state.response.details[0].column2

    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  void _onPunchAttandanceSaveResponse(PunchAttendenceSaveResponseState state) {
    // state.response.details[0].column2

    // print("Saevf" + state.punchAttendenceSaveResponse.details[0].column1);

    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  void _OnFethEmployeeImage(EmployeeListResponseState state) {
    for (int i = 0; i < state.employeeListResponse.details.length; i++) {
      if (_offlineLoggedInData.details[0].employeeID ==
          state.employeeListResponse.details[i].pkID) {
        if (state.employeeListResponse.details[i].employeeImage != "") {
          ImgFromTextFiled.text = "";
          ImgFromTextFiled.text = _offlineCompanyData.details[0].siteURL +
              state.employeeListResponse.details[i].employeeImage;

          print("rjrjj" + EmployeeImage);
          break;
        }
      }
    }
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

      return showCommonDialogWithSingleOption(Globals.context,
          "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        //navigateTo(context, HomeScreen.routeName, clearAllStack: true);
        Navigator.pop(Globals.context);
      });
    } else {
      isCurrentTime = true;
    }
  }

  void _OnTokenUpdateResponse(APITokenUpdateState state) {
    if (state.firebaseTokenResponse.details[0].column2 != "") {
      print("APDdfd" +
          " API Token Response : " +
          state.firebaseTokenResponse.details[0].column2);
    }
  }

  void MovetoFollowupScreen(
      BuildContext Notifycontext, String Title, String BodyDetails) {
    SplitSTr = BodyDetails.split("By");
    print("NotificationSplitedValue" +
        " Value : " +
        SplitSTr[0].toString() +
        " 2nd : " +
        SplitSTr[1].toString());
    //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);

    navigateTo(Notifycontext, FollowupListScreen.routeName,
            clearAllStack: true,
            arguments: FollowupListScreenArguments(SplitSTr[1].toString()))
        .then((value) {
      SplitSTr = [];
    });
  }

  onTimerFinished() {}

  void _OnwebSucessResponse(PunchOutWebMethodState state) {
    print("Webresponse" + state.response);
  }

  void registerNotification() async {
    /* await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );*/
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!' +
          message.notification.title);
      print("message Id - onMessageOpenedApp ${message.messageId}");
      if (Globals.objectedNotifications.contains(message.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(message.messageId);
      if (message.data['title'] == "Inquiry") {
        // navigateTo(context, InquiryListScreen.routeName,clearAllStack: true);
        Navigator.pushNamed(
          Globals.context,
          InquiryListScreen.routeName,
          arguments: MessageArguments(message, true),
        );
      } else if (message.data['title'] == "Follow-up") {
        navigateTo(Globals.context, FollowupListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "FollowUp") {
        MovetoFollowupScreen(Globals.context, message.notification.title,
            message.notification.body);
      } else if (message.data['title'] == "Quotation") {
        navigateTo(Globals.context, QuotationListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Sales Order") {
        navigateTo(Globals.context, SalesOrderListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Sales Invoice") {
        navigateTo(Globals.context, SalesBillListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Complaint") {
        navigateTo(Globals.context, ComplaintPaginationListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "To-Do") {
        navigateTo(Globals.context, ToDoListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Leave Request") {
        navigateTo(Globals.context, LeaveRequestListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "TeleCaller") {
        navigateTo(Globals.context, TeleCallerListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Quick Inquiry") {
        navigateTo(Globals.context, InquiryListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Portal Lead") {
        navigateTo(Globals.context, ExternalLeadListScreen.routeName,
            clearAllStack: true);
      }
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Grant the Permission");
    } else {
      print("Permission Decline By User");
    }
  }

  /* checkIntialMessage() async {
    RemoteMessage intialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (intialMessage != null) {
      print("message Id - intialMessage ${intialMessage.messageId}");
      if (Globals.objectedNotifications.contains(intialMessage.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(intialMessage.messageId);

      */ /* PushNotification notification = PushNotification(
        title: intialMessage.notification!.title,
        body: intialMessage.notification!.body,
        dataTitle: intialMessage.data['title'],
        databody: intialMessage.data['body']
    );*/ /*

      if (intialMessage.data['title'] == "Inquiry") {
        navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
      } else if (intialMessage.data['title'] == "Follow-up") {
        navigateTo(Globals.context, FollowupListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "FollowUp") {
        MovetoFollowupScreen(
            context, intialMessage.data['title'], intialMessage.data['body']);

        //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
      } else if (intialMessage.data['title'] == "Quotation") {
        navigateTo(Globals.context, QuotationListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Sales Order") {
        navigateTo(Globals.context, SalesOrderListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Sales Invoice") {
        navigateTo(Globals.context, SalesBillListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Complaint") {
        navigateTo(Globals.context, ComplaintPaginationListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "To-Do") {
        navigateTo(Globals.context, ToDoListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Leave Request") {
        navigateTo(Globals.context, LeaveRequestListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "TeleCaller") {
        navigateTo(Globals.context, TeleCallerListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Quick Inquiry") {
        navigateTo(Globals.context, InquiryListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Portal Lead") {
        navigateTo(Globals.context, ExternalLeadListScreen.routeName,
            clearAllStack: true);
      }

      //
    }
  }*/

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
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

          Lunch_In_OUT_File = file;
        }
      } catch (e) {
        print("775757" + e.toString());
      }

      setState(() {});
    }
  }

  void _onGetConstant(ConstantResponseState state) {
    print("ConstantValue" + state.response.details[0].value.toString());

    ConstantMAster = state.response.details[0].value.toString();
  }

  void _OnPunchOutWithoutImageSucess(
      PunchWithoutAttendenceSaveResponseState state) {
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  Future<void> OpenDriveLink(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri.parse(phoneNumber);
    await launch(launchUri.toString());
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

  UserProfileDialog({BuildContext context1}) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(8), // Border width
                      decoration: BoxDecoration(
                          color: colorLightGray, shape: BoxShape.circle),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(80), // Image radius
                          child: ImageFullScreenWrapperWidget(
                            child: /*Image.network(ImgFromTextFiled.text,
                                fit: BoxFit.cover)*/
                                ImgFromTextFiled.text != ""
                                    ? Image.network(
                                        ImgFromTextFiled.text,
                                        fit: BoxFit.cover,
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          return child;
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Image.asset(
                                              LOADDER,
                                              height: 100,
                                              width: 100,
                                            );
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace stackTrace) {
                                          return Image.asset(
                                            NO_IMAGE_FOUND,
                                            height: 100,
                                            width: 100,
                                          );
                                        },

                                        // fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        NO_IMAGE_FOUND,
                                        height: 100,
                                        width: 100,
                                      ),
                          ),
                        ),
                      ),
                    ),
                    /*Center(
                      child: Image.network(
                        ImgFromTextFiled.text,
                        key: ValueKey(new Random().nextInt(100)),
                        height: 200,
                        width: 200,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Image.network(
                              "https://img.icons8.com/color/2x/no-image.png",
                              height: 48,
                              width: 48);
                        },
                      ),
                    ),*/
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "User : ",
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                              child: Text(
                                  _offlineLoggedInData.details[0].employeeName,
                                  style: TextStyle(
                                    color: colorBlack,
                                  ))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Role : ",
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                            child:
                                Text(_offlineLoggedInData.details[0].roleName,
                                    style: TextStyle(
                                      color: colorBlack,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "State : ",
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                            child:
                                Text(_offlineLoggedInData.details[0].StateName,
                                    style: TextStyle(
                                      color: colorBlack,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: getCommonButton(baseTheme, () {
                        Navigator.pop(context123);
                      }, "Close", backGroundColor: colorPrimary, radius: 25.0),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  timeChangesEvent() {
    setState(() {
      PuchInboolcontroller.text = isPunchIn.toString();
      PuchOutboolcontroller.text = isPunchOut.toString();
      LunchInboolcontroller.text = isLunchIn.toString();
      LunchOutboolcontroller.text = isLunchOut.toString();
    });
  }

  Future<void> _initPackageInfo(String APIMobileVersion) async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;

    int mobileAPIVersion = int.parse(APIMobileVersion);
    int CurrentMobileVersion = int.parse(_packageInfo.buildNumber);
//15
    if (mobileAPIVersion > CurrentMobileVersion) {
      if (Platform.isAndroid == true) {
        await showDialog(
          barrierDismissible: false,
          context: Globals.context,
          builder: (BuildContext context123) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              children: [
                SizedBox(
                    width: MediaQuery.of(context123).size.width,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            GOOGLE_PLAY,
                            width: 200,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 1,
                            color: colorGrayVeryDark,
                          ),
                          Text(
                            "Update App ?",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "A new version of Sharvaya ERP is available on play-store \n would you like to update it now ? ",
                              style: TextStyle(
                                fontSize: 12,
                                color: colorBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Releases Notes :",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Minor updates and improvements.",
                            style: TextStyle(fontSize: 12, color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context123);
                                  }, "Skip",
                                      backGroundColor: colorPrimary,
                                      radius: 25.0),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: getCommonButton(baseTheme, () async {
                                    await launch(
                                      "https://play.google.com/store/apps/details?id=com.sharvayainfotech.eofficedesk",
                                    );
                                  }, "Update",
                                      backGroundColor: colorPrimary,
                                      radius: 25.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            );
          },
        );
      }
      /* if (Platform.isIOS == true) {
        await showDialog(
          barrierDismissible: false,
          context: Globals.context,
          builder: (BuildContext context123) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              children: [
                SizedBox(
                    width: MediaQuery.of(context123).size.width,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            APPSTORE,
                            height: 100,
                            width: 100,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 1,
                            color: colorGrayVeryDark,
                          ),
                          Text(
                            "Update App ?",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "A new version of Sharvaya ERP is available on App-Store \n would you like to update it now ? ",
                              style: TextStyle(
                                fontSize: 12,
                                color: colorBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Releases Notes :",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Minor updates and improvements.",
                            style: TextStyle(fontSize: 12, color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context123);
                                  }, "Skip",
                                      backGroundColor: colorPrimary,
                                      radius: 25.0),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: getCommonButton(baseTheme, () async {
                                    await launch(
                                      "https://apps.apple.com/us/app/sharvaya-erp/id1626023618",
                                    );
                                  }, "Update",
                                      backGroundColor: colorPrimary,
                                      radius: 25.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            );
          },
        );
      }*/
    }

    print("MobileAppVersion123" +
        " BuildNumber : " +
        _packageInfo.buildNumber.toString() +
        " Version : " +
        _packageInfo.version.toString() +
        "MobileAPI" +
        APIMobileVersion);
  }

  void _OnCompanyResponse(ComapnyDetailsEventResponseState state) {
    print(state.companyDetailsResponse.details[0].mobileAppVersion);
    _initPackageInfo(
        state.companyDetailsResponse.details[0].mobileAppVersion.toString());
  }

  _onTaptoLogOutBluetone() {
    _dashBoardScreenBloc.add(LogoutCountRequestEvent(LogoutCountRequest(
        LoginUserID: LoginUserID, CompanyId: CompanyID.toString())));
  }

  void _OnLogoutCount(LogOutCountResponseState state) {
    String msg = " Followup Important Task Missing \n\n" +
        "Todays Count (" +
        state.response.details[0].todayCount.toString() +
        ")" +
        "\n" +
        "Missed Count (" +
        state.response.details[0].missedCount.toString() +
        ")" +
        "\n" +
        "Future Count (" +
        state.response.details[0].futureCount.toString() +
        ")" +
        "\n";

    bool isCompleted = false;

    /* int i = 0;
    int j = 0;
    int k = 0;

    if (i == 0 && j == 0 && k == 0)*/
    if (state.response.details[0].todayCount == 0 &&
        state.response.details[0].missedCount == 0 &&
        state.response.details[0].futureCount == 0) {
      isCompleted = true;
    } else {
      isCompleted = false;
    }

    showCommonDialogWithSingleOption(context, msg,
        onTapOfPositiveButton: () async {
      if (isCompleted == true) {
        await SharedPrefHelper.instance
            .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
        _dashBoardScreenBloc
          ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
              CompanyId: CompanyID.toString(),
              UserID: LoginUserID,
              TokenNo: "")));
        navigateTo(context, FirstScreen.routeName, clearAllStack: true);
      } else {
        navigateTo(context, FollowupListScreen.routeName);
      }
    });
  }
}
