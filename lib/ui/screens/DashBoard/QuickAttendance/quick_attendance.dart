import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/dashboard/dashboard_user_rights_screen_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/punch_attendence_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/punch_without_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/constant_master/constant_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickAttendanceScreen extends BaseStatefulWidget {
  static const routeName = '/QuickAttendanceScreen';

  @override
  _QuickAttendanceScreenState createState() => _QuickAttendanceScreenState();
}

class _QuickAttendanceScreenState extends BaseState<QuickAttendanceScreen>
    with BasicScreen, WidgetsBindingObserver {
  DashBoardScreenBloc _dashBoardScreenBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  bool isPunchIn = false;
  bool isPunchOut = false;
  bool isLunchIn = false;
  bool isLunchOut = false;
  int CompanyID = 0;
  String LoginUserID = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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

  TextEditingController FromDate = TextEditingController();
  TextEditingController ReverseFromDate = TextEditingController();

  TextEditingController ToDate = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    checkCameraPermissionStatus();
    _dashBoardScreenBloc = DashBoardScreenBloc(baseBloc);

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");
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

    _dashBoardScreenBloc.add(ConstantRequestEvent(
        CompanyID.toString(),
        ConstantRequest(
            ConstantHead: "AttendenceWithImage",
            CompanyId: CompanyID.toString())));

    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dashBoardScreenBloc,
      child: BlocConsumer<DashBoardScreenBloc, DashBoardScreenStates>(
        builder: (BuildContext context, DashBoardScreenStates state) {
          if (state is AttendanceListCallResponseState) {
            _OnAttendanceListResponse(state);
          }
          if (state is ConstantResponseState) {
            _onGetConstant(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is AttendanceListCallResponseState ||
              currentState is ConstantResponseState) {
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

          if (state is PunchWithoutAttendenceSaveResponseState) {
            _OnPunchOutWithoutImageSucess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is AttendanceSaveCallResponseState ||
              currentState is PunchOutWebMethodState ||
              currentState is PunchAttendenceSaveResponseState ||
              currentState is PunchWithoutAttendenceSaveResponseState) {
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
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () async {
              getAddressFromLatLong();

              _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
                  pkID: "",
                  EmployeeID:
                      _offlineLoggedInData.details[0].employeeID.toString(),
                  Month: selectedDate.month.toString(),
                  Year: selectedDate.year.toString(),
                  CompanyId: CompanyID.toString(),
                  LoginUserID: LoginUserID)));
              _dashBoardScreenBloc.add(ConstantRequestEvent(
                  CompanyID.toString(),
                  ConstantRequest(
                      ConstantHead: "AttendenceWithImage",
                      CompanyId: CompanyID.toString())));
            },
            child: Container(
              alignment: Alignment.center,
              color: colorVeryLightGray,
              child: SingleChildScrollView(
                child: Column(
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
                                _dashBoardScreenBloc.add(
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

                                /*try {
                                  final file = await imagepicker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 85,
                                  );
                                  if (file == null) {
                                    throw Exception('File is not available');
                                  }
                                } catch (e) {
                                  print(e);
                                }*/

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

                                  _dashBoardScreenBloc
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
                        margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                    color: colorPrimary,
                                  )
                                : Container(),
                            isPunchIn == true
                                ? Text(
                                    PuchInTime.text,
                                    style: TextStyle(
                                        fontSize: 15, color: colorPrimary),
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
                                  _dashBoardScreenBloc.add(
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

                                    _dashBoardScreenBloc
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
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    color: colorPrimary,
                                  )
                                : Container(),
                            isLunchIn == true
                                ? Text(
                                    LunchInTime.text,
                                    style: TextStyle(
                                        fontSize: 15, color: colorPrimary),
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
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    color: colorPrimary,
                                  )
                                : Container(),
                            isLunchOut == true
                                ? Text(
                                    LunchOutTime.text,
                                    style: TextStyle(
                                        fontSize: 15, color: colorPrimary),
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
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    color: colorPrimary,
                                  )
                                : Container(),
                            isPunchOut == true
                                ? Text(
                                    PuchOutTime.text,
                                    style: TextStyle(
                                        fontSize: 15, color: colorPrimary),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_offlineLoggedInData.details[0].serialKey
                                .toUpperCase()
                                .toString() ==
                            "MYA6-G9EC-VS3P-H4PL") {
                          EmailTO.text = "hr@mygec.in";
                        }
                        SendEmailOnlyImg(context1: context, Email: "");
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              isSendEmail == true
                                  ? Icons.email
                                  : Icons.email_outlined,
                              color: isSendEmail == true
                                  ? colorPresentDay
                                  : colorRED,
                              size: 42,
                            ),
                            Card(
                              elevation: 5,
                              color: isSendEmail == false
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
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    // navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    Navigator.pop(context);
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

  void checkCameraPermissionStatus() async {
    bool granted = await Permission.camera.isGranted;
    bool Denied = await Permission.camera.isDenied;
    bool PermanentlyDenied = await Permission.camera.isPermanentlyDenied;
    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());
    if (Denied == true) {
      await Permission.camera.request();
    }
    if (await Permission.camera.isRestricted) {
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

  punchoutLogic() async {
    if (isPunchIn == true) {
      TimeOfDay selectedTime = TimeOfDay.now();

      //EmailTO.text = model.emailAddress;

      /*PunchAttendanceSaveRequest(
        Mode: "punchout",
        pkID: "0",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        PresenceDate: selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString(),
        TimeIn:
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
        TimeOut:
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
        LunchIn: "",
        LunchOut: "",
        LoginUserID: LoginUserID,
        Notes: "",
        Latitude: Latitude,
        Longitude: Longitude,
        LocationAddress: Address,
        CompanyId: CompanyID.toString(),
      );*/
      PunchAttendanceSaveRequest punchAttendanceSaveRequest =
          PunchAttendanceSaveRequest(
        pkID: "0",
        CompanyId: CompanyID.toString(),
        Mode: "punchout",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        FileName: "demo.png",
        PresenceDate: selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString(),
        Time:
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
        Notes: "",
        Latitude: SharedPrefHelper.instance.getLatitude(),
        Longitude: SharedPrefHelper.instance.getLongitude(),
        LocationAddress: Address,
        LoginUserId: LoginUserID,
      );

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
            _dashBoardScreenBloc.add(
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

            File filerty = File(file.path);

            final extension = p.extension(filerty.path);

            int timestamp1 = DateTime.now().millisecondsSinceEpoch;

            /*String filenamepunchout =
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
            */

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

              _dashBoardScreenBloc.add(PunchAttendanceSaveRequestEvent(
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
            } /*else {
              showCommonDialogWithSingleOption(
                  context, "Something Went Wrong File Not Found Exception !",
                  positiveButtonTitle: "OK");
            }*/
          }
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Punch in Is Required !",
          positiveButtonTitle: "OK");
    }
  }

  lunchoutLogic() async {
    if (isLunchIn == true) {
      //EmailTO.text = model.emailAddress;
      TimeOfDay selectedTime = TimeOfDay.now();

      if (isPunchOut == false) {
        PunchAttendanceSaveRequest punchAttendanceSaveRequest =
            PunchAttendanceSaveRequest(
          pkID: "0",
          CompanyId: CompanyID.toString(),
          Mode: "lunchout",
          EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
          FileName: "demo.png",
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
        );
        /* PunchAttendanceSaveRequest(
          Mode: "lunchout",
          pkID: "0",
          EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
          PresenceDate: selectedDate.year.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.day.toString(),
          TimeIn: selectedTime.hour.toString() +
              ":" +
              selectedTime.minute.toString(),
          TimeOut: "",
          LunchIn: selectedTime.hour.toString() +
              ":" +
              selectedTime.minute.toString(),
          LunchOut: selectedTime.hour.toString() +
              ":" +
              selectedTime.minute.toString(),
          LoginUserID: LoginUserID,
          Notes: "",
          Latitude: Latitude,
          Longitude: Longitude,
          LocationAddress: Address,
          CompanyId: CompanyID.toString(),
        );*/

        /*_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                    "SW0T-GLA5-IND7-AS71" ||
                _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                    "SI08-SB94-MY45-RY15" */ /* ||
              _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                  "TEST-0000-SI0F-0208"*/ /*
            ? showcustomdialogSendEmail(
                context1: context, att: punchAttendanceSaveRequest)
            : Container();*/
        // _showMyDialog();

        if (isLunchOut == true) {
          /*if (_offlineLoggedInData
                      .details[0].serialKey
                      .toUpperCase() ==
                  "SW0T-GLA5-IND7-AS71" ||
              _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                  "SI08-SB94-MY45-RY15" ||
              _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                  "TEST-0000-SI0F-0208") {
            showcustomdialogSendEmail(
                context1: context, att: punchAttendanceSaveRequest);
          } else {
            showCommonDialogWithSingleOption(
                context,
                _offlineLoggedInData.details[0].employeeName +
                    " \n Punch Out : " +
                    PuchOutTime.text,
                positiveButtonTitle: "OK");
          }*/

          showCommonDialogWithSingleOption(
              context,
              _offlineLoggedInData.details[0].employeeName +
                  " \n Lunch Out : " +
                  LunchOutTime.text,
              positiveButtonTitle: "OK");
        } else {
          if (ConstantMAster.toString() == "" ||
              ConstantMAster.toString().toLowerCase() == "no") {
            _dashBoardScreenBloc.add(
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

              _dashBoardScreenBloc.add(PunchAttendanceSaveRequestEvent(
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
        /*isLunchOut == true
            ?
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                        "SW0T-GLA5-IND7-AS71" ||
                    _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                        "SI08-SB94-MY45-RY15" ||
                    _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                        "TEST-0000-SI0F-0208"
                ? showcustomdialogSendEmail(
                    context1: context, att: punchAttendanceSaveRequest)
                : showCommonDialogWithSingleOption(
                    context,
                    _offlineLoggedInData.details[0].employeeName +
                        " \n Punch Out : " +
                        PuchOutTime.text,
                    positiveButtonTitle: "OK")
            : _dashBoardScreenBloc.add(PunchAttendanceSaveRequestEvent(
                Lunch_In_OUT_File, punchAttendanceSaveRequest));*/
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

  void _onPunchAttandanceSaveResponse(PunchAttendenceSaveResponseState state) {
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  void _onAttandanceSaveResponse(AttendanceSaveCallResponseState state) {
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
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

  void getAddressFromLatLong() async {
    if (MapAPIKey != "") {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: double.parse(SharedPrefHelper.instance.getLatitude()),
          longitude: double.parse(SharedPrefHelper.instance.getLongitude()),
          googleMapApiKey: MapAPIKey);

      Address = data.address;

      print("data1232332" +
          "Address : " +
          data.address.toString() +
          "MAP API KEY " +
          MapAPIKey);
    }

    /*

    Garediya
Kuva Road,
Raghuveer Para,
Lohana Para, Rajkot,
Gujarat 360001, India

    * */

    print("sfjsdf" +
        Address +
        "Latitude : " +
        SharedPrefHelper.instance.getLatitude());
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
                    /*  InkWell(
                      onTap: () {


                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text("From Date",
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
                              height: 60,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      edt_InquiryDate.text == null || edt_InquiryDate.text == ""
                                          ? "DD-MM-YYYY"
                                          : edt_InquiryDate.text,
                                      style: baseTheme.textTheme.headline3.copyWith(
                                          color: edt_InquiryDate.text == null ||
                                              edt_InquiryDate.text == ""
                                              ? colorGrayDark
                                              : colorBlack),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: colorGrayDark,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () {


                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text("From Date",
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
                              height: 60,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      edt_InquiryDate.text == null || edt_InquiryDate.text == ""
                                          ? "DD-MM-YYYY"
                                          : edt_InquiryDate.text,
                                      style: baseTheme.textTheme.headline3.copyWith(
                                          color: edt_InquiryDate.text == null ||
                                              edt_InquiryDate.text == ""
                                              ? colorGrayDark
                                              : colorBlack),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: colorGrayDark,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),*/
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
                                      EmailTO.text +
                                      "&date1=" +
                                      DateTime.now().year.toString() +
                                      "-" +
                                      DateTime.now().month.toString() +
                                      "-" +
                                      DateTime.now().day.toString() +
                                      "&date2=" +
                                      DateTime.now().year.toString() +
                                      "-" +
                                      DateTime.now().month.toString() +
                                      "-" +
                                      DateTime.now().day.toString();

                                  print("webreq" + webreq);

                                  /*_dashBoardScreenBloc
                                      .add(PunchOutWebMethodEvent(webreq));*/

                                  //APITokenUpdateRequestEvent

                                  _offlineLoggedInData.details[0].serialKey
                                              .toUpperCase() ==
                                          "MYA6-G9EC-VS3P-H4PL"
                                      ? _showMyDialogForMyGec(context123,
                                          EmailTO.text.replaceAll(" ", ""))
                                      : _showMyDialog(context123, EmailTO.text);
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
          /*actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context)
                    .pop(), //  We can return any object from here
                child: Text('NO')),
            */ /* prgresss!=100 ? CircularProgressIndicator() :*/ /* FlatButton(
                onPressed: () => {
                      Navigator.of(context).pop(),
                    }, //  We can return any object from here
                child: Text('YES'))
          ],*/
        );
      },
    );
  }

  Future<void> _showMyDialogForMyGec(
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
                  child: MyGecGenerateQT(dailogContext, textEmaill),
                ),

                //GetCircular123(),
              ],
            ),
          ),
          /*actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context)
                    .pop(), //  We can return any object from here
                child: Text('NO')),
            */ /* prgresss!=100 ? CircularProgressIndicator() :*/ /* FlatButton(
                onPressed: () => {
                      Navigator.of(context).pop(),
                    }, //  We can return any object from here
                child: Text('YES'))
          ],*/
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
                        //  islodding = false;

                        // and cancel the request
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
                    //Navigator.pop(context123);

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

                    /*showCommonDialogWithSingleOption(
                        context, "Email Sent Successfully ",
                        onTapOfPositiveButton: () {
                      //Navigator.pop(context);
                      navigateTo(context, HomeScreen.routeName,
                          clearAllStack: true);
                    });*/
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
                  /*  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    //hide you progressbar here
                    setState(() {
                      islodding = false;
                    });
                  },*/
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      islodding = false;
                    });
                  },
                ),
              ),
            ),
            //CircularProgressIndicator(),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
            // LinearProgressIndicator(value: this.progress)
            /* this.progress < 1.0
                ? LinearProgressIndicator(value: this.progress)
                : Container(),*/
            //
          ],
        ),
      ),
    );
  }

  MyGecGenerateQT(BuildContext dailogContext, String emailTOstr) {
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
                          emailTOstr +
                          "&date1=" +
                          DateTime.now().year.toString() +
                          "-" +
                          DateTime.now().month.toString() +
                          "-" +
                          DateTime.now().day.toString() +
                          "&date2=" +
                          DateTime.now().year.toString() +
                          "-" +
                          DateTime.now().month.toString() +
                          "-" +
                          DateTime.now().day.toString())),
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
                        //  islodding = false;

                        // and cancel the request
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
                    //Navigator.pop(context123);

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;
                        print("dfkpageTitle" + value);

                        if (pageTitle == "") {
                          _showMyDialogForMyGec(
                              dailogContext, EmailTO.text.replaceAll(" ", ""));
                        } else {
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
                        }
                      });
                    });

                    /*showCommonDialogWithSingleOption(
                        context, "Email Sent Successfully ",
                        onTapOfPositiveButton: () {
                      //Navigator.pop(context);
                      navigateTo(context, HomeScreen.routeName,
                          clearAllStack: true);
                    });*/
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
                  /*  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    //hide you progressbar here
                    setState(() {
                      islodding = false;
                    });
                  },*/
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      islodding = false;
                    });
                  },
                ),
              ),
            ),
            //CircularProgressIndicator(),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
            // LinearProgressIndicator(value: this.progress)
            /* this.progress < 1.0
                ? LinearProgressIndicator(value: this.progress)
                : Container(),*/
            //
          ],
        ),
      ),
    );
  }
}
